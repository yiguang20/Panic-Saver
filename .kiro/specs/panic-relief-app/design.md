# Design Document

## Overview

Panic Relief App 是一款基于 Flutter 框架开发的 Android 应用，专为焦虑症患者在惊恐发作时提供即时指导和支持。应用采用单页面架构，通过底部导航在危机应对模式和日常练习模式之间切换。核心设计理念是简洁、直观、治愈性强，确保用户在高度焦虑状态下也能轻松使用。

应用的设计遵循《焦虑症与恐惧症手册》中的科学方法，包括：
- 面对、接受、漂浮、等待（威克斯方法）
- 腹式呼吸技术
- 着地技术（Grounding）
- 认知重构（自我对话）

## Architecture

### Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **State Management**: Provider / Riverpod
- **Local Storage**: SharedPreferences + Hive
- **Internationalization**: flutter_localizations + intl
- **Animations**: Flutter built-in animations + custom AnimationController
- **Platform**: Android (API 21+)

### Application Architecture

应用采用分层架构模式：

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Widgets, Screens, Animations)     │
└─────────────────────────────────────┘
              ↓ ↑
┌─────────────────────────────────────┐
│         Business Logic Layer        │
│  (Providers, State Management)      │
└─────────────────────────────────────┘
              ↓ ↑
┌─────────────────────────────────────┐
│           Data Layer                │
│  (Models, Repositories, Storage)    │
└─────────────────────────────────────┘
```

### Directory Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── colors.dart
│   │   ├── dimensions.dart
│   │   └── durations.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       ├── haptic_utils.dart
│       └── animation_utils.dart
├── data/
│   ├── models/
│   │   ├── crisis_step.dart
│   │   ├── practice_item.dart
│   │   └── app_state.dart
│   ├── repositories/
│   │   ├── content_repository.dart
│   │   └── preferences_repository.dart
│   └── sources/
│       ├── local_storage.dart
│       └── content_data.dart
├── domain/
│   ├── providers/
│   │   ├── crisis_provider.dart
│   │   ├── language_provider.dart
│   │   └── practice_provider.dart
│   └── services/
│       └── localization_service.dart
├── presentation/
│   ├── screens/
│   │   └── home_screen.dart
│   ├── widgets/
│   │   ├── crisis/
│   │   │   ├── crisis_card.dart
│   │   │   ├── step_content.dart
│   │   │   ├── progress_bar.dart
│   │   │   ├── breathing_orb.dart
│   │   │   └── visual_icon.dart
│   │   ├── help_letter/
│   │   │   └── help_letter_card.dart
│   │   ├── practice/
│   │   │   ├── practice_overlay.dart
│   │   │   └── practice_card.dart
│   │   ├── common/
│   │   │   ├── animated_background.dart
│   │   │   ├── bottom_navigation.dart
│   │   │   └── language_toggle.dart
│   │   └── animations/
│   │       ├── card_flip_animation.dart
│   │       ├── bubble_effect.dart
│   │       └── slide_animation.dart
│   └── l10n/
│       ├── app_en.arb
│       ├── app_zh.arb
│       ├── app_es.arb
│       ├── app_fr.arb
│       └── app_de.arb
└── generated/
    └── l10n/
```

## Components and Interfaces

### Core Components

#### 1. CrisisProvider

管理危机应对模式的状态：

```dart
class CrisisProvider extends ChangeNotifier {
  int _currentStep = 0;
  bool _isFlipped = false;
  
  int get currentStep => _currentStep;
  bool get isFlipped => _isFlipped;
  int get totalSteps => 9;
  
  void nextStep();
  void resetSteps();
  void flipCard();
  void restoreState(int step);
}
```

#### 2. LanguageProvider

管理多语言切换：

```dart
class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale;
  
  Locale get currentLocale => _currentLocale;
  List<Locale> get supportedLocales => [
    Locale('en'), Locale('zh'), Locale('es'), 
    Locale('fr'), Locale('de')
  ];
  
  void toggleLanguage();
  void setLocale(Locale locale);
  Future<void> loadSavedLocale();
  Future<void> saveLocale(Locale locale);
}
```

#### 3. ContentRepository

提供本地化内容：

```dart
class ContentRepository {
  List<CrisisStep> getCrisisSteps(Locale locale);
  HelpLetterContent getHelpLetter(Locale locale);
  List<PracticeItem> getPracticeItems(Locale locale);
}
```

#### 4. PreferencesRepository

管理持久化数据：

```dart
class PreferencesRepository {
  Future<void> saveCurrentStep(int step);
  Future<int?> loadCurrentStep();
  Future<void> saveLanguage(String languageCode);
  Future<String?> loadLanguage();
  Future<void> clearState();
}
```

### Data Models

#### CrisisStep

```dart
class CrisisStep {
  final int stepNumber;
  final String iconType;
  final String title;
  final String text;
  final String subText;
  final String buttonText;
  
  CrisisStep({
    required this.stepNumber,
    required this.iconType,
    required this.title,
    required this.text,
    required this.subText,
    required this.buttonText,
  });
}
```

