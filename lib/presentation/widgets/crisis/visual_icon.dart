import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Visual icon for crisis steps
class VisualIcon extends StatelessWidget {
  final String iconType;

  const VisualIcon({
    Key? key,
    required this.iconType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.aqua.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        _getIconData(iconType),
        size: 64,
        color: AppColors.aqua.withOpacity(0.8),
      ),
    );
  }

  IconData _getIconData(String type) {
    switch (type) {
      case 'prep':
        return Icons.headphones;
      case 'stop':
        return Icons.pan_tool;
      case 'breathe':
        return Icons.air; // Will be replaced by BreathingOrb
      case 'ground':
        return Icons.nature;
      case 'talk':
        return Icons.chat_bubble_outline;
      case 'float':
        return Icons.water_drop_outlined;
      case 'compassion':
        return Icons.favorite_border;
      case 'wait':
        return Icons.schedule;
      case 'end':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.help_outline;
    }
  }
}
