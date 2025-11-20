import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/durations.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../domain/providers/crisis_provider.dart';
import '../animations/bubble_effect.dart';
import '../animations/card_flip_animation.dart';
import '../help_letter/help_letter_card.dart';
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

  Widget _buildFrontCard(CrisisProvider crisisProvider, currentStepData) {
    return Container(
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
            // Progress indicator
            _buildProgressIndicator(crisisProvider),

            const SizedBox(height: AppDimensions.spacingXl),

            // Step content
            StepContent(step: currentStepData),

            const SizedBox(height: AppDimensions.spacingXl),

            // Action button
            SizedBox(
              width: double.infinity,
              child: Semantics(
                label: crisisProvider.currentStep == crisisProvider.totalSteps - 1
                    ? 'Restart crisis guidance'
                    : 'Continue to next step',
                button: true,
                child: ElevatedButton(
                  onPressed: () async {
                    // Medium haptic feedback for step transitions
                    await HapticUtils.medium();
                    
                    if (crisisProvider.currentStep == crisisProvider.totalSteps - 1) {
                      crisisProvider.resetSteps();
                    } else {
                      crisisProvider.nextStep();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spacingL,
                    ),
                  ),
                  child: Text(
                    currentStepData.buttonText.toUpperCase(),
                  ),
                ),
              ),
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
