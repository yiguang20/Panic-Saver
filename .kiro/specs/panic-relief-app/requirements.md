# Requirements Document

## Introduction

Panic Relief App 是一款专为焦虑症患者设计的移动应用，旨在帮助用户在惊恐发作时进行有效应对，并通过日常练习建立心理防线。该应用基于《焦虑症与恐惧症手册》中的科学方法，提供即时的危机干预指导和长期的康复支持。

## Glossary

- **System**: Panic Relief App 移动应用系统
- **User**: 焦虑症患者或有惊恐发作经历的用户
- **Panic Attack**: 惊恐发作，突然出现的强烈恐惧和身体症状
- **Crisis Mode**: 危机应对模式，9步引导流程
- **Help Letter**: 求助信，向周围人展示的说明文档
- **Practice Mode**: 日常练习模式，预防性训练模块
- **Step**: 危机应对流程中的单个引导步骤
- **Breathing Exercise**: 呼吸练习，腹式呼吸技术
- **Grounding Technique**: 着地技术，帮助用户回到现实的方法
- **Locale**: 语言区域设置
- **Companion**: 陪伴者，支持用户的家人或朋友

## Requirements

### Requirement 1

**User Story:** 作为焦虑症患者，我希望在惊恐发作时能够快速进入危机应对模式，以便获得即时的引导和支持。

#### Acceptance Criteria

1. WHEN the User launches the System THEN the System SHALL display the Crisis Mode as the default screen
2. WHEN the User is in Crisis Mode THEN the System SHALL present a calming visual interface with soothing colors and minimal distractions
3. WHEN the User views the Crisis Mode THEN the System SHALL display the current step number and progress indicators for all 9 steps
4. WHEN the User completes the final step THEN the System SHALL provide an option to restart the crisis guidance from step 1
5. WHEN the System displays any step THEN the System SHALL ensure text is readable with sufficient contrast and appropriate font sizes

### Requirement 2

**User Story:** 作为焦虑症患者，我希望能够按照9步流程逐步应对惊恐发作，以便系统地缓解症状。

#### Acceptance Criteria

1. WHEN the User is on any step THEN the System SHALL display a step title, descriptive text, supportive sub-text, and a visual element
2. WHEN the User taps the action button THEN the System SHALL transition to the next step with a smooth animation
3. WHEN the System transitions between steps THEN the System SHALL use fade-out and fade-in animations lasting no more than 1 second
4. WHEN the User is on step 3 (Breathing) THEN the System SHALL display an animated breathing guide that expands and contracts rhythmically
5. WHEN the User views the breathing animation THEN the System SHALL cycle with a 4-7-8 rhythm (4 seconds inhale, 7 seconds hold, 8 seconds exhale)
6. WHEN the User is on any step THEN the System SHALL update the progress indicator to highlight the current step
7. WHEN the User navigates through all 9 steps THEN the System SHALL maintain the sequence: Preparation → Stop & Pause → Breathe → Grounding → Truth Talk → Floating → Compassion → Waiting → Return

### Requirement 3

**User Story:** 作为焦虑症患者，我希望能够快速向周围人展示求助信，以便在无法清晰表达时获得理解和帮助。

#### Acceptance Criteria

1. WHEN the User double-taps anywhere on the Crisis Mode screen THEN the System SHALL display the Help Letter with a card-flip animation
2. WHEN the System detects a double-tap THEN the System SHALL create a visual bubble effect at the tap location before flipping
3. WHEN the Help Letter is displayed THEN the System SHALL show a paper-like background with high contrast text
4. WHEN the Help Letter is displayed THEN the System SHALL include sections for: situation explanation, safety assurances, ambulance request guidance, and support request
5. WHEN the User taps the back button on Help Letter THEN the System SHALL flip back to the Crisis Mode at the same step
6. WHEN the System displays the Help Letter THEN the System SHALL use the currently selected language

### Requirement 4

**User Story:** 作为焦虑症患者，我希望应用支持多种语言，以便在不同国家和地区的用户都能使用地道的表达。

#### Acceptance Criteria

