/// Type of crisis step
enum CrisisStepType {
  standard,      // Regular text-based step
  breathing,     // Breathing exercise with orb
  unwinding,     // Unwinding animation with countdown
  listening,     // Listening awareness exercise
  affirmation,   // Self-affirmation statements
}

/// Model representing a single step in the crisis guidance flow
class CrisisStep {
  final int stepNumber;
  final String iconType;
  final String title;
  final String text;
  final String subText;
  final String buttonText;
  final CrisisStepType type;

  const CrisisStep({
    required this.stepNumber,
    required this.iconType,
    required this.title,
    required this.text,
    required this.subText,
    required this.buttonText,
    this.type = CrisisStepType.standard,
  });

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'iconType': iconType,
      'title': title,
      'text': text,
      'subText': subText,
      'buttonText': buttonText,
      'type': type.toString(),
    };
  }

  factory CrisisStep.fromJson(Map<String, dynamic> json) {
    return CrisisStep(
      stepNumber: json['stepNumber'] as int,
      iconType: json['iconType'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      subText: json['subText'] as String,
      buttonText: json['buttonText'] as String,
      type: CrisisStepType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => CrisisStepType.standard,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CrisisStep &&
        other.stepNumber == stepNumber &&
        other.iconType == iconType &&
        other.title == title &&
        other.text == text &&
        other.subText == subText &&
        other.buttonText == buttonText &&
        other.type == type;
  }

  @override
  int get hashCode {
    return Object.hash(
      stepNumber,
      iconType,
      title,
      text,
      subText,
      buttonText,
      type,
    );
  }
}
