/// App animation duration constants
class AppDurations {
  AppDurations._();

  // Standard animation durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration verySlow = Duration(milliseconds: 1200);

  // Specific animation durations
  static const Duration fadeTransition = Duration(milliseconds: 600);
  static const Duration cardFlip = Duration(milliseconds: 1200);
  static const Duration bubbleExpand = Duration(milliseconds: 1400);
  static const Duration slideAnimation = Duration(milliseconds: 500);

  // Breathing animation
  static const Duration breathingCycle = Duration(seconds: 19); // 4+7+8
  static const Duration breathingInhale = Duration(seconds: 4);
  static const Duration breathingHold = Duration(seconds: 7);
  static const Duration breathingExhale = Duration(seconds: 8);

  // Orb floating animation
  static const Duration orbFloat = Duration(seconds: 20);

  // Star twinkling
  static const Duration starTwinkle = Duration(seconds: 4);

  // Double tap detection window
  static const Duration doubleTapWindow = Duration(milliseconds: 300);

  // Debounce duration for button taps
  static const Duration buttonDebounce = Duration(milliseconds: 300);
}
