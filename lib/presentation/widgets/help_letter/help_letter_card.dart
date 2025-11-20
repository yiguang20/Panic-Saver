import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/repositories/content_repository.dart';

/// Help letter card with paper-like design
class HelpLetterCard extends StatelessWidget {
  final VoidCallback onBack;

  const HelpLetterCard({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final contentRepo = ContentRepository();
    final helpContent = contentRepo.getHelpLetter(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Red accent bar at top
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusXl),
                topRight: Radius.circular(AppDimensions.radiusXl),
              ),
            ),
          ),

          // Content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingXl),
              child: Column(
                children: [
                  // Medical icon decoration
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.medical_services_outlined,
                      size: 60,
                      color: AppColors.navy.withOpacity(0.1),
                    ),
                  ),

                  // Main content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Heading
                          Text(
                            helpContent.heading,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: AppDimensions.spacingS),

                          // Subheading
                          Text(
                            helpContent.subheading,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              letterSpacing: 1.5,
                            ),
                          ),

                          const SizedBox(height: AppDimensions.spacingXl),

                          // Content sections
                          _buildContentSection(helpContent),
                        ],
                      ),
                    ),
                  ),

                  // Back button
                  SizedBox(
                    width: double.infinity,
                    child: Semantics(
                      label: 'Return to crisis guidance',
                      button: true,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Light haptic feedback for back button
                          await HapticUtils.light();
                          onBack();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy.withOpacity(0.05),
                          foregroundColor: AppColors.navy.withOpacity(0.6),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.spacingM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.rotate_left, size: 18),
                            const SizedBox(width: AppDimensions.spacingS),
                            Text(
                              helpContent.backButtonText,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(dynamic helpContent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main description
        Container(
          padding: const EdgeInsets.only(
            left: AppDimensions.spacingM,
            top: AppDimensions.spacingS,
            bottom: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.red,
                width: 4,
              ),
            ),
          ),
          child: Text(
            helpContent.paragraph1,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.navyDark,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Safety assurances
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              _buildCheckItem(helpContent.paragraph2),
              const SizedBox(height: AppDimensions.spacingS),
              _buildCheckItem(helpContent.paragraph3),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Important request
        Text(
          helpContent.paragraph4,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.navyDark,
            height: 1.5,
          ),
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Final message
        Text(
          helpContent.paragraph5,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 20,
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.navyDark,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
