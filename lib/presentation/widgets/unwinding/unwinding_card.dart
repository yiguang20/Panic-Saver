import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../presentation/l10n/app_localizations.dart';
import 'unwinding_animation.dart';
import 'countdown_display.dart';

/// Unwinding card with rope animation and countdown
/// This is a therapeutic technique to help release anxiety
class UnwindingCard extends StatefulWidget {
  final VoidCallback? onComplete;

  const UnwindingCard({
    super.key,
    this.onComplete,
  });

  @override
  State<UnwindingCard> createState() => _UnwindingCardState();
}

class _UnwindingCardState extends State<UnwindingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentNumber = 100;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    );

    _animationController.addListener(() {
      final newNumber = (100 - (_animationController.value * 100)).round();
      if (newNumber != _currentNumber && newNumber >= 0) {
        setState(() {
          _currentNumber = newNumber;
        });
      }
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isCompleted) {
        setState(() {
          _isCompleted = true;
        });
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isChinese = locale == 'zh';

    // No top buttons here - they are in the parent _buildSpecialCard
    return Column(
      children: [
        // Title
        Text(
          l10n.unwindingTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingS),

        // Instructions
        Text(
          l10n.unwindingInstructions,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.whiteWithOpacity(0.7),
              ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Unwinding animation and countdown
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                UnwindingAnimation(controller: _animationController),
                CountdownDisplay(
                  currentNumber: _currentNumber,
                  isCompleted: _isCompleted,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingM),

        // Completion message or progress
        if (_isCompleted) ...[
          Text(
            l10n.unwindingComplete,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          if (widget.onComplete != null) ...[
            const SizedBox(height: AppDimensions.spacingM),
            ElevatedButton(
              onPressed: widget.onComplete,
              child: Text(isChinese ? '继续' : 'Continue'),
            ),
          ],
        ] else
          Text(
            '$_currentNumber%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.whiteWithOpacity(0.5),
                ),
          ),
      ],
    );
  }
}
