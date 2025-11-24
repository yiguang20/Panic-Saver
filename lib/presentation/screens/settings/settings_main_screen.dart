import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../presentation/l10n/app_localizations.dart';
import 'language_settings_screen.dart';
import 'breathing_settings_screen.dart';

/// Main settings screen with categorized menu
class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

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
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          children: [
            _buildMenuCategory(
              context,
              icon: Icons.language,
              title: l10n.languageSettingsTitle,
              subtitle: l10n.languageSettingsSubtitle,
              onTap: () => _navigateToLanguageSettings(context),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildMenuCategory(
              context,
              icon: Icons.air,
              title: l10n.breathingSettingsTitle,
              subtitle: l10n.breathingSettingsSubtitle,
              onTap: () => _navigateToBreathingSettings(context),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildMenuCategory(
              context,
              icon: Icons.palette_outlined,
              title: l10n.themeSettingsTitle,
              subtitle: l10n.themeSettingsSubtitle,
              onTap: () => _showComingSoon(context),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildMenuCategory(
              context,
              icon: Icons.edit_note,
              title: l10n.cardManagementTitle,
              subtitle: l10n.cardManagementSubtitle,
              onTap: () => _showComingSoon(context),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildMenuCategory(
              context,
              icon: Icons.calendar_today,
              title: l10n.calendarTitle,
              subtitle: l10n.calendarSubtitle,
              onTap: () => _showComingSoon(context),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildMenuCategory(
              context,
              icon: Icons.info_outline,
              title: l10n.aboutTitle,
              subtitle: l10n.aboutSubtitle,
              onTap: () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCategory(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () async {
        await HapticUtils.light();
        onTap();
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          color: AppColors.whiteWithOpacity(0.05),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.whiteWithOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.aqua.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(
                icon,
                color: AppColors.aqua,
                size: AppDimensions.iconL,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.whiteWithOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.whiteWithOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLanguageSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageSettingsScreen(),
      ),
    );
  }

  void _navigateToBreathingSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BreathingSettingsScreen(),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.comingSoon),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
