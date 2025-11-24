/// App dimension constants for consistent spacing and sizing
class AppDimensions {
  AppDimensions._();

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXl = 32.0;
  static const double radiusFull = 9999.0;

  // Icon sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXl = 48.0;
  static const double iconXxl = 64.0;

  // Button heights
  static const double buttonHeightS = 40.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // Card dimensions - V2.0 Enhanced (85% width, 70% height)
  static const double cardMaxWidth = 500.0;
  static const double cardWidthPercent = 0.85; // 85% of screen width
  static const double cardHeightPercent = 0.70; // 70% of visible height
  static const double cardBorderWidth = 1.0;
  static const double cardElevation = 8.0;

  // Progress bar
  static const double progressDotSize = 6.0;
  static const double progressDotActiveWidth = 32.0;
  static const double progressDotSpacing = 6.0;

  // Breathing orb - V2.0 Enhanced
  static const double breathingOrbSize = 140.0;
  static const double breathingOrbEnhancedSize = 320.0; // Enhanced version
  static const double breathingOrbMiniSize = 40.0; // Mini version for reminder
  static const double breathingOrbGlowRadius = 60.0;

  // Hold-to-confirm button - V2.0
  static const double holdButtonProgressRingWidth = 4.0;
  static const double holdButtonSize = 56.0;
  static const double skipButtonSize = 32.0;

  // Bottom navigation
  static const double bottomNavHeight = 80.0;
  
  // Breathing reminder - V2.0
  static const double breathingReminderHeight = 60.0;
  static const double breathingReminderCollapsedHeight = 40.0;

  // Touch targets (minimum for accessibility)
  static const double minTouchTarget = 48.0;
  
  // Shadows and blur - V2.0
  static const double shadowBlurRadius = 25.0;
  static const double shadowSpreadRadius = 5.0;
  static const double glassBlurSigma = 10.0;
  
  // Animation durations (milliseconds)
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 400;
  static const int animationDurationLong = 600;
  static const int holdToConfirmDuration = 2000; // 2 seconds
}
