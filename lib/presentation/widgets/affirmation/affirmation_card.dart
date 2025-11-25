import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/haptic_utils.dart';

/// Self-affirmation card for positive self-talk
class AffirmationCard extends StatefulWidget {
  final VoidCallback? onComplete;
  final List<String>? customAffirmations;

  const AffirmationCard({
    super.key,
    this.onComplete,
    this.customAffirmations,
  });

  @override
  State<AffirmationCard> createState() => _AffirmationCardState();
}

class _AffirmationCardState extends State<AffirmationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  List<String>? _affirmations;
  int _currentIndex = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeController.forward();
  }

  List<String> _getAffirmations(BuildContext context) {
    if (_affirmations != null) return _affirmations!;

    final locale = Localizations.localeOf(context).languageCode;
    final isChinese = locale == 'zh';

    _affirmations = widget.customAffirmations ??
        (isChinese
            ? [
                '我现在很安全',
                '这种感觉会过去的',
                '我的身体只是在释放能量',
                '我会耐心等待平静的回归',
                '我能控制自己的反应',
              ]
            : [
                'I am safe right now',
                'This feeling will pass',
                'My body is just releasing energy',
                'I will wait patiently for calm to return',
                'I am in control of my response',
              ]);

    return _affirmations!;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _nextAffirmation(BuildContext context) async {
    final affirmations = _getAffirmations(context);
    await HapticUtils.light();
    if (_currentIndex < affirmations.length - 1) {
      await _fadeController.reverse();
      setState(() {
        _currentIndex++;
      });
      await _fadeController.forward();
    } else {
      setState(() {
        _isCompleted = true;
      });
    }
  }

  void _previousAffirmation() async {
    if (_currentIndex > 0) {
      await HapticUtils.light();
      await _fadeController.reverse();
      setState(() {
        _currentIndex--;
      });
      await _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isChinese = locale == 'zh';
    final affirmations = _getAffirmations(context);

    // No top buttons here - they are in the parent _buildSpecialCard
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            isChinese ? '自我肯定' : 'Self-Affirmation',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingS),

          // Instructions
          Text(
            isChinese ? '慢慢阅读每句话，让它深入内心' : 'Read each statement slowly and let it sink in',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.whiteWithOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Progress indicator
          Text(
            '${_currentIndex + 1} / ${affirmations.length}',
            style: TextStyle(
              color: AppColors.lilac,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXl),

          // Affirmation display or completion message
          if (_isCompleted)
            _buildCompletionMessage(isChinese)
          else
            _buildAffirmationDisplay(affirmations),

          const SizedBox(height: AppDimensions.spacingXl),

          // Navigation buttons
          if (!_isCompleted) _buildNavigationButtons(context, isChinese, affirmations),
        ],
      ),
    );
  }

  Widget _buildAffirmationDisplay(List<String> affirmations) {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lilac.withValues(alpha: 0.15),
              AppColors.aqua.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.lilac.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.format_quote,
              color: AppColors.lilac.withValues(alpha: 0.5),
              size: 32,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              affirmations[_currentIndex],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(
      BuildContext context, bool isChinese, List<String> affirmations) {
    final isLastItem = _currentIndex == affirmations.length - 1;

    return Row(
      children: [
        if (_currentIndex > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousAffirmation,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
                side: BorderSide(color: AppColors.whiteWithOpacity(0.3)),
              ),
              child: Text(isChinese ? '上一个' : 'Previous'),
            ),
          )
        else
          const Expanded(child: SizedBox()),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _nextAffirmation(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
            ),
            child: Text(isLastItem
                ? (isChinese ? '完成' : 'Complete')
                : (isChinese ? '下一个' : 'Next')),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionMessage(bool isChinese) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.favorite, color: AppColors.success, size: 64),
        const SizedBox(height: AppDimensions.spacingL),
        Text(
          isChinese ? '你很坚强，很有能力' : 'You are strong and capable',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          isChinese ? '将这些话语带在身边' : 'Carry these words with you',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteWithOpacity(0.7),
              ),
          textAlign: TextAlign.center,
        ),
        if (widget.onComplete != null) ...[
          const SizedBox(height: AppDimensions.spacingXl),
          ElevatedButton(
            onPressed: widget.onComplete,
            child: Text(isChinese ? '继续' : 'Continue'),
          ),
        ],
      ],
    );
  }
}
