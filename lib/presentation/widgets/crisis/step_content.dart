import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/durations.dart';
import '../../../data/models/crisis_step.dart';
import 'breathing_orb.dart';
import 'visual_icon.dart';

/// Widget displaying the content of a crisis step with animations
class StepContent extends StatefulWidget {
  final CrisisStep step;

  const StepContent({
    Key? key,
    required this.step,
  }) : super(key: key);

  @override
  State<StepContent> createState() => _StepContentState();
}

class _StepContentState extends State<StepContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.fadeTransition,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(StepContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.step.stepNumber != widget.step.stepNumber) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Visual element (icon or breathing orb)
            SizedBox(
              height: 140,
              child: Center(
                child: widget.step.iconType == 'breathe'
                    ? const BreathingOrb()
                    : VisualIcon(iconType: widget.step.iconType),
              ),
            ),

            const SizedBox(height: AppDimensions.spacingL),

            // Title
            Text(
              widget.step.title,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spacingL),

            // Main text
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              decoration: BoxDecoration(
                color: AppColors.whiteWithOpacity(0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(
                  color: AppColors.whiteWithOpacity(0.1),
                ),
              ),
              child: Text(
                widget.step.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.lilac,
                      height: 1.6,
                    ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingL),

            // Sub text
            SizedBox(
              height: 24,
              child: Text(
                widget.step.subText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.aqua.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
