import 'dart:convert';

/// Model representing a single crisis session record
class SessionRecord {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final int stepsCompleted;
  final List<int> completedSteps;
  final Map<String, dynamic>? metadata;

  const SessionRecord({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.stepsCompleted,
    required this.completedSteps,
    this.metadata,
  });

  /// Create a new session record with auto-generated ID
  factory SessionRecord.create({
    required DateTime startTime,
    required DateTime endTime,
    required List<int> completedSteps,
    Map<String, dynamic>? metadata,
  }) {
    return SessionRecord(
      id: '${startTime.millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch}',
      startTime: startTime,
      endTime: endTime,
      duration: endTime.difference(startTime),
      stepsCompleted: completedSteps.length,
      completedSteps: List.unmodifiable(completedSteps),
      metadata: metadata,
    );
  }

  /// Convert to JSON map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'duration': duration.inMilliseconds,
      'stepsCompleted': stepsCompleted,
      'completedSteps': jsonEncode(completedSteps),
      'metadata': metadata != null ? jsonEncode(metadata) : null,
    };
  }

  /// Create from JSON map
  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      id: json['id'] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(json['endTime'] as int),
      duration: Duration(milliseconds: json['duration'] as int),
      stepsCompleted: json['stepsCompleted'] as int,
      completedSteps: _parseCompletedSteps(json['completedSteps']),
      metadata: _parseMetadata(json['metadata']),
    );
  }


  static List<int> _parseCompletedSteps(dynamic value) {
    if (value == null) return [];
    if (value is String) {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        return decoded.cast<int>();
      }
    }
    if (value is List) {
      return value.cast<int>();
    }
    return [];
  }

  static Map<String, dynamic>? _parseMetadata(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  /// Get the date only (without time) for calendar grouping
  DateTime get date => DateTime(startTime.year, startTime.month, startTime.day);

  /// Get formatted duration string
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  /// Get formatted time string
  String get formattedTime {
    final hour = startTime.hour.toString().padLeft(2, '0');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Copy with new values
  SessionRecord copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    int? stepsCompleted,
    List<int>? completedSteps,
    Map<String, dynamic>? metadata,
  }) {
    return SessionRecord(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      stepsCompleted: stepsCompleted ?? this.stepsCompleted,
      completedSteps: completedSteps ?? this.completedSteps,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionRecord &&
        other.id == id &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.stepsCompleted == stepsCompleted;
  }

  @override
  int get hashCode => Object.hash(id, startTime, endTime, stepsCompleted);

  @override
  String toString() {
    return 'SessionRecord(id: $id, startTime: $startTime, duration: $formattedDuration, steps: $stepsCompleted)';
  }
}
