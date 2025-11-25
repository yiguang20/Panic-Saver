import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing app preferences and state persistence
class PreferencesRepository {
  static const String _keyCurrentStep = 'current_step';
  static const String _keyLanguage = 'language';
  static const String _keyInhaleDuration = 'inhale_duration';
  static const String _keyHoldDuration = 'hold_duration';
  static const String _keyExhaleDuration = 'exhale_duration';
  static const String _keyHapticsEnabled = 'haptics_enabled';
  static const String _keyReducedMotion = 'reduced_motion';
  static const String _keyLastBackupDate = 'last_backup_date';

  final SharedPreferences _prefs;

  PreferencesRepository(this._prefs);

  /// Save the current crisis step
  Future<void> saveCurrentStep(int step) async {
    try {
      await _prefs.setInt(_keyCurrentStep, step);
    } catch (e) {
      // Log error but don't throw - graceful degradation
      print('Error saving current step: $e');
    }
  }

  /// Load the saved crisis step
  /// Returns null if no step was saved or if there was an error
  Future<int?> loadCurrentStep() async {
    try {
      final step = _prefs.getInt(_keyCurrentStep);
      // Validate step is in valid range (0-8)
      if (step != null && step >= 0 && step <= 8) {
        return step;
      }
      return null;
    } catch (e) {
      print('Error loading current step: $e');
      return null;
    }
  }

  /// Save the selected language code
  Future<void> saveLanguage(String languageCode) async {
    try {
      await _prefs.setString(_keyLanguage, languageCode);
    } catch (e) {
      print('Error saving language: $e');
    }
  }

  /// Load the saved language code
  /// Returns null if no language was saved or if there was an error
  Future<String?> loadLanguage() async {
    try {
      return _prefs.getString(_keyLanguage);
    } catch (e) {
      print('Error loading language: $e');
      return null;
    }
  }

  /// Save a string value
  Future<void> saveString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      print('Error saving string for key $key: $e');
    }
  }

  /// Load a string value
  /// Returns null if no value was saved or if there was an error
  Future<String?> getString(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e) {
      print('Error loading string for key $key: $e');
      return null;
    }
  }

  /// Clear all saved state
  Future<void> clearState() async {
    try {
      await _prefs.remove(_keyCurrentStep);
      // Note: We don't clear language preference on state clear
    } catch (e) {
      print('Error clearing state: $e');
    }
  }

  /// Save breathing settings
  Future<void> saveBreathingSettings({
    required double inhale,
    required double hold,
    required double exhale,
  }) async {
    await _prefs.setDouble(_keyInhaleDuration, inhale);
    await _prefs.setDouble(_keyHoldDuration, hold);
    await _prefs.setDouble(_keyExhaleDuration, exhale);
  }

  /// Load breathing settings
  Map<String, double>? loadBreathingSettings() {
    final inhale = _prefs.getDouble(_keyInhaleDuration);
    final hold = _prefs.getDouble(_keyHoldDuration);
    final exhale = _prefs.getDouble(_keyExhaleDuration);
    
    if (inhale != null && hold != null && exhale != null) {
      return {'inhale': inhale, 'hold': hold, 'exhale': exhale};
    }
    return null;
  }

  /// Save haptics enabled setting
  Future<void> saveHapticsEnabled(bool enabled) async {
    await _prefs.setBool(_keyHapticsEnabled, enabled);
  }

  /// Load haptics enabled setting
  bool loadHapticsEnabled() {
    return _prefs.getBool(_keyHapticsEnabled) ?? true;
  }

  /// Save reduced motion setting
  Future<void> saveReducedMotion(bool enabled) async {
    await _prefs.setBool(_keyReducedMotion, enabled);
  }

  /// Load reduced motion setting
  bool loadReducedMotion() {
    return _prefs.getBool(_keyReducedMotion) ?? false;
  }

  /// Save last backup date
  Future<void> saveLastBackupDate(DateTime date) async {
    await _prefs.setInt(_keyLastBackupDate, date.millisecondsSinceEpoch);
  }

  /// Load last backup date
  DateTime? loadLastBackupDate() {
    final timestamp = _prefs.getInt(_keyLastBackupDate);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  /// Factory method to create repository with SharedPreferences instance
  static Future<PreferencesRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesRepository(prefs);
  }
}
