import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import 'mini_breathing_orb.dart';

/// Persistent breathing reminder shown at bottom of cards
/// Provides continuous breathing guidance throughout crisis flow
class BreathingReminder extends StatefulWidget {
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;

  const BreathingReminder({
    super.key,
    this.inhaleSeconds = 4,
    this.holdSeconds = 7,
    this.exhaleSeconds = 8,
  });

  @override
  State<BreathingReminder> createState() => _BreathingReminderState();
}

class _BreathingReminderState extends State<BreathingReminder> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isChinese = locale == 'zh';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.aqua.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.aqua.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Compact view
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingS,
              ),
              child: Row(
                children: [
                  // Mini breathing orb
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: MiniBreathingOrb(
                      inhaleSeconds: widget.inhaleSeconds,
                      holdSeconds: widget.holdSeconds,
                      exhaleSeconds: widget.exhaleSeconds,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  
                  // Text
                  Expanded(
                    child: Text(
                      isChinese ? '保持深呼吸' : 'Keep breathing deeply',
                      style: TextStyle(
                        color: AppColors.aqua,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  // Expand icon
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.aqua,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded details
          if (_isExpanded) ...[
            const SizedBox(height: AppDimensions.spacingM),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.whiteWithOpacity(0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isChinese ? '呼吸节奏：' : 'Breathing Rhythm:',
                    style: TextStyle(
                      color: AppColors.whiteWithOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  _buildRhythmRow(
                    isChinese ? '吸气' : 'Inhale',
                    widget.inhaleSeconds,
                    AppColors.aqua,
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  _buildRhythmRow(
                    isChinese ? '屏息' : 'Hold',
                    widget.holdSeconds,
                    AppColors.lilac,
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  _buildRhythmRow(
                    isChinese ? '呼气' : 'Exhale',
                    widget.exhaleSeconds,
                    AppColors.softBlue,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    isChinese 
                        ? '跟随光球的节奏，让呼吸自然流动。'
                        : 'Follow the orb\'s rhythm and let your breath flow naturally.',
                    style: TextStyle(
                      color: AppColors.whiteWithOpacity(0.5),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRhythmRow(String label, int seconds, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          '${seconds}s',
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
