/// Breathing rhythm settings model
class BreathingSettings {
  final double inhaleDuration; // seconds
  final double holdDuration; // seconds
  final double exhaleDuration; // seconds

  const BreathingSettings({
    required this.inhaleDuration,
    required this.holdDuration,
    required this.exhaleDuration,
  });

  /// Default 4-7-8 breathing pattern
  static const BreathingSettings defaultPattern = BreathingSettings(
    inhaleDuration: 4.0,
    holdDuration: 7.0,
    exhaleDuration: 8.0,
  );

  /// Faster pattern for beginners
  static const BreathingSettings beginnerPattern = BreathingSettings(
    inhaleDuration: 3.0,
    holdDuration: 5.0,
    exhaleDuration: 6.0,
  );

  /// Slower pattern for advanced users
  static const BreathingSettings advancedPattern = BreathingSettings(
    inhaleDuration: 5.0,
    holdDuration: 8.0,
    exhaleDuration: 10.0,
  );

  /// Total cycle duration in seconds
  double get totalDuration => inhaleDuration + holdDuration + exhaleDuration;

  /// Weight for inhale phase (0.0 to 1.0)
  double get inhaleWeight => inhaleDuration / totalDuration;

  /// Weight for hold phase (0.0 to 1.0)
  double get holdWeight => holdDuration / totalDuration;

  /// Weight for exhale phase (0.0 to 1.0)
  double get exhaleWeight => exhaleDuration / totalDuration;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'inhaleDuration': inhaleDuration,
      'holdDuration': holdDuration,
      'exhaleDuration': exhaleDuration,
    };
  }

  /// Create from JSON
  factory BreathingSettings.fromJson(Map<String, dynamic> json) {
    return BreathingSettings(
      inhaleDuration: (json['inhaleDuration'] as num?)?.toDouble() ?? 4.0,
      holdDuration: (json['holdDuration'] as num?)?.toDouble() ?? 7.0,
      exhaleDuration: (json['exhaleDuration'] as num?)?.toDouble() ?? 8.0,
    );
  }

  /// Create a copy with modified values
  BreathingSettings copyWith({
    double? inhaleDuration,
    double? holdDuration,
    double? exhaleDuration,
  }) {
    return BreathingSettings(
      inhaleDuration: inhaleDuration ?? this.inhaleDuration,
      holdDuration: holdDuration ?? this.holdDuration,
      exhaleDuration: exhaleDuration ?? this.exhaleDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BreathingSettings &&
        other.inhaleDuration == inhaleDuration &&
        other.holdDuration == holdDuration &&
        other.exhaleDuration == exhaleDuration;
  }

  @override
  int get hashCode =>
      inhaleDuration.hashCode ^ holdDuration.hashCode ^ exhaleDuration.hashCode;

  @override
  String toString() {
    return 'BreathingSettings(${inhaleDuration.toStringAsFixed(1)}-${holdDuration.toStringAsFixed(1)}-${exhaleDuration.toStringAsFixed(1)})';
  }
}
