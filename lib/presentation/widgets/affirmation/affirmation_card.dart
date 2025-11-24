import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/haptic_utils.dart';

/// Self-affirmation card for positive self-talk
/// Guides users through calming affirmation statements
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
    
    _affirmations = widget.customAffirmations ?? (isChinese ? [
      '我现在很安全',
      '这种感觉会过去的',
      '我的身体只是在释放能量',
      '我会耐心等待平静的回归',
      '我能控制自己的反应',
    ] : [
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

    return Stack(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            children: [
              // Top spacing for buttons
              const SizedBox(height: AppDimensions.spacingL * 2),
              
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
            isChinese 
                ? '慢慢阅读每句话，让它深入内心。相信这些话语。'
                : 'Read each statement slowly and let it sink in. Believe in these words.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteWithOpacity(0.8),
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingXs,
            ),
            decoration: BoxDecoration(
              color: AppColors.lilac.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              '${_currentIndex + 1} / ${affirmations.length}',
              style: TextStyle(
                color: AppColors.lilac,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          
          // Affirmation display
          Expanded(
            child: Center(
              child: _isCompleted
                  ? _buildCompletionMessage(isChinese)
                  : _buildAffirmationDisplay(affirmations),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          
          // Navigation buttons
          if (!_isCompleted) ...[
            Row(
              children: [
                // Previous button
                if (_currentIndex > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousAffirmation,
                      icon: const Icon(Icons.arrow_back),
                      label: Text(isChinese ? '上一个' : 'Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingM,
                        ),
                        side: BorderSide(
                          color: AppColors.whiteWithOpacity(0.3),
                        ),
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
                const SizedBox(width: AppDimensions.spacingM),
                
                // Next button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _nextAffirmation(context),
                    icon: Icon(
                      _currentIndex == affirmations.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      _currentIndex == affirmations.length - 1
                          ? (isChinese ? '完成' : 'Complete')
                          : (isChinese ? '下一个' : 'Next'),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingM,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
              
              const SizedBox(height: AppDimensions.spacingS),
            ],
          ),
        ),
        
        // Breathing reminder - top left
        Positioned(
          top: AppDimensions.spacingS,
          left: AppDimensions.spacingS,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.aqua.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(
                color: AppColors.aqua.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.air,
                  color: AppColors.aqua,
                  size: 14,
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Text(
                  isChinese ? '保持深呼吸' : 'Keep breathing deeply',
                  style: TextStyle(
                    color: AppColors.aqua,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Skip button - top right
        if (widget.onComplete != null)
          Positioned(
            top: AppDimensions.spacingS,
            right: AppDimensions.spacingS,
            child: InkWell(
              onTap: widget.onComplete,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacingS),
                decoration: BoxDecoration(
                  color: AppColors.whiteWithOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.whiteWithOpacity(0.3),
                  ),
                ),
                child: Icon(
                  Icons.skip_next,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAffirmationDisplay(List<String> affirmations) {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lilac.withValues(alpha: 0.2),
              AppColors.aqua.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.lilac.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.lilac.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quote icon
            Icon(
              Icons.format_quote,
              color: AppColors.lilac.withValues(alpha: 0.6),
              size: 28,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            
            // Affirmation text
            Text(
              affirmations[_currentIndex],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    letterSpacing: 0.5,
                  ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            
            // Decorative elements
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(AppColors.aqua),
                const SizedBox(width: AppDimensions.spacingS),
                _buildDot(AppColors.lilac),
                const SizedBox(width: AppDimensions.spacingS),
                _buildDot(AppColors.mintGreen),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionMessage(bool isChinese) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.success,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.favorite,
            color: AppColors.success,
            size: 64,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
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
          isChinese 
              ? '你已经提醒自己内在的力量。将这些话语带在身边。'
              : 'You\'ve reminded yourself of your inner strength. Carry these words with you.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteWithOpacity(0.8),
              ),
          textAlign: TextAlign.center,
        ),
        if (widget.onComplete != null) ...[
          const SizedBox(height: AppDimensions.spacingXl),
          ElevatedButton(
            onPressed: widget.onComplete,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXl,
                vertical: AppDimensions.spacingM,
              ),
            ),
            child: Text(isChinese ? '继续' : 'Continue'),
          ),
        ],
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
    );
  }
}