#### PracticeItem

```dart
class PracticeItem {
  final String id;
  final String iconName;
  final String title;
  final String description;
  final String chapterReference;
  
  PracticeItem({
    required this.id,
    required this.iconName,
    required this.title,
    required this.description,
    required this.chapterReference,
  });
}
```

#### HelpLetterContent

```dart
class HelpLetterContent {
  final String heading;
  final String subheading;
  final String paragraph1;
  final String paragraph2;
  final String paragraph3;
  final String paragraph4;
  final String paragraph5;
  final String backButtonText;
  
  HelpLetterContent({
    required this.heading,
    required this.subheading,
    required this.paragraph1,
    required this.paragraph2,
    required this.paragraph3,
    required this.paragraph4,
    required this.paragraph5,
    required this.backButtonText,
  });
}
```

## Data Models

### Crisis Step Content Structure

9步危机应对流程的内容结构：

1. **Preparation (准备)**: 创建安全空间，戴耳机，找安静角落
2. **Stop & Pause (立刻停下)**: 停止当前活动，坐下，感受安全
3. **Breathe (跟随呼吸)**: 4-7-8呼吸法，腹式呼吸动画引导
4. **Grounding (着地技术)**: 找3个蓝色物体，感受现实
5. **Truth Talk (自我对话)**: 认识到这是肾上腺素，不是危险
6. **Floating (漂浮)**: 接受感觉，不对抗，像羽毛漂浮
7. **Compassion (自我关怀)**: 温柔对待自己，认可勇气
8. **Waiting (等待消退)**: 给时间，不急于恢复
9. **Return (回归)**: 庆祝战胜，喝水，准备回归生活

### Language Resource Structure

每种语言的资源文件包含：
- Crisis step content (9 steps × 4 fields)
- Help letter content (7 sections)
- Practice items (4 items × 3 fields)
- UI labels (navigation, buttons, hints)

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Progress indicator reflects current step

*For any* crisis step number from 0 to 8, when the user is on that step, the progress indicator should highlight exactly that step position.

**Validates: Requirements 1.3, 2.6**

### Property 2: Step content completeness

*For any* crisis step, the rendered UI should contain all required elements: title, descriptive text, sub-text, visual element, and action button.

**Validates: Requirements 2.1**

### Property 3: Step advancement

*For any* crisis step from 0 to 7, when the user taps the action button, the current step should increment by exactly 1.

**Validates: Requirements 2.2**

### Property 4: Animation duration bounds

*For any* step transition animation, the total duration should not exceed 1000 milliseconds.

**Validates: Requirements 2.3**

### Property 5: Double-tap flip trigger

*For any* tap location on the crisis mode screen, when a double-tap gesture is detected, the system should flip to show the help letter.

**Validates: Requirements 3.1**

### Property 6: Bubble effect positioning

*For any* double-tap coordinates (x, y), the bubble effect should be created at those exact coordinates before the flip animation.

**Validates: Requirements 3.2**

### Property 7: Help letter state preservation

*For any* crisis step number, when flipping to help letter and back, the system should return to the same step number.

**Validates: Requirements 3.5**

### Property 8: Language consistency

*For any* selected locale, all UI text elements (crisis steps, help letter, practice items, buttons) should be displayed in that locale.

**Validates: Requirements 3.6, 4.3, 5.5**

### Property 9: Language cycling

*For any* current language in the supported list, tapping the language toggle should switch to the next language in the sequence.

**Validates: Requirements 4.2**

### Property 10: Language persistence round-trip

*For any* supported locale, when set as the current language, closing and reopening the app should restore that same locale.

**Validates: Requirements 4.6, 8.3**

### Property 11: Practice card content

*For any* practice item, the rendered card should display the practice name, description, and chapter reference.

**Validates: Requirements 5.3**

### Property 12: Color palette consistency

*For any* screen in the app, the rendered colors should only use values from the defined palette (navy, aqua, lilac, cream, and their derivatives).

**Validates: Requirements 6.1**

### Property 13: Button interaction feedback

*For any* button widget, when tapped, a scale animation should be triggered.

**Validates: Requirements 6.3**

### Property 14: Offline functionality

*For any* app feature (crisis mode, help letter, practice mode, language switching), it should function without making network requests.

**Validates: Requirements 7.2**

### Property 15: Step state persistence round-trip

*For any* crisis step number, when the app is closed at that step and reopened, the system should restore to that same step number.

**Validates: Requirements 8.1, 8.2**

### Property 16: Haptic feedback on buttons

*For any* button tap event, the system should trigger haptic feedback (unless disabled by device settings).

**Validates: Requirements 10.1**

### Property 17: Haptic feedback on transitions

*For any* step transition, the system should provide haptic feedback.

**Validates: Requirements 10.3**

### Property 18: Haptic settings respect

*For any* haptic event, if the device has haptics disabled, no haptic feedback should be triggered.

**Validates: Requirements 10.4**

## Error Handling

### User Input Errors

