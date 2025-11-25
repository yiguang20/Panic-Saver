import 'dart:convert';
import 'crisis_step.dart';

/// Enhanced crisis card model with customization support
class CrisisCard {
  final String id;
  final String title;
  final String mainText;
  final String subText;
  final String buttonText;
  final CrisisStepType type;
  final bool isEnabled;
  final int order;
  final Map<String, dynamic>? customData;

  const CrisisCard({
    required this.id,
    required this.title,
    required this.mainText,
    required this.subText,
    required this.buttonText,
    required this.type,
    this.isEnabled = true,
    required this.order,
    this.customData,
  });

  /// Create from CrisisStep
  factory CrisisCard.fromStep(CrisisStep step) {
    return CrisisCard(
      id: 'step_${step.stepNumber}',
      title: step.title,
      mainText: step.text,
      subText: step.subText,
      buttonText: step.buttonText,
      type: step.type,
      order: step.stepNumber,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'mainText': mainText,
      'subText': subText,
      'buttonText': buttonText,
      'type': type.toString(),
      'isEnabled': isEnabled ? 1 : 0,
      'orderIndex': order,
      'customData': customData != null ? jsonEncode(customData) : null,
    };
  }

  /// Create from JSON
  factory CrisisCard.fromJson(Map<String, dynamic> json) {
    return CrisisCard(
      id: json['id'] as String,
      title: json['title'] as String,
      mainText: json['mainText'] as String,
      subText: json['subText'] as String? ?? '',
      buttonText: json['buttonText'] as String,
      type: CrisisStepType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => CrisisStepType.standard,
      ),
      isEnabled: (json['isEnabled'] as int?) == 1,
      order: json['orderIndex'] as int,
      customData: _parseCustomData(json['customData']),
    );
  }


  static Map<String, dynamic>? _parseCustomData(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {
        return null;
      }
    }
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  /// Copy with new values
  CrisisCard copyWith({
    String? id,
    String? title,
    String? mainText,
    String? subText,
    String? buttonText,
    CrisisStepType? type,
    bool? isEnabled,
    int? order,
    Map<String, dynamic>? customData,
  }) {
    return CrisisCard(
      id: id ?? this.id,
      title: title ?? this.title,
      mainText: mainText ?? this.mainText,
      subText: subText ?? this.subText,
      buttonText: buttonText ?? this.buttonText,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      order: order ?? this.order,
      customData: customData ?? this.customData,
    );
  }

  /// Convert to CrisisStep for compatibility
  CrisisStep toStep() {
    return CrisisStep(
      stepNumber: order,
      iconType: _getIconType(),
      title: title,
      text: mainText,
      subText: subText,
      buttonText: buttonText,
      type: type,
    );
  }

  String _getIconType() {
    switch (type) {
      case CrisisStepType.breathing:
        return 'breathe';
      case CrisisStepType.unwinding:
        return 'unwinding';
      case CrisisStepType.listening:
        return 'listening';
      case CrisisStepType.affirmation:
        return 'affirmation';
      default:
        return 'prep';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CrisisCard &&
        other.id == id &&
        other.title == title &&
        other.mainText == mainText &&
        other.order == order;
  }

  @override
  int get hashCode => Object.hash(id, title, mainText, order);

  @override
  String toString() {
    return 'CrisisCard(id: $id, title: $title, enabled: $isEnabled, order: $order)';
  }
}
