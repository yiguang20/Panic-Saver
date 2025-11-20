import 'package:flutter/services.dart';

/// Utility class for haptic feedback
class HapticUtils {
  // Private constructor to prevent instantiation
  HapticUtils._();

  /// Trigger light haptic feedback
  /// Used for subtle interactions like button taps
  static Future<void> light() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Silently fail if haptics not supported
    }
  }

  /// Trigger medium haptic feedback
  /// Used for important interactions like step transitions
  static Future<void> medium() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Silently fail if haptics not supported
    }
  }

  /// Trigger heavy haptic feedback
  /// Used for critical interactions like help letter flip
  static Future<void> heavy() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Silently fail if haptics not supported
    }
  }

  /// Trigger selection click feedback
  /// Used for toggle switches and selections
  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Silently fail if haptics not supported
    }
  }

  /// Trigger vibration feedback
  /// Used for notifications or alerts
  static Future<void> vibrate() async {
    try {
      await HapticFeedback.vibrate();
    } catch (e) {
      // Silently fail if haptics not supported
    }
  }
}
