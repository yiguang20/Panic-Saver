import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/session_record.dart';
import '../sources/database_helper.dart';

/// Repository for managing session records
class SessionRepository {
  final DatabaseHelper _dbHelper;

  SessionRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper();

  /// Save a new session record
  Future<void> saveSession(SessionRecord session) async {
    // Skip database operations on web (sqflite not supported)
    if (kIsWeb) return;
    
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableSessionRecords,
      session.toJson(),
    );
  }

  /// Get all session records
  Future<List<SessionRecord>> getAllSessions() async {
    // Return empty list on web (sqflite not supported)
    if (kIsWeb) return [];
    
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSessionRecords,
      orderBy: 'startTime DESC',
    );
    return maps.map((map) => SessionRecord.fromJson(map)).toList();
  }

  /// Get session records for a specific date
  Future<List<SessionRecord>> getSessionsByDate(DateTime date) async {
    // Return empty list on web (sqflite not supported)
    if (kIsWeb) return [];
    
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSessionRecords,
      where: 'startTime >= ? AND startTime < ?',
      whereArgs: [
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch,
      ],
      orderBy: 'startTime DESC',
    );
    return maps.map((map) => SessionRecord.fromJson(map)).toList();
  }

  /// Get session records for a specific month
  Future<List<SessionRecord>> getSessionsByMonth(int year, int month) async {
    // Return empty list on web (sqflite not supported)
    if (kIsWeb) return [];
    
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 1);

    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSessionRecords,
      where: 'startTime >= ? AND startTime < ?',
      whereArgs: [
        startOfMonth.millisecondsSinceEpoch,
        endOfMonth.millisecondsSinceEpoch,
      ],
      orderBy: 'startTime DESC',
    );
    return maps.map((map) => SessionRecord.fromJson(map)).toList();
  }

  /// Get dates with sessions for a specific month (for calendar markers)
  Future<Set<DateTime>> getDatesWithSessions(int year, int month) async {
    final sessions = await getSessionsByMonth(year, month);
    return sessions.map((s) => s.date).toSet();
  }

  /// Get a single session by ID
  Future<SessionRecord?> getSessionById(String id) async {
    // Return null on web (sqflite not supported)
    if (kIsWeb) return null;
    
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSessionRecords,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return SessionRecord.fromJson(maps.first);
  }

  /// Delete a session record
  Future<void> deleteSession(String id) async {
    // Skip on web (sqflite not supported)
    if (kIsWeb) return;
    
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableSessionRecords,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all session records
  Future<void> deleteAllSessions() async {
    // Skip on web (sqflite not supported)
    if (kIsWeb) return;
    
    final db = await _dbHelper.database;
    await db.delete(DatabaseHelper.tableSessionRecords);
  }

  /// Get session statistics
  Future<SessionStatistics> getStatistics() async {
    final sessions = await getAllSessions();
    if (sessions.isEmpty) {
      return SessionStatistics.empty();
    }

    final totalSessions = sessions.length;
    final totalDuration = sessions.fold<Duration>(
      Duration.zero,
      (sum, s) => sum + s.duration,
    );
    final averageDuration = Duration(
      milliseconds: totalDuration.inMilliseconds ~/ totalSessions,
    );

    // Calculate most common hour
    final hourCounts = <int, int>{};
    for (final session in sessions) {
      final hour = session.startTime.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }
    final mostCommonHour = hourCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Calculate streak
    final dates = sessions.map((s) => s.date).toSet().toList()..sort();
    int currentStreak = 0;
    int maxStreak = 0;
    DateTime? lastDate;
    for (final date in dates.reversed) {
      if (lastDate == null || lastDate.difference(date).inDays == 1) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else {
        currentStreak = 1;
      }
      lastDate = date;
    }

    return SessionStatistics(
      totalSessions: totalSessions,
      totalDuration: totalDuration,
      averageDuration: averageDuration,
      mostCommonHour: mostCommonHour,
      longestStreak: maxStreak,
      firstSessionDate: sessions.last.startTime,
      lastSessionDate: sessions.first.startTime,
    );
  }

  /// Export all sessions as JSON-compatible list
  Future<List<Map<String, dynamic>>> exportSessions() async {
    final sessions = await getAllSessions();
    return sessions.map((s) => s.toJson()).toList();
  }

  /// Import sessions from JSON-compatible list
  Future<int> importSessions(List<Map<String, dynamic>> data) async {
    int imported = 0;
    for (final json in data) {
      try {
        final session = SessionRecord.fromJson(json);
        await saveSession(session);
        imported++;
      } catch (e) {
        // Skip invalid records
        continue;
      }
    }
    return imported;
  }
}

/// Statistics about session records
class SessionStatistics {
  final int totalSessions;
  final Duration totalDuration;
  final Duration averageDuration;
  final int mostCommonHour;
  final int longestStreak;
  final DateTime? firstSessionDate;
  final DateTime? lastSessionDate;

  const SessionStatistics({
    required this.totalSessions,
    required this.totalDuration,
    required this.averageDuration,
    required this.mostCommonHour,
    required this.longestStreak,
    this.firstSessionDate,
    this.lastSessionDate,
  });

  factory SessionStatistics.empty() {
    return const SessionStatistics(
      totalSessions: 0,
      totalDuration: Duration.zero,
      averageDuration: Duration.zero,
      mostCommonHour: 0,
      longestStreak: 0,
    );
  }

  String get formattedAverageDuration {
    final minutes = averageDuration.inMinutes;
    final seconds = averageDuration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  String get formattedMostCommonTime {
    final hour = mostCommonHour;
    if (hour < 6) return 'Night (0-6)';
    if (hour < 12) return 'Morning (6-12)';
    if (hour < 18) return 'Afternoon (12-18)';
    return 'Evening (18-24)';
  }
}
