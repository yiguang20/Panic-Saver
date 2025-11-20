import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/practice_exercise.dart';
import '../widgets/common/animated_background.dart';

/// Detailed screen for a specific practice exercise
class PracticeDetailScreen extends StatelessWidget {
  final PracticeExercise exercise;

  const PracticeDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and subtitle
                      Text(
                        exercise.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingS),
                      Text(
                        exercise.subtitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.lilac,
                        ),
                      ),
                      
                      const SizedBox(height: AppDimensions.spacingXl),
                      
                      // Description
                      _buildSection(
                        context,
                        'About',
                        exercise.description,
                      ),
                      
                      const SizedBox(height: AppDimensions.spacingXl),
                      
                      // Duration and Frequency
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              context,
                              Icons.timer_outlined,
                              'Duration',
                              exercise.duration,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacingM),
                          Expanded(
                            child: _buildInfoCard(
                              context,
                              Icons.repeat,
                              'Frequency',
                              exercise.frequency,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppDimensions.spacingXl),
                      
                      // Steps
                      _buildStepsSection(context),
                      
                      const SizedBox(height: AppDimensions.spacingXl),
                      
                      // Benefits
                      _buildBenefitsSection(context),
                      
                      const SizedBox(height: AppDimensions.spacingXl),
                      
                      // Tips
                      _buildTipsSection(context),
                      
                      const SizedBox(height: AppDimensions.spacingXl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteWithOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: IconButton(
              onPressed: () async {
                await HapticUtils.light();
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final locale = Localizations.localeOf(context).languageCode;
    final translatedTitle = _getTranslatedLabel(locale, title);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translatedTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.whiteWithOpacity(0.8),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  String _getTranslatedLabel(String locale, String key) {
    final Map<String, Map<String, String>> translations = {
      'en': {
        'About': 'About',
        'Duration': 'Duration',
        'Frequency': 'Frequency',
        'How to Practice': 'How to Practice',
        'Benefits': 'Benefits',
        'Tips for Success': 'Tips for Success',
      },
      'zh': {
        'About': '关于',
        'Duration': '时长',
        'Frequency': '频率',
        'How to Practice': '如何练习',
        'Benefits': '益处',
        'Tips for Success': '成功秘诀',
      },
    };
    
    final langMap = translations[locale] ?? translations['en']!;
    return langMap[key] ?? key;
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value) {
    final locale = Localizations.localeOf(context).languageCode;
    final translatedLabel = _getTranslatedLabel(locale, label);
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.whiteWithOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.whiteWithOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.aqua,
            size: 24,
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            translatedLabel,
            style: TextStyle(
              color: AppColors.whiteWithOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepsSection(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getTranslatedLabel(locale, 'How to Practice'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        ...exercise.steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.aqua.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: AppColors.aqua,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Text(
                    step,
                    style: TextStyle(
                      color: AppColors.whiteWithOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBenefitsSection(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getTranslatedLabel(locale, 'Benefits'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        ...exercise.benefits.map((benefit) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.aqua,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: Text(
                    benefit,
                    style: TextStyle(
                      color: AppColors.whiteWithOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getTranslatedLabel(locale, 'Tips for Success'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        ...exercise.tips.map((tip) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: AppColors.lilac.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.lilac.withOpacity(0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.lilac,
                  size: 18,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: Text(
                    tip,
                    style: TextStyle(
                      color: AppColors.whiteWithOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
