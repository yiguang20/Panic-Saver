/// Model representing the help letter content
class HelpLetterContent {
  final String heading;
  final String subheading;
  final String paragraph1;
  final String paragraph2;
  final String paragraph3;
  final String paragraph4;
  final String paragraph5;
  final String backButtonText;

  const HelpLetterContent({
    required this.heading,
    required this.subheading,
    required this.paragraph1,
    required this.paragraph2,
    required this.paragraph3,
    required this.paragraph4,
    required this.paragraph5,
    required this.backButtonText,
  });

  Map<String, dynamic> toJson() {
    return {
      'heading': heading,
      'subheading': subheading,
      'paragraph1': paragraph1,
      'paragraph2': paragraph2,
      'paragraph3': paragraph3,
      'paragraph4': paragraph4,
      'paragraph5': paragraph5,
      'backButtonText': backButtonText,
    };
  }

  factory HelpLetterContent.fromJson(Map<String, dynamic> json) {
    return HelpLetterContent(
      heading: json['heading'] as String,
      subheading: json['subheading'] as String,
      paragraph1: json['paragraph1'] as String,
      paragraph2: json['paragraph2'] as String,
      paragraph3: json['paragraph3'] as String,
      paragraph4: json['paragraph4'] as String,
      paragraph5: json['paragraph5'] as String,
      backButtonText: json['backButtonText'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HelpLetterContent &&
        other.heading == heading &&
        other.subheading == subheading &&
        other.paragraph1 == paragraph1 &&
        other.paragraph2 == paragraph2 &&
        other.paragraph3 == paragraph3 &&
        other.paragraph4 == paragraph4 &&
        other.paragraph5 == paragraph5 &&
        other.backButtonText == backButtonText;
  }

  @override
  int get hashCode {
    return Object.hash(
      heading,
      subheading,
      paragraph1,
      paragraph2,
      paragraph3,
      paragraph4,
      paragraph5,
      backButtonText,
    );
  }
}
