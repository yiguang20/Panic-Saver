# Implementation Plan

- [x] 1. Set up Flutter project structure and dependencies



  - Create new Flutter project with Android support
  - Add required dependencies: provider, shared_preferences, flutter_localizations, intl
  - Configure project for minimum SDK version (API 21+)
  - Set up directory structure following the design document
  - _Requirements: 9.1_

- [x] 2. Implement core data models and constants


  - [x] 2.1 Create data model classes



    - Implement CrisisStep model with all required fields
    - Implement PracticeItem model
    - Implement HelpLetterContent model
    - Add JSON serialization support for models
    - _Requirements: 9.1_
  
  - [x] 2.2 Define app constants


    - Create colors.dart with navy, aqua, lilac, cream color definitions
    - Create dimensions.dart with spacing, sizing constants
    - Create durations.dart with animation timing constants
    - _Requirements: 6.1_
  
  - [x] 2.3 Create app theme


    - Implement AppTheme with color scheme
    - Define text styles for different UI elements
    - Configure button themes and input decorations
    - _Requirements: 6.1_

- [x] 3. Implement localization infrastructure


  - [x] 3.1 Set up ARB files for all languages


    - Create app_en.arb with English translations
    - Create app_zh.arb with Chinese translations
    - Create app_es.arb with Spanish translations
    - Create app_fr.arb with French translations
    - Create app_de.arb with German translations
    - Include all crisis steps, help letter, practice items, and UI labels
    - _Requirements: 4.5_
  
  - [x] 3.2 Implement ContentRepository



    - Create method to load crisis steps for given locale
    - Create method to load help letter content for given locale
    - Create method to load practice items for given locale
    - _Requirements: 4.3_
  
  - [ ]* 3.3 Write property test for localization
    - **Property 8: Language consistency**
    - **Validates: Requirements 3.6, 4.3, 5.5**

- [x] 4. Implement local storage and state persistence


  - [x] 4.1 Create PreferencesRepository


    - Implement saveCurrentStep and loadCurrentStep methods
    - Implement saveLanguage and loadLanguage methods
    - Handle storage errors gracefully with fallbacks
    - _Requirements: 8.1, 8.2, 8.3_
  
  - [ ]* 4.2 Write property test for state persistence
    - **Property 15: Step state persistence round-trip**
    - **Validates: Requirements 8.1, 8.2**
  
  - [ ]* 4.3 Write property test for language persistence
    - **Property 10: Language persistence round-trip**
    - **Validates: Requirements 4.6, 8.3**





- [x] 5. Implement state management providers

  - [x] 5.1 Create CrisisProvider

    - Implement currentStep, isFlipped state variables
    - Implement nextStep() method with step advancement logic
    - Implement resetSteps() method
    - Implement flipCard() method for help letter toggle
    - Implement restoreState() method for persistence
    - _Requirements: 2.2, 3.1, 8.2_
  
  - [x]* 5.2 Write property test for step advancement


    - **Property 3: Step advancement**
    - **Validates: Requirements 2.2**
  
  - [x] 5.3 Create LanguageProvider

    - Implement currentLocale state variable
    - Implement toggleLanguage() method
    - Implement setLocale() method
    - Integrate with PreferencesRepository for persistence
    - _Requirements: 4.2, 4.6_
  
  - [ ]* 5.4 Write property test for language cycling
    - **Property 9: Language cycling**
    - **Validates: Requirements 4.2**

- [x] 6. Implement animated background and visual effects


  - [x] 6.1 Create AnimatedBackground widget



    - Implement gradient background with navy/aqua/lilac colors
    - Add animated orb elements with floating animation
    - Add star particles with twinkling effect
    - Optimize performance with RepaintBoundary
    - _Requirements: 6.2_
  
  - [x] 6.2 Create BubbleEffect widget


    - Implement expanding bubble animation at tap coordinates
    - Use radial gradient for bubble appearance
    - Animate scale from 0 to 30 over 1.4 seconds
    - Auto-remove bubble after animation completes
    - _Requirements: 3.2_
  
  - [ ]* 6.3 Write property test for bubble positioning
    - **Property 6: Bubble effect positioning**
    - **Validates: Requirements 3.2**

- [x] 7. Implement crisis mode UI components


  - [x] 7.1 Create ProgressBar widget


    - Display 9 dots representing all steps
    - Highlight current step with aqua color and glow
    - Show completed steps with lilac color
    - Show future steps with low opacity
    - _Requirements: 1.3, 2.6_
  
  - [ ]* 7.2 Write property test for progress indicator
    - **Property 1: Progress indicator reflects current step**
    - **Validates: Requirements 1.3, 2.6**
  
  - [x] 7.3 Create VisualIcon widget


    - Implement icon rendering for different step types (prep, stop, ground, etc.)
    - Add drop shadow and glow effects
    - _Requirements: 2.1_
  
  - [x] 7.4 Create BreathingOrb widget


    - Implement circular orb with gradient
    - Add scale animation with 4-7-8 timing (inhale 4s, hold 7s, exhale 8s)
    - Display "4-7-8" text in center
    - Use AnimationController for smooth looping
    - _Requirements: 2.4, 2.5_
  
  - [x] 7.5 Create StepContent widget




    - Display step title, text, sub-text
    - Implement fade-in/fade-out transitions
    - Integrate VisualIcon or BreathingOrb based on step type
    - _Requirements: 2.1, 2.3_
  
  - [ ]* 7.6 Write property test for step content completeness
    - **Property 2: Step content completeness**
    - **Validates: Requirements 2.1**
  
  - [ ]* 7.7 Write property test for animation duration
    - **Property 4: Animation duration bounds**
    - **Validates: Requirements 2.3**

