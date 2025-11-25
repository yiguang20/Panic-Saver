import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/durations.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/models/crisis_step.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../domain/providers/crisis_provider.dart';
import '../../../domain/providers/settings_provider.dart';
import '../animations/bubble_effect.dart';
import '../animations/card_flip_animation.dart';
import '../buttons/hold_to_confirm_button.dart';
import '../help_letter/help_letter_card.dart';
import '../breathing/enhanced_breathing_orb.dart';
import '../unwinding/unwinding_card.dart';
import '../listening/listening_card.dart';
import '../affirmation/affirmation_card.dart';
import 'step_content.dart';

/// Main crisis card with flip animation and double-tap detection
class CrisisCard extends StatefulWidget {
  const CrisisCard({super.key});

  @override
  State<CrisisCard> createState() => _CrisisCardState();
}

class _CrisisCardState extends State<CrisisCard> {
  int _lastTapTime = 0;
  final List<Widget> _bubbles = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<CrisisProvider>(
      builder: (context, crisisProvider, _) {
        final contentRepo = ContentRepository();
        final steps = contentRepo.getCrisisSteps(context);
        final currentStepData = steps[crisisProvider.currentStep];

        return GestureDetector(
          onTapDown: (details) => _handleTap(details, crisisProvider),
          child: Stack(
            children: [
              // Main card with flip animation
              Container(
                constraints: const BoxConstraints(
                  maxWidth: AppDimensions.cardMaxWidth,
                ),
                margin: const EdgeInsets.all(AppDimensions.spacingL),
                child: CardFlipAnimation(
                  isFlipped: crisisProvider.isFlipped,
                  frontCard: _buildFrontCard(crisisProvider, currentStepData),
                  backCard: _buildBackCard(crisisProvider),
                ),
              ),

              // Bubble effects
              ..._bubbles,
            ],
          ),
        );
      },
    );
  }

  Widget _buildFrontCard(CrisisProvider crisisProvider, CrisisStep currentStepData) {
    // For special card types, render them directly
    if (currentStepData.type != CrisisStepType.standard) {
      return _buildSpecialCard(crisisProvider, currentStepData);
    }

    final locale = Localizations.localeOf(context).languageCode;
    final isChinese = locale == 'zh';

    // Standard card layout
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          decoration: BoxDecoration(
            color: AppColors.whiteWithOpacity(0.08),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(
              color: AppColors.whiteWithOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top spacing for buttons
                if (currentStepData.type != CrisisStepType.breathing)
                  const SizedBox(height: AppDimensions.spacingXl),
                
                // Progress indicator
                _buildProgressIndicator(crisisProvider),

                const SizedBox(height: AppDimensions.spacingXl),

                // Step content
                StepContent(step: currentStepData),

                const SizedBox(height: AppDimensions.spacingXl),

                // Action button - Hold to confirm
                HoldToConfirmButton(
                  label: currentStepData.buttonText,
                  onConfirm: () {
                    if (crisisProvider.currentStep == crisisProvider.totalSteps - 1) {
                      crisisProvider.resetSteps();
                    } else {
                      crisisProvider.nextStep();
                    }
                  },
                  showSkipButton: false,
                ),

                const SizedBox(height: AppDimensions.spacingM),

                // Hint text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 12,
                      color: AppColors.whiteWithOpacity(0.2),
                    ),
                    const SizedBox(width: AppDimensions.spacingXs),
                    Flexible(
                      child: Text(
                        'Double tap screen for Help Letter',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.whiteWithOpacity(0.2),
                              fontSize: 10,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Breathing reminder - top left (no background)
        if (currentStepData.type != CrisisStepType.breathing)
          Positioned(
            top: AppDimensions.spacingM,
            left: AppDimensions.spacingM,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.air,
                  color: AppColors.aqua,
                  size: 16,
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Text(
                  isChinese ? '保持深呼吸' : 'Keep breathing',
                  style: TextStyle(
                    color: AppColors.aqua,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        
        // Skip button - top right (no background)
        Positioned(
          top: AppDimensions.spacingM,
          right: AppDimensions.spacingM,
          child: GestureDetector(
            onTap: () {
              if (crisisProvider.currentStep == crisisProvider.totalSteps - 1) {
                crisisProvider.resetSteps();
              } else {
                crisisProvider.nextStep();
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isChinese ? '跳过' : 'Skip',
                  style: TextStyle(
                    color: AppColors.whiteWithOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Icon(
                  Icons.skip_next,
                  color: AppColors.whiteWithOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialCard(CrisisProvider crisisProvider, CrisisStep currentStepData) {
    final locale = Localizations.localeOf(context).languageCode;
    final isChinese = locale == 'zh';
    
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          decoration: BoxDecoration(
            color: AppColors.whiteWithOpacity(0.08),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(
              color: AppColors.whiteWithOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top spacing for buttons
              const SizedBox(height: AppDimensions.spacingL),
              
              // Progress indicator
              _buildProgressIndicator(crisisProvider),

              const SizedBox(height: AppDimensions.spacingL),

              // Special card content
              Expanded(
                child: _buildSpecialCardContent(crisisProvider, currentStepData),
              ),
            ],
          ),
        ),
        
        // Breathing reminder - top left (no background)
        Positioned(
          top: AppDimensions.spacingM,
          left: AppDimensions.spacingM,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.air,
                color: AppColors.aqua,
                size: 16,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              Text(
                isChinese ? '保持深呼吸' : 'Keep breathing',
                style: TextStyle(
                  color: AppColors.aqua,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Skip button - top right (no background)
        Positioned(
          top: AppDimensions.spacingM,
          right: AppDimensions.spacingM,
          child: GestureDetector(
            onTap: () {
              if (crisisProvider.currentStep == crisisProvider.totalSteps - 1) {
                crisisProvider.resetSteps();
              } else {
                crisisProvider.nextStep();
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isChinese ? '跳过' : 'Skip',
                  style: TextStyle(
                    color: AppColors.whiteWithOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Icon(
                  Icons.skip_next,
                  color: AppColors.whiteWithOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialCardContent(CrisisProvider crisisProvider, CrisisStep currentStepData) {
    switch (currentStepData.type) {
      case CrisisStepType.breathing:
        return _buildBreathingCard(crisisProvider, currentStepData);
      case CrisisStepType.unwinding:
        return UnwindingCard(
          onComplete: () {
            if (crisisProvider.currentStep == crisisProvider.totalSteps - 1) {
              crisisProvider.resetSteps();
            } else {
              crisisProvider.nextStep();
            }
          },
        );
      case CrisisStepType.listening:
        return ListeningCard(
          onComplete: () {
            if (crisisProvider.currentStep == crisisProvider.totalSteps - 1) {
              crisisProvider.resetSteps();
            } else {
              crisisProvider.nextStep();
            }
          },
        );
      case CrisisStepType.affirmation:
        return AffirmationCard(
          onComplete: () {
            if (crisisProvider.currentStep == crisisProvider.totalSteps - 1) {
              crisisProvider.resetSteps();
            } else {
              crisisProvider.nextStep();
            }
          },
        );
      default:
        return StepContent(step: currentStepData);
    }
  }

  Widget _buildBreathingCard(CrisisProvider crisisProvider, CrisisStep currentStepData) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                currentStepData.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              
              // Subtitle
              Text(
                currentStepData.text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.whiteWithOpacity(0.8),
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppDimensions.spacingL),

              // Enhanced breathing orb with fixed height
              SizedBox(
                height: 200,
                child: EnhancedBreathingOrb(
                  inhaleSeconds: settings.breathingSettings.inhaleDuration.toInt(),
                  holdSeconds: settings.breathingSettings.holdDuration.toInt(),
                  exhaleSeconds: settings.breathingSettings.exhaleDuration.toInt(),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingL),

              // Action button
              HoldToConfirmButton(
                label: currentStepData.buttonText,
                onConfirm: () {
                  if (crisisProvider.currentStep == crisisProvider.totalSteps - 1) {
                    crisisProvider.resetSteps();
                  } else {
                    crisisProvider.nextStep();
                  }
                },
                showSkipButton: false,
              ),

              const SizedBox(height: AppDimensions.spacingS),

              // Hint text
              Text(
                'Double tap screen for Help Letter',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.whiteWithOpacity(0.2),
                      fontSize: 10,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackCard(CrisisProvider crisisProvider) {
    return HelpLetterCard(
      onBack: () => crisisProvider.flipCard(),
    );
  }

  Widget _buildProgressIndicator(CrisisProvider crisisProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        crisisProvider.totalSteps,
        (index) {
          final isActive = index == crisisProvider.currentStep;
          final isCompleted = index < crisisProvider.currentStep;

          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.progressDotSpacing / 2,
            ),
            width: isActive
                ? AppDimensions.progressDotActiveWidth
                : AppDimensions.progressDotSize,
            height: AppDimensions.progressDotSize,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.aqua
                  : isCompleted
                      ? AppColors.lilacWithOpacity(0.6)
                      : AppColors.whiteWithOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(AppDimensions.progressDotSize / 2),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.aqua.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          );
        },
      ),
    );
  }

  void _handleTap(TapDownDetails details, CrisisProvider crisisProvider) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timeDiff = currentTime - _lastTapTime;

    if (timeDiff < AppDurations.doubleTapWindow.inMilliseconds && timeDiff > 0) {
      // Double tap detected
      // Heavy haptic feedback for help letter flip
      await HapticUtils.heavy();
      
      if (!crisisProvider.isFlipped) {
        _createBubbleEffect(details.globalPosition);
        
        // Delay flip to show bubble effect
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            crisisProvider.flipCard();
          }
        });
      } else {
        crisisProvider.flipCard();
      }
    }

    _lastTapTime = currentTime;
  }

  void _createBubbleEffect(Offset position) {
    late Widget bubble;
    bubble = BubbleEffect(
      position: position,
      onComplete: () {
        setState(() {
          _bubbles.remove(bubble);
        });
      },
    );

    setState(() {
      _bubbles.add(bubble);
    });

    // Auto-remove bubble after animation duration
    Future.delayed(AppDurations.bubbleExpand, () {
      if (mounted && _bubbles.contains(bubble)) {
        setState(() {
          _bubbles.remove(bubble);
        });
      }
    });
  }
}
