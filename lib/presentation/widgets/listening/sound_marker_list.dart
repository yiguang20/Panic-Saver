import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../presentation/l10n/app_localizations.dart';

/// List of sound categories for marking
class SoundMarkerList extends StatelessWidget {
  final List<String> markedSounds;
  final Function(String) onMarkSound;

  const SoundMarkerList({
    super.key,
    required this.markedSounds,
    required this.onMarkSound,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final soundCategories = [
      SoundCategory(
        id: 'voices',
        name: l10n.soundVoices ?? 'Voices',
        icon: Icons.record_voice_over,
      ),
      SoundCategory(
        id: 'nature',
        name: l10n.soundNature ?? 'Nature',
        icon: Icons.park,
      ),
      SoundCategory(
        id: 'mechanical',
        name: l10n.soundMechanical ?? 'Mechanical',
        icon: Icons.settings,
      ),
      SoundCategory(
        id: 'music',
        name: l10n.soundMusic ?? 'Music',
        icon: Icons.music_note,
      ),
      SoundCategory(
        id: 'ambient',
        name: l10n.soundAmbient ?? 'Ambient',
        icon: Icons.air,
      ),
    ];

    return ListView.builder(
      itemCount: soundCategories.length,
      itemBuilder: (context, index) {
        final category = soundCategories[index];
        final isMarked = markedSounds.contains(category.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
          child: InkWell(
            onTap: isMarked ? null : () => onMarkSound(category.id),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              decoration: BoxDecoration(
                color: isMarked
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.whiteWithOpacity(0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(
                  color: isMarked
                      ? AppColors.success
                      : AppColors.whiteWithOpacity(0.1),
                  width: isMarked ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    decoration: BoxDecoration(
                      color: isMarked
                          ? AppColors.success.withValues(alpha: 0.2)
                          : AppColors.softBlue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: Icon(
                      category.icon,
                      color: isMarked ? AppColors.success : AppColors.softBlue,
                      size: AppDimensions.iconM,
                    ),
                  ),
                  
                  const SizedBox(width: AppDimensions.spacingL),
                  
                  // Name
                  Expanded(
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: isMarked ? Colors.white : Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontWeight: isMarked ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  
                  // Checkmark
                  if (isMarked)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: AppDimensions.iconM,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Sound category data model
class SoundCategory {
  final String id;
  final String name;
  final IconData icon;

  SoundCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}
