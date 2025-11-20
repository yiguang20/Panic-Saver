import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing app preferences and state persistence
class PreferencesRepository {
  static const String _keyCurrentStep = 'current_step';
  static const String _keyLanguage = 'language';

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

  /// Factory method to create repository with SharedPreferences instance
  static Future<PreferencesRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesRepository(prefs);
  }
}
