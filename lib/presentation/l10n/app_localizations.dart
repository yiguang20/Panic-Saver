import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Panic Relief'**
  String get appTitle;

  /// Language toggle button text
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get langToggle;

  /// Crisis mode navigation label
  ///
  /// In en, this message translates to:
  /// **'CRISIS'**
  String get navCrisis;

  /// Practice mode navigation label
  ///
  /// In en, this message translates to:
  /// **'PRACTICE'**
  String get navPractice;

  /// Hint text for double tap gesture
  ///
  /// In en, this message translates to:
  /// **'Double tap screen for Help Letter'**
  String get hintDoubleTap;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get step1Title;

  /// No description provided for @step1Text.
  ///
  /// In en, this message translates to:
  /// **'If possible, put on your headphones. Find a quiet corner. You are entering a safe space.'**
  String get step1Text;

  /// No description provided for @step1Sub.
  ///
  /// In en, this message translates to:
  /// **'Create a physical barrier.'**
  String get step1Sub;

  /// No description provided for @step1Btn.
  ///
  /// In en, this message translates to:
  /// **'I\'m ready'**
  String get step1Btn;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Stop & Pause'**
  String get step2Title;

  /// No description provided for @step2Text.
  ///
  /// In en, this message translates to:
  /// **'Stop whatever you are doing. Sit down. Feel the chair supporting you. You are safe.'**
  String get step2Text;

  /// No description provided for @step2Sub.
  ///
  /// In en, this message translates to:
  /// **'\"I am uncomfortable, but I am not in danger.\"'**
  String get step2Sub;

  /// No description provided for @step2Btn.
  ///
  /// In en, this message translates to:
  /// **'I\'ve paused'**
  String get step2Btn;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Breathe with Me'**
  String get step3Title;

  /// No description provided for @step3Text.
  ///
  /// In en, this message translates to:
  /// **'Focus on the circle. Inhale as it expands. Exhale as it shrinks. Let your belly rise.'**
  String get step3Text;

  /// No description provided for @step3Sub.
  ///
  /// In en, this message translates to:
  /// **'4-7-8 Rhythm'**
  String get step3Sub;

  /// No description provided for @step3Btn.
  ///
  /// In en, this message translates to:
  /// **'Breathing...'**
  String get step3Btn;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Grounding'**
  String get step4Title;

  /// No description provided for @step4Text.
  ///
  /// In en, this message translates to:
  /// **'Look around. Find 3 distinct colors. Name them out loud. Bring your mind back to reality.'**
  String get step4Text;

  /// No description provided for @step4Sub.
  ///
  /// In en, this message translates to:
  /// **'You are here, right now.'**
  String get step4Sub;

  /// No description provided for @step4Btn.
  ///
  /// In en, this message translates to:
  /// **'I see them'**
  String get step4Btn;

  /// No description provided for @step5Title.
  ///
  /// In en, this message translates to:
  /// **'Truth Talk'**
  String get step5Title;

  /// No description provided for @step5Text.
  ///
  /// In en, this message translates to:
  /// **'Your heart is racing because of adrenaline. It\'s a false alarm from your body.'**
  String get step5Text;

  /// No description provided for @step5Sub.
  ///
  /// In en, this message translates to:
  /// **'\"This feeling will pass in minutes.\"'**
  String get step5Sub;

  /// No description provided for @step5Btn.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get step5Btn;

  /// No description provided for @step6Title.
  ///
  /// In en, this message translates to:
  /// **'Floating'**
  String get step6Title;

  /// No description provided for @step6Text.
  ///
  /// In en, this message translates to:
  /// **'Don\'t fight the feeling. Imagine you are a feather floating on a wave. Let the wave carry you.'**
  String get step6Text;

  /// No description provided for @step6Sub.
  ///
  /// In en, this message translates to:
  /// **'Acceptance dissolves the tension.'**
  String get step6Sub;

  /// No description provided for @step6Btn.
  ///
  /// In en, this message translates to:
  /// **'I am floating'**
  String get step6Btn;

  /// No description provided for @step7Title.
  ///
  /// In en, this message translates to:
  /// **'Be Gentle'**
  String get step7Title;

  /// No description provided for @step7Text.
  ///
  /// In en, this message translates to:
  /// **'Don\'t blame yourself. You are handling this difficult moment with great courage.'**
  String get step7Text;

  /// No description provided for @step7Sub.
  ///
  /// In en, this message translates to:
  /// **'\"I love and accept myself.\"'**
  String get step7Sub;

  /// No description provided for @step7Btn.
  ///
  /// In en, this message translates to:
  /// **'I am trying'**
  String get step7Btn;

  /// No description provided for @step8Title.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get step8Title;

  /// No description provided for @step8Text.
  ///
  /// In en, this message translates to:
  /// **'The peak is over. Let time pass. Do not rush to feel \'normal\' immediately.'**
  String get step8Text;

  /// No description provided for @step8Sub.
  ///
  /// In en, this message translates to:
  /// **'Patience is key.'**
  String get step8Sub;

  /// No description provided for @step8Btn.
  ///
  /// In en, this message translates to:
  /// **'Waiting...'**
  String get step8Btn;

  /// No description provided for @step9Title.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get step9Title;

  /// No description provided for @step9Text.
  ///
  /// In en, this message translates to:
  /// **'You have ridden the wave. You are strong. Take a sip of water when you are ready.'**
  String get step9Text;

  /// No description provided for @step9Sub.
  ///
  /// In en, this message translates to:
  /// **'Welcome back.'**
  String get step9Sub;

  /// No description provided for @step9Btn.
  ///
  /// In en, this message translates to:
  /// **'Start Over'**
  String get step9Btn;

  /// No description provided for @helpHeading.
  ///
  /// In en, this message translates to:
  /// **'I Need Help'**
  String get helpHeading;

  /// No description provided for @helpSubheading.
  ///
  /// In en, this message translates to:
  /// **'PLEASE READ THIS'**
  String get helpSubheading;

  /// No description provided for @helpP1.
  ///
  /// In en, this message translates to:
  /// **'I am having a Panic Attack. I cannot speak clearly right now.'**
  String get helpP1;

  /// No description provided for @helpP2.
  ///
  /// In en, this message translates to:
  /// **'I am NOT dying.'**
  String get helpP2;

  /// No description provided for @helpP3.
  ///
  /// In en, this message translates to:
  /// **'I am NOT dangerous.'**
  String get helpP3;

  /// No description provided for @helpP4.
  ///
  /// In en, this message translates to:
  /// **'Please do not call an ambulance unless I ask.'**
  String get helpP4;

  /// No description provided for @helpP5.
  ///
  /// In en, this message translates to:
  /// **'Please just sit with me calmly until my breathing slows down. Thank you.'**
  String get helpP5;

  /// No description provided for @helpBack.
  ///
  /// In en, this message translates to:
  /// **'Back to Guide'**
  String get helpBack;

  /// No description provided for @pracTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Practice'**
  String get pracTitle;

  /// No description provided for @pracSub.
  ///
  /// In en, this message translates to:
  /// **'Build resilience before the storm.'**
  String get pracSub;

  /// No description provided for @prac1Title.
  ///
  /// In en, this message translates to:
  /// **'Deep Breath'**
  String get prac1Title;

  /// No description provided for @prac1Desc.
  ///
  /// In en, this message translates to:
  /// **'Abdominal breathing '**
  String get prac1Desc;

  /// No description provided for @prac2Title.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get prac2Title;

  /// No description provided for @prac2Desc.
  ///
  /// In en, this message translates to:
  /// **'Release energy '**
  String get prac2Desc;

  /// No description provided for @prac3Title.
  ///
  /// In en, this message translates to:
  /// **'Self Talk'**
  String get prac3Title;

  /// No description provided for @prac3Desc.
  ///
  /// In en, this message translates to:
  /// **'Positive logic '**
  String get prac3Desc;

  /// No description provided for @prac4Title.
  ///
  /// In en, this message translates to:
  /// **'Acceptance'**
  String get prac4Title;

  /// No description provided for @prac4Desc.
  ///
  /// In en, this message translates to:
  /// **'Floating technique '**
  String get prac4Desc;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @breathingSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Breathing Settings'**
  String get breathingSettingsTitle;

  /// No description provided for @themeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettingsTitle;

  /// No description provided for @presetBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner (3-5-6)'**
  String get presetBeginner;

  /// No description provided for @presetStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard (4-7-8)'**
  String get presetStandard;

  /// No description provided for @presetAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced (5-8-10)'**
  String get presetAdvanced;

  /// No description provided for @customBreathingButton.
  ///
  /// In en, this message translates to:
  /// **'Record Custom Rhythm'**
  String get customBreathingButton;

  /// No description provided for @currentBreathingRhythm.
  ///
  /// In en, this message translates to:
  /// **'Current Breathing Rhythm'**
  String get currentBreathingRhythm;

  /// No description provided for @inhale.
  ///
  /// In en, this message translates to:
  /// **'Inhale'**
  String get inhale;

  /// No description provided for @hold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get hold;

  /// No description provided for @exhale.
  ///
  /// In en, this message translates to:
  /// **'Exhale'**
  String get exhale;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @totalCycle.
  ///
  /// In en, this message translates to:
  /// **'Total Cycle'**
  String get totalCycle;

  /// No description provided for @themeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Theme colors and content editing features'**
  String get themeComingSoon;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon...'**
  String get comingSoon;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get resetButton;

  /// No description provided for @resetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetDialogTitle;

  /// No description provided for @resetDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to default values?'**
  String get resetDialogContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @breathingRecorderTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Breathing Rhythm'**
  String get breathingRecorderTitle;

  /// No description provided for @recordYourRhythm.
  ///
  /// In en, this message translates to:
  /// **'Record Your Rhythm'**
  String get recordYourRhythm;

  /// No description provided for @recordedCycles.
  ///
  /// In en, this message translates to:
  /// **'Recorded Cycles'**
  String get recordedCycles;

  /// No description provided for @cycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycle;

  /// No description provided for @useThisRhythm.
  ///
  /// In en, this message translates to:
  /// **'Use This Rhythm'**
  String get useThisRhythm;

  /// No description provided for @continueRecording.
  ///
  /// In en, this message translates to:
  /// **'Continue recording cycle'**
  String get continueRecording;

  /// No description provided for @instructionWaiting.
  ///
  /// In en, this message translates to:
  /// **'Hold the circle to start inhaling\nRelease to hold breath\nHold again to exhale\nRepeat 3 times'**
  String get instructionWaiting;

  /// No description provided for @instructionInhaling.
  ///
  /// In en, this message translates to:
  /// **'Inhaling...\nRelease to hold breath'**
  String get instructionInhaling;

  /// No description provided for @instructionHoldingAfterInhale.
  ///
  /// In en, this message translates to:
  /// **'Holding breath...\nHold to start exhaling'**
  String get instructionHoldingAfterInhale;

  /// No description provided for @instructionExhaling.
  ///
  /// In en, this message translates to:
  /// **'Exhaling...\nRelease to complete cycle'**
  String get instructionExhaling;

  /// No description provided for @instructionHoldingAfterExhale.
  ///
  /// In en, this message translates to:
  /// **'Holding breath...\nHold to start next cycle'**
  String get instructionHoldingAfterExhale;

  /// No description provided for @phaseHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get phaseHold;

  /// No description provided for @phaseInhale.
  ///
  /// In en, this message translates to:
  /// **'Inhale'**
  String get phaseInhale;

  /// No description provided for @phaseExhale.
  ///
  /// In en, this message translates to:
  /// **'Exhale'**
  String get phaseExhale;

  /// No description provided for @practiceYourRhythm.
  ///
  /// In en, this message translates to:
  /// **'Practice Your Rhythm'**
  String get practiceYourRhythm;

  /// No description provided for @enterCustomRhythm.
  ///
  /// In en, this message translates to:
  /// **'Enter Custom Rhythm'**
  String get enterCustomRhythm;

  /// No description provided for @inhaleSeconds.
  ///
  /// In en, this message translates to:
  /// **'Inhale (seconds)'**
  String get inhaleSeconds;

  /// No description provided for @holdSeconds.
  ///
  /// In en, this message translates to:
  /// **'Hold (seconds)'**
  String get holdSeconds;

  /// No description provided for @exhaleSeconds.
  ///
  /// In en, this message translates to:
  /// **'Exhale (seconds)'**
  String get exhaleSeconds;

  /// No description provided for @startPractice.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPractice;

  /// No description provided for @saveAsCustom.
  ///
  /// In en, this message translates to:
  /// **'Save as Custom Rhythm'**
  String get saveAsCustom;

  /// No description provided for @practiceInstructions.
  ///
  /// In en, this message translates to:
  /// **'Practice this rhythm and adjust until you find what feels comfortable'**
  String get practiceInstructions;

  /// No description provided for @rhythmSaved.
  ///
  /// In en, this message translates to:
  /// **'Rhythm saved successfully!'**
  String get rhythmSaved;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numbers greater than 0'**
  String get invalidInput;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingsTitle;

  /// No description provided for @languageSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get languageSettingsSubtitle;

  /// No description provided for @breathingSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize breathing rhythm'**
  String get breathingSettingsSubtitle;

  /// No description provided for @themeSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize colors and appearance'**
  String get themeSettingsSubtitle;

  /// No description provided for @cardManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Card Management'**
  String get cardManagementTitle;

  /// No description provided for @cardManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit and organize crisis cards'**
  String get cardManagementSubtitle;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your session history'**
  String get calendarSubtitle;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App information and credits'**
  String get aboutSubtitle;

  /// No description provided for @selectLanguagePrompt.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectLanguagePrompt;

  /// No description provided for @breathingPresetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get breathingPresetsTitle;

  /// No description provided for @customBreathingTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customBreathingTitle;

  /// No description provided for @currentSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Settings'**
  String get currentSettingsTitle;

  /// No description provided for @unwindingTitle.
  ///
  /// In en, this message translates to:
  /// **'Unwinding'**
  String get unwindingTitle;

  /// No description provided for @unwindingInstructions.
  ///
  /// In en, this message translates to:
  /// **'Watch the rope unwind as you count down. Let go of tension with each number.'**
  String get unwindingInstructions;

  /// No description provided for @unwindingComplete.
  ///
  /// In en, this message translates to:
  /// **'Well done! You\'ve released the tension.'**
  String get unwindingComplete;

  /// No description provided for @breathingReminder.
  ///
  /// In en, this message translates to:
  /// **'Keep breathing deeply'**
  String get breathingReminder;

  /// No description provided for @listeningTitle.
  ///
  /// In en, this message translates to:
  /// **'Listen & Observe'**
  String get listeningTitle;

  /// No description provided for @listeningInstructions.
  ///
  /// In en, this message translates to:
  /// **'Close your eyes. Listen to the sounds around you. Identify and mark each sound you hear.'**
  String get listeningInstructions;

  /// No description provided for @listeningMinimumTime.
  ///
  /// In en, this message translates to:
  /// **'Continue listening for at least 2 minutes'**
  String get listeningMinimumTime;

  /// No description provided for @listeningCanContinue.
  ///
  /// In en, this message translates to:
  /// **'Great! You can continue when ready'**
  String get listeningCanContinue;

  /// No description provided for @soundVoices.
  ///
  /// In en, this message translates to:
  /// **'Voices'**
  String get soundVoices;

  /// No description provided for @soundNature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get soundNature;

  /// No description provided for @soundMechanical.
  ///
  /// In en, this message translates to:
  /// **'Mechanical'**
  String get soundMechanical;

  /// No description provided for @soundMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get soundMusic;

  /// No description provided for @soundAmbient.
  ///
  /// In en, this message translates to:
  /// **'Ambient'**
  String get soundAmbient;

  /// No description provided for @affirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Self-Affirmation'**
  String get affirmationTitle;

  /// No description provided for @affirmationInstructions.
  ///
  /// In en, this message translates to:
  /// **'Read each statement slowly. Let the words sink in.'**
  String get affirmationInstructions;

  /// No description provided for @affirmationComplete.
  ///
  /// In en, this message translates to:
  /// **'You\'ve completed all affirmations. You are strong.'**
  String get affirmationComplete;

  /// No description provided for @affirmation1.
  ///
  /// In en, this message translates to:
  /// **'I am safe'**
  String get affirmation1;

  /// No description provided for @affirmation2.
  ///
  /// In en, this message translates to:
  /// **'This is just a physical reaction'**
  String get affirmation2;

  /// No description provided for @affirmation3.
  ///
  /// In en, this message translates to:
  /// **'It will pass naturally'**
  String get affirmation3;

  /// No description provided for @affirmation4.
  ///
  /// In en, this message translates to:
  /// **'I will wait patiently'**
  String get affirmation4;

  /// No description provided for @affirmation5.
  ///
  /// In en, this message translates to:
  /// **'I accept and love myself'**
  String get affirmation5;

  /// No description provided for @nextAffirmation.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextAffirmation;

  /// No description provided for @calendarNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded yet'**
  String get calendarNoSessions;

  /// No description provided for @calendarTotalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get calendarTotalSessions;

  /// No description provided for @calendarAverageDuration.
  ///
  /// In en, this message translates to:
  /// **'Average Duration'**
  String get calendarAverageDuration;

  /// No description provided for @calendarMostCommonTime.
  ///
  /// In en, this message translates to:
  /// **'Most Common Time'**
  String get calendarMostCommonTime;

  /// No description provided for @calendarLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get calendarLongestStreak;

  /// No description provided for @calendarDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get calendarDays;

  /// No description provided for @calendarSessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get calendarSessionDetails;

  /// No description provided for @calendarStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get calendarStartTime;

  /// No description provided for @calendarDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get calendarDuration;

  /// No description provided for @calendarStepsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Steps Completed'**
  String get calendarStepsCompleted;

  /// No description provided for @cardEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Card'**
  String get cardEditorTitle;

  /// No description provided for @cardEditorTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get cardEditorTitleLabel;

  /// No description provided for @cardEditorMainTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Main Text'**
  String get cardEditorMainTextLabel;

  /// No description provided for @cardEditorSubTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Sub Text'**
  String get cardEditorSubTextLabel;

  /// No description provided for @cardEditorButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Button Text'**
  String get cardEditorButtonLabel;

  /// No description provided for @cardEditorSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get cardEditorSave;

  /// No description provided for @cardEditorReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get cardEditorReset;

  /// No description provided for @cardEditorPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get cardEditorPreview;

  /// No description provided for @cardEditorUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes'**
  String get cardEditorUnsavedChanges;

  /// No description provided for @cardEditorDiscardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get cardEditorDiscardChanges;

  /// No description provided for @practiceStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String practiceStepOf(int current, int total);

  /// No description provided for @practiceComplete.
  ///
  /// In en, this message translates to:
  /// **'Practice Complete!'**
  String get practiceComplete;

  /// No description provided for @practiceWellDone.
  ///
  /// In en, this message translates to:
  /// **'Well done! Regular practice builds resilience.'**
  String get practiceWellDone;

  /// No description provided for @practiceNext.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get practiceNext;

  /// No description provided for @practicePrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get practicePrevious;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get exportSuccess;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get importSuccess;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Failed to export data'**
  String get exportError;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Failed to import data'**
  String get importError;

  /// No description provided for @holdToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Hold to confirm'**
  String get holdToConfirm;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
