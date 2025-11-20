import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';

/// Progress bar showing current step in crisis flow
class CrisisProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CrisisProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
        (index) => _buildDot(index),
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == currentStep;
    final isCompleted = index < currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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
                ? AppColors.lilac.withOpacity(0.6)
                : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.progressDotSize / 2),
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
  }
}
