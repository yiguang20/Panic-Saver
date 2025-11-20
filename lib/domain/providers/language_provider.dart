import 'package:flutter/material.dart';
import '../../data/repositories/preferences_repository.dart';

/// Provider for managing app language/locale
class LanguageProvider extends ChangeNotifier {
  final PreferencesRepository _preferencesRepository;

  Locale _currentLocale = const Locale('zh'); // Default to Chinese

  LanguageProvider(this._preferencesRepository);

  /// Current selected locale
  Locale get currentLocale => _currentLocale;

  /// List of supported locales
  List<Locale> get supportedLocales => const [
        Locale('en'), // English
        Locale('zh'), // Chinese
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('de'), // German
      ];

  /// Toggle to the next language in the supported list
  void toggleLanguage() {
    final currentIndex = supportedLocales.indexOf(_currentLocale);
    final nextIndex = (currentIndex + 1) % supportedLocales.length;
    setLocale(supportedLocales[nextIndex]);
  }

  /// Set a specific locale
  void setLocale(Locale locale) {
    if (supportedLocales.contains(locale) && _currentLocale != locale) {
      _currentLocale = locale;
      _saveLocale(locale);
      notifyListeners();
    }
  }

  /// Load saved locale from preferences
  Future<void> loadSavedLocale() async {
    final savedLanguageCode = await _preferencesRepository.loadLanguage();
    if (savedLanguageCode != null) {
      final savedLocale = Locale(savedLanguageCode);
      if (supportedLocales.contains(savedLocale)) {
        _currentLocale = savedLocale;
        notifyListeners();
      }
    } else {
      // Try to use device locale if no saved preference
      _tryUseDeviceLocale();
    }
  }

  /// Save locale to preferences
  Future<void> _saveLocale(Locale locale) async {
    await _preferencesRepository.saveLanguage(locale.languageCode);
  }

  /// Try to use device's default locale if supported
  void _tryUseDeviceLocale() {
    // This will be called from main.dart with actual device locale
    // For now, keep default Chinese
  }

  /// Set locale based on device locale
  void setDeviceLocale(Locale? deviceLocale) {
    if (deviceLocale != null) {
      // Check if we support this language
      final matchingLocale = supportedLocales.firstWhere(
        (locale) => locale.languageCode == deviceLocale.languageCode,
        orElse: () => const Locale('en'), // Fallback to English
      );
      _currentLocale = matchingLocale;
      notifyListeners();
    }
  }
}
