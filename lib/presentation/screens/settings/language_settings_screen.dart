import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../domain/providers/language_provider.dart';
import '../../../presentation/l10n/app_localizations.dart';

/// Language settings screen
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.languageSettingsTitle),
      ),
      body: SafeArea(
        child: Consumer<LanguageProvider>(
          builder: (context, languageProvider, _) {
            return ListView(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              children: [
                Text(
                  l10n.selectLanguagePrompt,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteWithOpacity(0.7),
                      ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                ...languageProvider.supportedLocales.map((locale) {
                  return _buildLanguageOption(
                    context,
                    locale: locale,
                    isSelected: languageProvider.currentLocale == locale,
                    onTap: () async {
                      await HapticUtils.selection();
                      languageProvider.setLocale(locale);
                    },
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required Locale locale,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final languageNames = {
      'en': 'English',
      'zh': '简体中文',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
    };

    final languageName = languageNames[locale.languageCode] ?? locale.languageCode;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
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
                size: AppDimensions.iconM,
              ),
              const SizedBox(width: AppDimensions.spacingL),
              Expanded(
                child: Text(
                  languageName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.aqua,
                  size: AppDimensions.iconM,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
