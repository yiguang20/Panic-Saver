import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Utility class for accessibility features
class AccessibilityUtils {
  AccessibilityUtils._();

  /// Check if reduced motion is enabled
  static bool isReducedMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Check if bold text is enabled
  static bool isBoldTextEnabled(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }

  /// Get the text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  /// Check if high contrast is enabled
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// Get animation duration based on accessibility settings
  static Duration getAnimationDuration(
    BuildContext context, {
    Duration normalDuration = const Duration(milliseconds: 300),
  }) {
    if (isReducedMotionEnabled(context)) {
      return Duration.zero;
    }
    return normalDuration;
  }

  /// Get animation curve based on accessibility settings
  static Curve getAnimationCurve(BuildContext context) {
    if (isReducedMotionEnabled(context)) {
      return Curves.linear;
    }
    return Curves.easeInOut;
  }

  /// Wrap widget with semantics for screen readers
  static Widget withSemantics({
    required Widget child,
    required String label,
    String? hint,
    bool? button,
    bool? enabled,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: button,
      enabled: enabled,
      onTap: onTap,
      child: child,
    );
  }

  /// Create an accessible button
  static Widget accessibleButton({
    required Widget child,
    required String label,
    required VoidCallback onPressed,
    String? hint,
    bool enabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: enabled,
      onTap: enabled ? onPressed : null,
      child: child,
    );
  }

  /// Create an accessible image
  static Widget accessibleImage({
    required Widget image,
    required String description,
  }) {
    return Semantics(
      label: description,
      image: true,
      child: image,
    );
  }

  /// Announce a message to screen readers
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Check if screen reader is active
  static bool isScreenReaderActive(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }
}

/// Color contrast utilities for WCAG compliance
class ContrastUtils {
  ContrastUtils._();

  /// Calculate relative luminance of a color
  static double getRelativeLuminance(Color color) {
    double r = color.red / 255;
    double g = color.green / 255;
    double b = color.blue / 255;

    r = r <= 0.03928 ? r / 12.92 : ((r + 0.055) / 1.055).pow(2.4);
    g = g <= 0.03928 ? g / 12.92 : ((g + 0.055) / 1.055).pow(2.4);
    b = b <= 0.03928 ? b / 12.92 : ((b + 0.055) / 1.055).pow(2.4);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculate contrast ratio between two colors
  static double getContrastRatio(Color foreground, Color background) {
    final l1 = getRelativeLuminance(foreground);
    final l2 = getRelativeLuminance(background);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast meets WCAG AA standard (4.5:1 for normal text)
  static bool meetsWcagAA(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 4.5;
  }

  /// Check if contrast meets WCAG AAA standard (7:1 for normal text)
  static bool meetsWcagAAA(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 7.0;
  }

  /// Check if contrast meets WCAG AA for large text (3:1)
  static bool meetsWcagAALargeText(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 3.0;
  }
}

extension _DoublePow on double {
  double pow(double exponent) {
    return math.pow(this, exponent).toDouble();
  }
}

/// Extension for easier accessibility integration
extension AccessibilityExtension on Widget {
  /// Add semantic label to widget
  Widget withSemanticsLabel(String label, {String? hint}) {
    return Semantics(
      label: label,
      hint: hint,
      child: this,
    );
  }

  /// Mark widget as a button for accessibility
  Widget asAccessibleButton(String label, {VoidCallback? onTap}) {
    return Semantics(
      label: label,
      button: true,
      onTap: onTap,
      child: this,
    );
  }

  /// Exclude widget from semantics tree
  Widget excludeFromSemantics() {
    return ExcludeSemantics(child: this);
  }
}
