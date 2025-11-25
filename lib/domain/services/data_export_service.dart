import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../data/repositories/session_repository.dart';
import '../../data/repositories/preferences_repository.dart';

/// Service for exporting and importing user data
class DataExportService {
  final SessionRepository _sessionRepository;
  final PreferencesRepository _preferencesRepository;

  DataExportService({
    SessionRepository? sessionRepository,
    PreferencesRepository? preferencesRepository,
  })  : _sessionRepository = sessionRepository ?? SessionRepository(),
        _preferencesRepository = preferencesRepository!;

  /// Export all user data to JSON
  Future<Map<String, dynamic>> exportData() async {
    final sessions = await _sessionRepository.exportSessions();
    final language = await _preferencesRepository.loadLanguage();
    
    return {
      'version': '2.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'data': {
        'sessions': sessions,
        'settings': {
          'language': language,
        },
      },
    };
  }

  /// Export data to JSON string
  Future<String> exportToJson() async {
    final data = await exportData();
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Save export to file
  Future<String> saveExportToFile(String directory) async {
    final json = await exportToJson();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final filename = 'panic_relief_backup_$timestamp.json';
    final filePath = path.join(directory, filename);
    
    final file = File(filePath);
    await file.writeAsString(json);
    
    return filePath;
  }


  /// Import data from JSON string
  Future<ImportResult> importFromJson(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return await importData(data);
    } catch (e) {
      return ImportResult(
        success: false,
        error: 'Invalid JSON format: $e',
      );
    }
  }

  /// Import data from file
  Future<ImportResult> importFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ImportResult(
          success: false,
          error: 'File not found',
        );
      }
      
      final jsonString = await file.readAsString();
      return await importFromJson(jsonString);
    } catch (e) {
      return ImportResult(
        success: false,
        error: 'Error reading file: $e',
      );
    }
  }

  /// Import data from parsed JSON
  Future<ImportResult> importData(Map<String, dynamic> data) async {
    try {
      // Validate version
      final version = data['version'] as String?;
      if (version == null) {
        return ImportResult(
          success: false,
          error: 'Invalid backup file: missing version',
        );
      }

      final dataSection = data['data'] as Map<String, dynamic>?;
      if (dataSection == null) {
        return ImportResult(
          success: false,
          error: 'Invalid backup file: missing data section',
        );
      }

      int sessionsImported = 0;
      bool settingsImported = false;

      // Import sessions
      final sessions = dataSection['sessions'] as List<dynamic>?;
      if (sessions != null) {
        final sessionMaps = sessions.cast<Map<String, dynamic>>();
        sessionsImported = await _sessionRepository.importSessions(sessionMaps);
      }

      // Import settings
      final settings = dataSection['settings'] as Map<String, dynamic>?;
      if (settings != null) {
        final language = settings['language'] as String?;
        if (language != null) {
          await _preferencesRepository.saveLanguage(language);
          settingsImported = true;
        }
      }

      return ImportResult(
        success: true,
        sessionsImported: sessionsImported,
        settingsImported: settingsImported,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        error: 'Error importing data: $e',
      );
    }
  }
}

/// Result of an import operation
class ImportResult {
  final bool success;
  final String? error;
  final int sessionsImported;
  final bool settingsImported;

  const ImportResult({
    required this.success,
    this.error,
    this.sessionsImported = 0,
    this.settingsImported = false,
  });

  String get summary {
    if (!success) {
      return error ?? 'Unknown error';
    }
    final parts = <String>[];
    if (sessionsImported > 0) {
      parts.add('$sessionsImported sessions');
    }
    if (settingsImported) {
      parts.add('settings');
    }
    if (parts.isEmpty) {
      return 'No data imported';
    }
    return 'Imported: ${parts.join(', ')}';
  }
}