- **Invalid gesture detection**: If tap events are ambiguous, default to single-tap behavior
- **Rapid tapping**: Debounce button taps to prevent accidental double-advancement
- **Gesture conflicts**: Prioritize double-tap over single-tap with a 300ms window

### State Errors

- **Corrupted saved state**: If loaded step number is invalid (< 0 or > 8), reset to step 0
- **Missing language preference**: If saved locale is not in supported list, use device default or fallback to English
- **Storage failures**: If SharedPreferences fails, continue with in-memory state only

### Animation Errors

- **Animation controller disposal**: Ensure all AnimationControllers are properly disposed to prevent memory leaks
- **Frame drops**: If frame rate drops below 30fps, simplify animations or reduce particle count
- **Animation interruption**: If user navigates away during animation, cancel animation gracefully

### Localization Errors

- **Missing translations**: If a translation key is missing, display the English fallback text
- **Malformed ARB files**: Validate ARB files at build time, fail build if invalid
- **Locale loading failure**: If locale resources fail to load, fallback to English

## Testing Strategy

### Unit Testing

- **Model classes**: Test CrisisStep, PracticeItem, HelpLetterContent serialization/deserialization
- **Providers**: Test state transitions in CrisisProvider, LanguageProvider
- **Repositories**: Test ContentRepository returns correct data for each locale
- **Utilities**: Test HapticUtils respects device settings

### Widget Testing

- **Crisis card**: Test step content renders correctly for each step
- **Progress bar**: Test correct step is highlighted
- **Breathing orb**: Test animation cycles with correct timing
- **Help letter**: Test all sections render with correct content
- **Practice overlay**: Test slide animations and card rendering
- **Language toggle**: Test language switching updates all text

### Property-Based Testing

We will use the `test` package with custom generators for property-based testing.

#### Test Generators

```dart
// Generate random step numbers (0-8)
Arbitrary<int> stepNumberGen() => 
  Arbitrary.choose(0, 8);

// Generate random locales from supported list
Arbitrary<Locale> localeGen() => 
  Arbitrary.oneOf([
    Arbitrary.constant(Locale('en')),
    Arbitrary.constant(Locale('zh')),
    Arbitrary.constant(Locale('es')),
    Arbitrary.constant(Locale('fr')),
    Arbitrary.constant(Locale('de')),
  ]);

// Generate random tap coordinates
Arbitrary<Offset> tapCoordinateGen() =>
  Arbitrary.tuple2(
    Arbitrary.choose(0.0, 400.0),
    Arbitrary.choose(0.0, 800.0),
  ).map((t) => Offset(t.$1, t.$2));
```

### Integration Testing

- **Full crisis flow**: Navigate through all 9 steps, verify each step displays correctly
- **Help letter flip**: Double-tap from various steps, verify flip animation and return
- **Language switching**: Switch between all languages, verify all content updates
- **State persistence**: Close and reopen app at various steps, verify state restoration
- **Offline mode**: Disable network, verify all features work

### Performance Testing

- **Animation frame rate**: Monitor FPS during animations, ensure ≥ 60fps
- **Memory usage**: Monitor memory during extended use, ensure no leaks
- **App startup time**: Measure cold start time, target < 2 seconds
- **State save/load time**: Measure persistence operations, target < 100ms

### Accessibility Testing

- **Screen reader**: Test with TalkBack, ensure all content is accessible
- **Contrast ratios**: Verify all text meets WCAG AA standards (4.5:1 for normal text)
- **Touch targets**: Ensure all interactive elements are ≥ 48dp
- **Font scaling**: Test with large font sizes, ensure layout doesn't break

## Implementation Notes

### Animation Performance

- Use `RepaintBoundary` for complex animated widgets
- Implement `shouldRepaint` in custom painters
- Cache expensive computations in animations
- Use `AnimatedBuilder` instead of `setState` for animations

### State Management Best Practices

- Keep providers focused on single responsibility
- Use `select` to minimize widget rebuilds
- Implement `==` and `hashCode` for model classes
- Use immutable data structures where possible

### Localization Best Practices

- Use ARB files for all user-facing strings
- Include context comments in ARB files for translators
- Test with pseudo-localization to catch hard-coded strings
- Support RTL languages in future (Arabic, Hebrew)

### Haptic Feedback Guidelines

- Use `HapticFeedback.lightImpact()` for button taps
- Use `HapticFeedback.mediumImpact()` for step transitions
- Use `HapticFeedback.heavyImpact()` for help letter flip
- Always check `HapticFeedback.hasVibrator()` before triggering

### Storage Strategy

- Use SharedPreferences for simple key-value pairs (language, current step)
- Use Hive for complex objects if needed in future (user notes, custom practices)
- Implement migration strategy for future schema changes
- Clear sensitive data on app uninstall

### Accessibility Considerations

- Provide semantic labels for all interactive widgets
- Use `Semantics` widget to enhance screen reader experience
- Ensure color is not the only means of conveying information
- Support dynamic font sizing
- Provide alternative text for all icons and images
