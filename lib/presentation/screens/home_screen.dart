import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/utils/haptic_utils.dart';
import '../../domain/providers/language_provider.dart';
import '../widgets/common/animated_background.dart';
import '../widgets/crisis/crisis_card.dart';
import '../widgets/practice/practice_overlay.dart';

/// Main home screen of the app
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPracticeVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          AnimatedBackground(
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(context),

                  // Main content area
                  Expanded(
                    child: Center(
                      child: const CrisisCard(),
                    ),
                  ),

                  // Bottom navigation
                  _buildBottomNav(context),
                ],
              ),
            ),
          ),

          // Practice overlay
          if (_isPracticeVisible)
            Positioned.fill(
              child: PracticeOverlay(
                isVisible: _isPracticeVisible,
                onClose: () {
                  setState(() {
                    _isPracticeVisible = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App title
          Row(
            children: [
              Icon(
                Icons.nightlight_round,
                color: AppColors.lilac,
                size: AppDimensions.iconM,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'PANIC RELIEF',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.lilac,
                      fontSize: 12,
                    ),
              ),
            ],
          ),

          // Right side buttons
          Row(
            children: [
              // Language toggle
              Consumer<LanguageProvider>(
                builder: (context, languageProvider, _) {
                  return Semantics(
                    label: 'Change language. Current: ${languageProvider.currentLocale.languageCode}',
                    button: true,
                    child: InkWell(
                      onTap: () async {
                        // Selection haptic feedback for language toggle
                        await HapticUtils.selection();
                        languageProvider.toggleLanguage();
                      },
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingM,
                          vertical: AppDimensions.spacingS,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.whiteWithOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          color: AppColors.whiteWithOpacity(0.05),
                        ),
                        child: Text(
                          _getLanguageToggleText(languageProvider.currentLocale),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(width: AppDimensions.spacingS),

              // Settings button
              Semantics(
                label: 'Settings',
                button: true,
                child: InkWell(
                  onTap: () async {
                    await HapticUtils.light();
                    Navigator.pushNamed(context, '/settings');
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.spacingS),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.whiteWithOpacity(0.2),
                      ),
                      shape: BoxShape.circle,
                      color: AppColors.whiteWithOpacity(0.05),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLanguageToggleText(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return 'EN';
      case 'en':
        return '中文';
      case 'es':
        return 'EN / 中文';
      case 'fr':
        return 'EN / 中文';
      case 'de':
        return 'EN / 中文';
      default:
        return 'EN';
    }
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.navyDark.withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color: AppColors.whiteWithOpacity(0.05),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton(
            context,
            icon: Icons.shield_outlined,
            label: 'CRISIS',
            isActive: !_isPracticeVisible,
            onTap: () async {
              // Light haptic feedback for navigation
              await HapticUtils.light();
              if (_isPracticeVisible) {
                setState(() {
                  _isPracticeVisible = false;
                });
              }
            },
          ),
          _buildNavButton(
            context,
            icon: Icons.layers_outlined,
            label: 'PRACTICE',
            isActive: _isPracticeVisible,
            onTap: () async {
              // Light haptic feedback for navigation
              await HapticUtils.light();
              setState(() {
                _isPracticeVisible = !_isPracticeVisible;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: '$label tab${isActive ? ", selected" : ""}',
      button: true,
      selected: isActive,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.aqua : AppColors.whiteWithOpacity(0.4),
              size: AppDimensions.iconL,
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive ? AppColors.aqua : AppColors.whiteWithOpacity(0.4),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
