import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/models/breathing_settings.dart';
import '../../data/repositories/preferences_repository.dart';

/// Provider for managing app settings
class SettingsProvider extends ChangeNotifier {
  final PreferencesRepository _preferencesRepository;

  BreathingSettings _breathingSettings = BreathingSettings.defaultPattern;
  ThemeMode _themeMode = ThemeMode.dark;

  SettingsProvider(this._preferencesRepository);

  /// Current breathing settings
  BreathingSettings get breathingSettings => _breathingSettings;

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Load saved settings
  Future<void> loadSettings() async {
    try {
      // Load breathing settings
      final breathingJson = await _preferencesRepository.getString('breathing_settings');
      if (breathingJson != null) {
        final Map<String, dynamic> json = jsonDecode(breathingJson);
        _breathingSettings = BreathingSettings.fromJson(json);
      }

      // Load theme mode
      final themeModeStr = await _preferencesRepository.getString('theme_mode');
      if (themeModeStr != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeStr,
          orElse: () => ThemeMode.dark,
        );
      }

      notifyListeners();
    } catch (e) {
      // Ignore errors and use defaults
    }
  }

  /// Update breathing settings
  Future<void> updateBreathingSettings(BreathingSettings settings) async {
    _breathingSettings = settings;
    await _preferencesRepository.saveString(
      'breathing_settings',
      jsonEncode(settings.toJson()),
    );
    notifyListeners();
  }

  /// Update theme mode
  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _preferencesRepository.saveString('theme_mode', mode.toString());
    notifyListeners();
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    _breathingSettings = BreathingSettings.defaultPattern;
    _themeMode = ThemeMode.dark;
    await _preferencesRepository.saveString(
      'breathing_settings',
      jsonEncode(_breathingSettings.toJson()),
    );
    await _preferencesRepository.saveString('theme_mode', _themeMode.toString());
    notifyListeners();
  }
}