- [x] 8. Implement card flip animation and help letter


  - [x] 8.1 Create CardFlipAnimation widget


    - Implement 3D flip animation using Transform
    - Set perspective for realistic 3D effect
    - Use cubic-bezier easing for smooth flip
    - Duration should be 1.2 seconds
    - _Requirements: 3.1_
  
  - [x] 8.2 Create HelpLetterCard widget




    - Implement paper-like background with cream color
    - Display red accent bar at top
    - Render all help letter sections with proper formatting
    - Add back button to flip back to crisis mode
    - _Requirements: 3.3, 3.4_
  
  - [x] 8.3 Create CrisisCard widget


    - Implement frosted glass effect with backdrop blur
    - Integrate ProgressBar, StepContent, and action button
    - Handle double-tap gesture detection
    - Trigger bubble effect and card flip on double-tap
    - _Requirements: 3.1, 3.2, 6.4_
  
  - [ ]* 8.4 Write property test for double-tap flip
    - **Property 5: Double-tap flip trigger**
    - **Validates: Requirements 3.1**
  
  - [ ]* 8.5 Write property test for help letter state preservation
    - **Property 7: Help letter state preservation**
    - **Validates: Requirements 3.5**

- [ ] 9. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [x] 10. Implement practice mode UI

  - [x] 10.1 Create PracticeCard widget

    - Display practice icon, title, and description
    - Add hover/press effects with scale animation
    - Use frosted glass background
    - _Requirements: 5.3_
  
  - [ ]* 10.2 Write property test for practice card content
    - **Property 11: Practice card content**
    - **Validates: Requirements 5.3**
  
  - [x] 10.3 Create PracticeOverlay widget



    - Implement slide-up animation from bottom
    - Display grid of 4 practice cards
    - Add close button with slide-down animation
    - Add drag handle at top
    - _Requirements: 5.1, 5.2, 5.4_

- [x] 11. Implement navigation and main screen


  - [x] 11.1 Create BottomNavigation widget

    - Display Crisis and Practice tabs
    - Highlight active tab with aqua color
    - Add icon scale animation on selection
    - _Requirements: 5.1_
  
  - [x] 11.2 Create LanguageToggle widget

    - Display current language code
    - Cycle through languages on tap
    - Persist language selection
    - _Requirements: 4.2_
  
  - [x] 11.3 Create HomeScreen

    - Integrate AnimatedBackground
    - Integrate CrisisCard with flip animation
    - Integrate PracticeOverlay
    - Integrate BottomNavigation
    - Add LanguageToggle in header
    - Handle initial state restoration
    - _Requirements: 1.1, 1.2_

- [x] 12. Implement haptic feedback



  - [x] 12.1 Create HapticUtils


    - Implement method to check if device supports haptics
    - Implement method to respect device haptic settings
    - Create methods for light, medium, heavy impact
    - _Requirements: 10.4, 10.5_
  
  - [x] 12.2 Integrate haptic feedback in UI


    - Add light haptic on button taps
    - Add medium haptic on step transitions
    - Add heavy haptic on help letter flip
    - _Requirements: 10.1, 10.2, 10.3_
  
  - [ ]* 12.3 Write property test for haptic feedback
    - **Property 16: Haptic feedback on buttons**
    - **Property 17: Haptic feedback on transitions**
    - **Property 18: Haptic settings respect**
    - **Validates: Requirements 10.1, 10.3, 10.4**

- [x] 13. Implement app initialization and configuration


  - [x] 13.1 Create App widget

    - Configure MaterialApp with theme
    - Set up localization delegates
    - Configure supported locales
    - Set home screen
    - _Requirements: 4.1, 4.5_
  
  - [x] 13.2 Implement main.dart

    - Initialize providers
    - Load saved state (language, current step)
    - Run app with error handling
    - _Requirements: 1.1, 8.2_

- [x] 14. Implement offline functionality verification


  - [ ]* 14.1 Write property test for offline functionality
    - **Property 14: Offline functionality**
    - **Validates: Requirements 7.2**
  
  - [x] 14.2 Verify no network dependencies


    - Ensure all content is bundled locally
    - Verify no network requests in code
    - Test app with airplane mode enabled
    - _Requirements: 7.1, 7.2, 7.5_

- [ ] 15. Implement color palette consistency
  - [ ]* 15.1 Write property test for color palette
    - **Property 12: Color palette consistency**
    - **Validates: Requirements 6.1**

- [ ] 16. Implement button interaction feedback
  - [ ]* 16.1 Write property test for button feedback
    - **Property 13: Button interaction feedback**
    - **Validates: Requirements 6.3**

- [x] 17. Polish and optimize



  - [x] 17.1 Optimize animations

    - Add RepaintBoundary to complex widgets
    - Implement shouldRepaint in custom painters
    - Profile and optimize frame rate
    - _Requirements: 6.5_
  
  - [x] 17.2 Accessibility improvements


    - Add semantic labels to all interactive widgets
    - Test with TalkBack screen reader
    - Verify contrast ratios meet WCAG AA
    - Ensure touch targets are ≥ 48dp
    - _Requirements: 1.5_
  
  - [x] 17.3 Error handling


    - Add error boundaries for widget errors
    - Handle storage failures gracefully
    - Add fallbacks for missing translations
    - _Requirements: 8.4_

- [ ] 18. Final checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 19. Build and test Android APK
  - [ ] 19.1 Configure Android build
    - Set app name, package name, version
    - Configure app icon and splash screen
    - Set minimum SDK version to API 21
    - _Requirements: 9.1_
  
  - [ ] 19.2 Build and test APK
    - Build debug APK
    - Test on physical Android device
    - Verify all features work correctly
    - Test with different screen sizes
    - _Requirements: 1.1_