1. WHEN the System initializes THEN the System SHALL detect the device's default language and set it as the initial locale
2. WHEN the User taps the language toggle button THEN the System SHALL switch between available languages
3. WHEN the System changes language THEN the System SHALL update all UI text including: step titles, descriptions, button labels, help letter content, and practice mode text
4. WHEN the System displays text in any language THEN the System SHALL use culturally appropriate and natural expressions
5. WHEN the System supports a language THEN the System SHALL include at least: English, Spanish, French, German, and Chinese (Simplified)
6. WHEN language changes occur THEN the System SHALL persist the user's language preference across app sessions

### Requirement 5

**User Story:** 作为焦虑症患者，我希望能够访问日常练习模块，以便在平时建立心理防线，预防惊恐发作。

#### Acceptance Criteria

1. WHEN the User taps the Practice tab in the bottom navigation THEN the System SHALL display the Practice Mode overlay with a slide-up animation
2. WHEN Practice Mode is displayed THEN the System SHALL show at least 4 practice categories: Deep Breathing, Movement, Self Talk, and Acceptance
3. WHEN the User views a practice card THEN the System SHALL display the practice name, brief description, and reference to handbook chapter
4. WHEN the User taps the close button THEN the System SHALL dismiss the Practice Mode overlay with a slide-down animation
5. WHEN the System displays Practice Mode THEN the System SHALL use the currently selected language for all practice content

### Requirement 6

**User Story:** 作为焦虑症患者，我希望应用界面美观且具有治愈性，以便在使用时感到平静和安全。

#### Acceptance Criteria

1. WHEN the System displays any screen THEN the System SHALL use a calming color palette with navy, aqua, lilac, and cream tones
2. WHEN the System renders the background THEN the System SHALL display a gradient with subtle animated elements
3. WHEN the User interacts with buttons THEN the System SHALL provide visual feedback with scale animations
4. WHEN the System displays the Crisis Mode THEN the System SHALL show a frosted glass effect on the main card
5. WHEN the System displays any animation THEN the System SHALL ensure smooth 60fps performance

### Requirement 7

**User Story:** 作为焦虑症患者，我希望应用能够离线工作，以便在没有网络连接时也能使用。

#### Acceptance Criteria

1. WHEN the System is installed THEN the System SHALL bundle all content including text, images, and animations locally
2. WHEN the User opens the System without internet connection THEN the System SHALL function fully without requiring network access
3. WHEN the System stores user preferences THEN the System SHALL persist data locally on the device
4. WHEN the User changes language settings THEN the System SHALL load language resources from local storage
5. WHEN the System initializes THEN the System SHALL not make any network requests for core functionality

### Requirement 8

**User Story:** 作为焦虑症患者，我希望应用能够记住我的使用状态，以便下次打开时继续之前的进度。

#### Acceptance Criteria

1. WHEN the User exits the System during a crisis step THEN the System SHALL save the current step number
2. WHEN the User reopens the System THEN the System SHALL restore the last active step in Crisis Mode
3. WHEN the User changes language preference THEN the System SHALL persist the selection across app restarts
4. WHEN the System stores state data THEN the System SHALL use secure local storage mechanisms
5. WHEN the User completes all 9 steps and restarts THEN the System SHALL reset to step 1

### Requirement 9

**User Story:** 作为应用开发者，我希望代码结构清晰且易于维护，以便未来能够轻松添加新功能和语言。

#### Acceptance Criteria

1. WHEN the System is implemented THEN the System SHALL separate UI components, business logic, and data models into distinct layers
2. WHEN new language support is added THEN the System SHALL require only adding a new locale file without modifying core code
3. WHEN new practice exercises are added THEN the System SHALL support adding them through configuration data
4. WHEN the System handles animations THEN the System SHALL use reusable animation components
5. WHEN the System manages state THEN the System SHALL use a predictable state management pattern

### Requirement 10

**User Story:** 作为焦虑症患者，我希望应用能够提供触觉反馈，以便在交互时获得更真实的感受。

#### Acceptance Criteria

1. WHEN the User taps any button THEN the System SHALL provide haptic feedback
2. WHEN the User double-taps to show Help Letter THEN the System SHALL provide a distinct haptic pattern
3. WHEN the User transitions between steps THEN the System SHALL provide subtle haptic feedback
4. WHEN the System provides haptic feedback THEN the System SHALL respect the device's haptic settings
5. WHEN haptic feedback is disabled on the device THEN the System SHALL function normally without haptics
