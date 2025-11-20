import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/breathing_settings.dart';
import '../../domain/providers/settings_provider.dart';
import '../../presentation/l10n/app_localizations.dart';
import 'breathing_recorder_screen.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            await HapticUtils.light();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, settings, _) {
            return ListView(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              children: [
                // Breathing Settings Section
                _buildSectionHeader(context, l10n.breathingSettingsTitle),
                const SizedBox(height: AppDimensions.spacingM),
                _buildBreathingPresets(context, settings, l10n),
                const SizedBox(height: AppDimensions.spacingM),
                _buildCustomBreathingButton(context, settings, l10n),
                const SizedBox(height: AppDimensions.spacingM),
                _buildCurrentBreathingInfo(context, settings, l10n),

                const SizedBox(height: AppDimensions.spacingXl),

                // Theme Settings Section (placeholder)
                _buildSectionHeader(context, l10n.themeSettingsTitle),
                const SizedBox(height: AppDimensions.spacingM),
                _buildThemeOptions(context, settings, l10n),

                const SizedBox(height: AppDimensions.spacingXl),

                // Reset Button
                _buildResetButton(context, settings, l10n),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildBreathingPresets(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    final presets = [
      (l10n.presetBeginner, BreathingSettings.beginnerPattern),
      (l10n.presetStandard, BreathingSettings.defaultPattern),
      (l10n.presetAdvanced, BreathingSettings.advancedPattern),
    ];

    return Column(
      children: presets.map((preset) {
        final isSelected = settings.breathingSettings == preset.$2;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () async {
              await HapticUtils.selection();
              await settings.updateBreathingSettings(preset.$2);
            },
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.aqua.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(
                  color: isSelected
                      ? AppColors.aqua
                      : Colors.white.withValues(alpha: 0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.aqua : Colors.white.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Text(
                      preset.$1,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomBreathingButton(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    return ElevatedButton.icon(
      onPressed: () async {
        await HapticUtils.light();
        if (!context.mounted) return;
        
        final result = await Navigator.push<BreathingSettings>(
          context,
          MaterialPageRoute(
            builder: (context) => const BreathingRecorderScreen(),
          ),
        );
        if (result != null) {
          await settings.updateBreathingSettings(result);
        }
      },
      icon: const Icon(Icons.tune),
      label: Text(l10n.customBreathingButton),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingM,
          horizontal: AppDimensions.spacingL,
        ),
      ),
    );
  }

  Widget _buildCurrentBreathingInfo(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    final breathing = settings.breathingSettings;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.lilac.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.lilac.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.currentBreathingRhythm,
            style: TextStyle(
              color: AppColors.lilac,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            '${l10n.inhale}: ${breathing.inhaleDuration.toStringAsFixed(1)} ${l10n.seconds}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            '${l10n.hold}: ${breathing.holdDuration.toStringAsFixed(1)} ${l10n.seconds}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            '${l10n.exhale}: ${breathing.exhaleDuration.toStringAsFixed(1)} ${l10n.seconds}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            '${l10n.totalCycle}: ${breathing.totalDuration.toStringAsFixed(1)} ${l10n.seconds}',
            style: TextStyle(
              color: AppColors.aqua,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOptions(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Text(
            l10n.themeComingSoon,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            l10n.comingSoon,
            style: TextStyle(
              color: AppColors.lilac.withValues(alpha: 0.8),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    return OutlinedButton.icon(
      onPressed: () async {
        await HapticUtils.light();
        if (!context.mounted) return;
        
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.resetDialogTitle),
            content: Text(l10n.resetDialogContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.confirm),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await settings.resetToDefaults();
        }
      },
      icon: const Icon(Icons.restore),
      label: Text(l10n.resetButton),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingM,
        ),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
    );
  }
}
