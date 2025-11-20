/// Model representing a single step in the crisis guidance flow
class CrisisStep {
  final int stepNumber;
  final String iconType;
  final String title;
  final String text;
  final String subText;
  final String buttonText;

  const CrisisStep({
    required this.stepNumber,
    required this.iconType,
    required this.title,
    required this.text,
    required this.subText,
    required this.buttonText,
  });

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'iconType': iconType,
      'title': title,
      'text': text,
      'subText': subText,
      'buttonText': buttonText,
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
        other.buttonText == buttonText;
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
    );
  }
}
