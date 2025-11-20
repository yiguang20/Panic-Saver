/// Model representing a practice exercise item
class PracticeItem {
  final String id;
  final String iconName;
  final String title;
  final String description;
  final String chapterReference;

  const PracticeItem({
    required this.id,
    required this.iconName,
    required this.title,
    required this.description,
    required this.chapterReference,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iconName': iconName,
      'title': title,
      'description': description,
      'chapterReference': chapterReference,
    };
  }

  factory PracticeItem.fromJson(Map<String, dynamic> json) {
    return PracticeItem(
      id: json['id'] as String,
      iconName: json['iconName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      chapterReference: json['chapterReference'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PracticeItem &&
        other.id == id &&
        other.iconName == iconName &&
        other.title == title &&
        other.description == description &&
        other.chapterReference == chapterReference;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      iconName,
      title,
      description,
      chapterReference,
    );
  }
}
