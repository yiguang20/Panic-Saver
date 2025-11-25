/// Model for a practice exercise with detailed content
class PracticeExercise {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> steps;
  final List<String> benefits;
  final String duration;
  final String frequency;
  final List<String> tips;
  final String? handbookReference; // Reference to handbook chapter
  final String? handbookChapter;   // Chapter number/name

  const PracticeExercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.steps,
    required this.benefits,
    required this.duration,
    required this.frequency,
    required this.tips,
    this.handbookReference,
    this.handbookChapter,
  });
}
