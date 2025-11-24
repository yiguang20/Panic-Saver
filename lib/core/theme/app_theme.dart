import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';

/// App theme configuration
class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      
      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.aqua,
        secondary: AppColors.lilac,
        surface: AppColors.navy,
        surfaceContainerHighest: AppColors.navyDark,
        error: AppColors.warning, // Using softer warning color instead of harsh red
        onPrimary: Colors.white,
        onSecondary: AppColors.navyDark,
        onSurface: AppColors.textMain,
        tertiary: AppColors.softBlue,
        onTertiary: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.navyDark,

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppColors.textMain),
        titleTextStyle: TextStyle(
          color: AppColors.textMain,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          color: Colors.white,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w300,
          color: Colors.white,
          height: 1.2,
        ),
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 1.3,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 1.4,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 1.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textMain,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textMain,
          height: 1.6,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textMain.withValues(alpha: 0.7),
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.whiteWithOpacity(0.1),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            side: BorderSide(
              color: AppColors.whiteWithOpacity(0.2),
              width: 1,
            ),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.aqua,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: AppColors.textMain,
        size: AppDimensions.iconM,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.whiteWithOpacity(0.08),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          side: BorderSide(
            color: AppColors.whiteWithOpacity(0.15),
            width: 1,
          ),
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColors.whiteWithOpacity(0.1),
        thickness: 1,
        space: AppDimensions.spacingM,
      ),
    );
  }
}
