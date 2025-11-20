import 'package:flutter/material.dart';

/// App color palette based on calming, therapeutic colors
class AppColors {
  AppColors._();

  // Primary colors
  static const Color navy = Color(0xFF3A4B7C);
  static const Color navyDark = Color(0xFF2A3659);
  static const Color aqua = Color(0xFF68C3D4);
  static const Color lilac = Color(0xFFD8CBE8);
  static const Color cream = Color(0xFFF9F7F2);
  static const Color textMain = Color(0xFFE2E8F0);

  // Gradient colors for background
  static const Color gradientStart = Color(0xFF2A3659);
  static const Color gradientMid = Color(0xFF3A4B7C);
  static const Color gradientEnd = Color(0xFF4A5D8A);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);

  // Opacity variants
  static Color navyWithOpacity(double opacity) => navy.withOpacity(opacity);
  static Color aquaWithOpacity(double opacity) => aqua.withOpacity(opacity);
  static Color lilacWithOpacity(double opacity) => lilac.withOpacity(opacity);
  static Color whiteWithOpacity(double opacity) => Colors.white.withOpacity(opacity);
}
