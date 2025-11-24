import 'package:flutter/material.dart';

/// App color palette based on calming, therapeutic colors
/// Enhanced V2.0 with richer gradients and softer tones
class AppColors {
  AppColors._();

  // Primary colors - Core palette
  static const Color navy = Color(0xFF3A4B7C);
  static const Color navyDark = Color(0xFF2A3659);
  static const Color aqua = Color(0xFF68C3D4);
  static const Color lilac = Color(0xFFD8CBE8);
  static const Color cream = Color(0xFFF9F7F2);
  static const Color textMain = Color(0xFFE2E8F0);

  // Extended palette - V2.0 additions
  static const Color softBlue = Color(0xFF7BA3D1);
  static const Color deepPurple = Color(0xFF9B8FB9);
  static const Color mintGreen = Color(0xFF9ECFB8);
  static const Color warmGray = Color(0xFFB8B5B0);
  static const Color paleGold = Color(0xFFE8D5B7);
  static const Color lavender = Color(0xFFE6E0F0);
  
  // Gradient colors for background - Multi-layer support
  static const Color gradientStart = Color(0xFF2A3659);
  static const Color gradientMid = Color(0xFF3A4B7C);
  static const Color gradientEnd = Color(0xFF4A5D8A);
  static const Color gradientAccent1 = Color(0xFF5A6D9A);
  static const Color gradientAccent2 = Color(0xFF4A5B7C);

  // Semantic colors - Softer, more calming tones
  static const Color success = Color(0xFF81C784); // Softer green
  static const Color warning = Color(0xFFFFB74D); // Softer orange
  static const Color info = Color(0xFF64B5F6); // Soft blue for info
  static const Color calm = Color(0xFFB39DDB); // Soft purple for calm states
  
  // Help Letter colors - Warm and soothing (NO RED)
  static const Color helpBackground = Color(0xFFFFF8E1); // Warm cream
  static const Color helpText = Color(0xFF5D4E37); // Warm brown
  static const Color helpAccent = Color(0xFFD4A574); // Soft gold
  
  // Card and surface colors
  static const Color cardBackground = Color(0xFF3A4B7C);
  static const Color cardBorder = Color(0xFF5A6D9A);
  static const Color surfaceLight = Color(0xFF4A5D8A);
  static const Color surfaceDark = Color(0xFF2A3659);

  // Opacity variants - Using withValues() instead of deprecated withOpacity()
  static Color navyWithOpacity(double opacity) => 
      navy.withValues(alpha: opacity);
  static Color aquaWithOpacity(double opacity) => 
      aqua.withValues(alpha: opacity);
  static Color lilacWithOpacity(double opacity) => 
      lilac.withValues(alpha: opacity);
  static Color whiteWithOpacity(double opacity) => 
      Colors.white.withValues(alpha: opacity);
  static Color softBlueWithOpacity(double opacity) => 
      softBlue.withValues(alpha: opacity);
  static Color deepPurpleWithOpacity(double opacity) => 
      deepPurple.withValues(alpha: opacity);
  static Color mintGreenWithOpacity(double opacity) => 
      mintGreen.withValues(alpha: opacity);
  
  // Gradient helpers
  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [gradientStart, gradientMid, gradientEnd],
        stops: [0.0, 0.5, 1.0],
      );
  
  static LinearGradient get cardGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          cardBackground.withValues(alpha: 0.8),
          cardBackground.withValues(alpha: 0.6),
        ],
      );
  
  static LinearGradient get breathingOrbGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          aqua.withValues(alpha: 0.8),
          lilac.withValues(alpha: 0.8),
        ],
      );
}
