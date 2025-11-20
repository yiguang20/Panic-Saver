import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/preferences_repository.dart';
import 'domain/providers/crisis_provider.dart';
import 'domain/providers/language_provider.dart';
import 'domain/providers/settings_provider.dart';
import 'presentation/l10n/app_localizations.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/settings_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  try {
    // Initialize preferences repository
    final preferencesRepository = await PreferencesRepository.create();

    runApp(PanicSaverApp(preferencesRepository: preferencesRepository));
  } catch (e) {
    // If initialization fails, run app with default repository
    runApp(const ErrorApp());
  }
}

/// Error app shown when initialization fails
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Failed to initialize app',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please restart the application',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PanicSaverApp extends StatelessWidget {
  final PreferencesRepository preferencesRepository;

  const PanicSaverApp({
    super.key,
    required this.preferencesRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(preferencesRepository)
            ..loadSavedLocale(),
        ),
        ChangeNotifierProvider(
          create: (_) => CrisisProvider(preferencesRepository)..restoreState(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(preferencesRepository)..loadSettings(),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, _) {
          return MaterialApp(
            title: 'Panic Relief',
            theme: AppTheme.theme,
            locale: languageProvider.currentLocale,
            supportedLocales: languageProvider.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
