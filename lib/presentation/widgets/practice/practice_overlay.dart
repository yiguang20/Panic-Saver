import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/repositories/content_repository.dart';
import '../../screens/interactive_practice_screen.dart';

/// Practice mode overlay that slides up from bottom
class PracticeOverlay extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const PracticeOverlay({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  State<PracticeOverlay> createState() => _PracticeOverlayState();
}

class _PracticeOverlayState extends State<PracticeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PracticeOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible && _controller.isDismissed) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: AppColors.navyDark,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusXl),
            topRight: Radius.circular(AppDimensions.radiusXl),
          ),
          border: Border(
            top: BorderSide(
              color: AppColors.whiteWithOpacity(0.1),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(
                top: AppDimensions.spacingL,
                bottom: AppDimensions.spacingL,
              ),
              decoration: BoxDecoration(
                color: AppColors.whiteWithOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getLocalizedString(context, 'practiceTitle'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    _getLocalizedString(context, 'practiceSubtitle'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.lilacWithOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.spacingL),

            // Practice cards grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingL,
                ),
                child: _buildPracticeGrid(context),
              ),
            ),

            // Close button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingXl),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.whiteWithOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () async {
                    // Light haptic feedback for close button
                    await HapticUtils.light();
                    widget.onClose();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeGrid(BuildContext context) {
    final contentRepo = ContentRepository();
    final practiceItems = contentRepo.getPracticeItems(context);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacingM,
        mainAxisSpacing: AppDimensions.spacingM,
        childAspectRatio: 1.0,
      ),
      itemCount: practiceItems.length,
      itemBuilder: (context, index) {
        final item = practiceItems[index];
        return _buildPracticeCard(item.iconName, item.title, item.description, item.id);
      },
    );
  }

  Widget _buildPracticeCard(String iconName, String title, String description, String id) {
    return GestureDetector(
      onTap: () async {
        await HapticUtils.selection();
        _navigateToPracticeDetail(id);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: AppColors.whiteWithOpacity(0.05),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.whiteWithOpacity(0.05),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconData(iconName),
              size: 32,
              color: iconName == 'wind' || iconName == 'comments'
                  ? AppColors.aqua
                  : AppColors.lilac,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              description,
              style: TextStyle(
                color: AppColors.whiteWithOpacity(0.4),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPracticeDetail(String id) {
    final contentRepo = ContentRepository();
    final exercise = contentRepo.getPracticeExercise(context, id);
    
    // Use interactive practice screen for guided exercises
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InteractivePracticeScreen(exercise: exercise),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wind':
        return Icons.air;
      case 'person_running':
        return Icons.directions_run;
      case 'comments':
        return Icons.chat_bubble_outline;
      case 'feather':
        return Icons.water_drop_outlined;
      case 'autorenew':
        return Icons.autorenew;
      case 'hearing':
        return Icons.hearing;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.help_outline;
    }
  }

  String _getLocalizedString(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    final Map<String, Map<String, String>> translations = {
      'en': {
        'practiceTitle': 'Daily Practice',
        'practiceSubtitle': 'Build resilience before the storm.',
      },
      'zh': {
        'practiceTitle': '日常训练',
        'practiceSubtitle': '在风暴来临前建立韧性',
      },
    };
    
    final langMap = translations[locale] ?? translations['en']!;
    return langMap[key] ?? key;
  }
}
