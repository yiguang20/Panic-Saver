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
    
    // Animation for the unwinding rope
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120), // 60 seconds for 100 to 0
    );

    _animationController.addListener(() {
      // Update countdown number based on animation progress
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

    // Start animation
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

    return Stack(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            children: [
              // Top spacing for breathing reminder
              const SizedBox(height: AppDimensions.spacingXl),
              
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
                child: Text(
                  l10n.unwindingInstructions,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteWithOpacity(0.8),
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: AppDimensions.spacingL),

              // Unwinding animation and countdown
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Unwinding rope animation
                      UnwindingAnimation(
                        controller: _animationController,
                      ),
                      
                      // Countdown number overlay
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingXl,
                        vertical: AppDimensions.spacingM,
                      ),
                    ),
                    child: Text(
                      Localizations.localeOf(context).languageCode == 'zh' 
                          ? '继续' 
                          : 'Continue',
                    ),
                  ),
                ],
              ] else
                Text(
                  '$_currentNumber%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.whiteWithOpacity(0.5),
                      ),
                ),
              
              const SizedBox(height: AppDimensions.spacingM),
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
                  l10n.breathingReminder,
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
}
