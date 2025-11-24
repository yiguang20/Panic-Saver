# Requirements Document - Panic Relief App Enhancement V2.0

## Introduction

本文档定义了 Panic Relief App 的第二版重大增强需求。基于用户反馈和实际使用体验，我们将对应用进行全面升级，包括：改进的语言切换机制、增强的视觉设计、创新的交互动画、新的治疗技术（解旋动画、倒数功能、聆听卡片）、记录功能、内容管理系统，以及贯穿始终的呼吸提示。这些改进旨在提供更加沉浸、治愈和有效的用户体验。

## Glossary

- **System**: Panic Relief App 移动应用系统
- **User**: 焦虑症患者或有惊恐发作经历的用户
- **Settings Menu**: 设置菜单，包含多个子页面的配置中心
- **Hold-to-Confirm**: 按住确认机制，需要用户按住按钮2秒才能触发
- **Unwinding Animation**: 解旋动画，展示绳子从杆子上解开的视觉隐喻
- **Countdown Card**: 倒数卡片，引导用户从100倒数到0
- **Listening Card**: 聆听卡片，引导用户觉察周围声音
- **Affirmation Card**: 自我肯定卡片，包含积极的自我对话语句
- **Calendar View**: 日历视图，用于记录和查看使用历史
- **Card Management**: 卡片管理系统，允许用户自定义卡片内容
- **Breathing Reminder**: 呼吸提醒，在所有卡片中持续提示正确呼吸
- **Progress Ring**: 进度环，围绕按钮的圆形倒计时动画
- **Skip Button**: 跳过按钮，允许用户快速跳过当前步骤

## Requirements

### Requirement 1: 改进的设置菜单系统

**User Story:** 作为用户，我希望有一个结构化的设置菜单，以便能够方便地管理语言、主题、内容和其他配置。

#### Acceptance Criteria

1. WHEN the User taps the settings icon THEN the System SHALL display a settings screen with categorized menu items
2. WHEN the System displays the settings menu THEN the System SHALL include at least the following categories: Language Settings, Theme Settings, Breathing Settings, Card Management, and About
3. WHEN the User selects Language Settings THEN the System SHALL display all available languages with the current selection highlighted
4. WHEN the User selects a language THEN the System SHALL apply it immediately and persist the choice
5. WHEN the System displays the settings menu THEN the System SHALL remove the language toggle button from the main header
6. WHEN the User navigates to any settings sub-page THEN the System SHALL provide a back button to return to the main settings menu
7. WHEN the System displays settings categories THEN the System SHALL use clear icons and labels for each category

### Requirement 2: 增强的视觉设计和配色方案

**User Story:** 作为用户，我希望应用具有更丰富的视觉层次和更舒缓的配色，以便在使用时感到更加放松和舒适。

#### Acceptance Criteria

1. WHEN the System displays any screen THEN the System SHALL use an expanded color palette including soft gradients and subtle textures
2. WHEN the System displays the background THEN the System SHALL use multi-layer gradients with gentle color transitions
3. WHEN the System displays crisis cards THEN the System SHALL increase card size to occupy at least 85% of the screen width and 70% of the visible height
4. WHEN the System displays the Help Letter THEN the System SHALL use warm, calming colors without any red or aggressive tones
5. WHEN the System displays dialog boxes THEN the System SHALL use frosted glass effects with soft shadows
6. WHEN the System renders any card THEN the System SHALL apply subtle background patterns or textures for visual interest
7. WHEN the System displays text THEN the System SHALL ensure sufficient contrast while maintaining a soft, non-harsh appearance
8. WHEN the System uses colors THEN the System SHALL follow a therapeutic color psychology approach with blues, purples, soft greens, and warm neutrals

### Requirement 3: 按住确认交互机制

**User Story:** 作为用户，我希望在确认进入下一步时有一个明确的过程，以便避免误触并增加仪式感。

#### Acceptance Criteria

1. WHEN the User presses and holds the action button THEN the System SHALL display a circular progress ring animation around the button
2. WHEN the progress ring animation starts THEN the System SHALL complete the full circle in exactly 2 seconds
3. WHEN the User holds the button for the full 2 seconds THEN the System SHALL trigger the action and provide haptic feedback
4. WHEN the User releases the button before 2 seconds THEN the System SHALL cancel the action and reset the progress ring
5. WHEN the progress ring animates THEN the System SHALL use a glowing effect that increases in intensity
6. WHEN the action is triggered THEN the System SHALL display a brief "completion" animation with a light burst effect
7. WHEN the System displays the hold-to-confirm button THEN the System SHALL show a small skip button nearby
8. WHEN the User taps the skip button THEN the System SHALL immediately trigger the action without the hold delay
9. WHEN the skip button is displayed THEN the System SHALL position it in a non-intrusive location with subtle styling
10. WHEN the System uses hold-to-confirm THEN the System SHALL apply it to all step transition buttons in Crisis Mode

### Requirement 4: 解旋动画和倒数卡片

**User Story:** 作为用户，我希望有一个解旋动画配合倒数功能，以便通过视觉隐喻帮助我释放焦虑情绪。

#### Acceptance Criteria

1. WHEN the System displays the unwinding card THEN the System SHALL show a vertical pole with tightly wound rope at the top
2. WHEN the unwinding animation plays THEN the System SHALL display the rope gradually unwinding from top to bottom
3. WHEN one section of rope unwinds THEN the System SHALL move the pole downward and reveal new wound sections
4. WHEN the System displays the unwinding animation THEN the System SHALL loop continuously, creating an endless unwinding effect
5. WHEN the User is on the unwinding card THEN the System SHALL display numbers from 100 to 0 in descending order
6. WHEN the countdown progresses THEN the System SHALL synchronize number changes with rope unwinding segments
7. WHEN each number changes THEN the System SHALL use a fade-out and fade-in animation
8. WHEN the countdown reaches 0 THEN the System SHALL display a completion message and allow progression to the next step
9. WHEN the User views the unwinding animation THEN the System SHALL use calming colors for the rope (soft blues and purples)
10. WHEN the System renders the pole THEN the System SHALL use a neutral, grounding color (warm gray or wood tone)
11. WHEN the unwinding animation plays THEN the System SHALL maintain smooth 60fps performance
12. WHEN the User interacts with the unwinding card THEN the System SHALL display a breathing reminder at the bottom

### Requirement 5: 聆听觉察卡片

**User Story:** 作为用户，我希望有一个聆听卡片引导我觉察周围的声音，以便通过感官接地技术缓解焦虑。

#### Acceptance Criteria

1. WHEN the System displays the listening card THEN the System SHALL show instructions to listen to surrounding sounds
2. WHEN the listening card is active THEN the System SHALL display animated sound wave visualizations
3. WHEN the User identifies a sound THEN the System SHALL provide an interface to mark or tag the sound
4. WHEN the User marks a sound THEN the System SHALL display it in a list with a checkmark animation
5. WHEN the System displays sound markers THEN the System SHALL use at least 5 pre-defined sound categories: voices, nature, mechanical, music, and ambient
6. WHEN the User completes marking sounds THEN the System SHALL provide positive reinforcement feedback
7. WHEN the listening card is displayed THEN the System SHALL include a timer showing elapsed time
8. WHEN the User spends at least 2 minutes on the listening card THEN the System SHALL enable the continue button
9. WHEN the System displays the listening card THEN the System SHALL show a breathing reminder at the bottom
10. WHEN sound wave animations play THEN the System SHALL use gentle, pulsing motions synchronized with a calm rhythm

### Requirement 6: 自我肯定卡片

**User Story:** 作为用户，我希望有自我肯定语句的卡片，以便通过积极的自我对话建立安全感。

#### Acceptance Criteria

1. WHEN the System displays the affirmation card THEN the System SHALL show at least 5 affirmation statements
2. WHEN the System displays affirmations THEN the System SHALL include statements such as: "我很安全", "这不算什么", "都是我身体的一种反应", "它的生物电能释放完毕后，我就会自然回归", "我会静静等待，陪伴在身体左右，等待它风平浪静"
3. WHEN the User views an affirmation THEN the System SHALL display it in large, readable text with emphasis
4. WHEN the affirmation card is active THEN the System SHALL guide the User to read each statement slowly
5. WHEN the User finishes reading an affirmation THEN the System SHALL provide a "next" button to proceed to the next statement
6. WHEN all affirmations are read THEN the System SHALL display a completion message
7. WHEN the System displays affirmations THEN the System SHALL use a gentle fade-in animation for each statement
8. WHEN the User is on the affirmation card THEN the System SHALL display a breathing reminder at the bottom
9. WHEN the System stores affirmations THEN the System SHALL allow customization through the Card Management settings
10. WHEN the User customizes affirmations THEN the System SHALL persist the changes across sessions

### Requirement 7: 持续呼吸提醒系统

**User Story:** 作为用户，我希望在所有卡片中都能看到呼吸提醒，以便始终保持正确的腹式呼吸。

#### Acceptance Criteria

1. WHEN the System displays any crisis card THEN the System SHALL show a breathing reminder indicator at the bottom of the screen
2. WHEN the breathing reminder is displayed THEN the System SHALL include a small animated breathing orb
3. WHEN the breathing orb animates THEN the System SHALL follow the user's custom breathing rhythm or the default 4-7-8 pattern
4. WHEN the User taps the breathing reminder THEN the System SHALL expand to show detailed breathing instructions
5. WHEN detailed breathing instructions are shown THEN the System SHALL include text: "保持腹式呼吸" or "Maintain abdominal breathing"
6. WHEN the breathing reminder is displayed THEN the System SHALL use subtle, non-distracting styling
7. WHEN the System transitions between cards THEN the System SHALL maintain the breathing reminder visibility
8. WHEN the User is on the breathing-focused card (Step 3) THEN the System SHALL hide the bottom reminder to avoid redundancy
9. WHEN the breathing reminder animates THEN the System SHALL synchronize with the main breathing orb if both are visible
10. WHEN the System displays the breathing reminder THEN the System SHALL use calming colors (aqua and lilac)

### Requirement 8: 使用记录和日历功能

**User Story:** 作为用户，我希望能够记录我的使用历史，以便追踪我的进展和识别模式。

#### Acceptance Criteria

1. WHEN the User completes a full crisis session THEN the System SHALL automatically record the date, time, and duration
2. WHEN the User accesses the calendar view THEN the System SHALL display a monthly calendar with marked dates
3. WHEN a date has recorded sessions THEN the System SHALL display a visual indicator (dot or color) on that date
4. WHEN the User taps a marked date THEN the System SHALL show session details including: start time, duration, and steps completed
5. WHEN the System displays the calendar THEN the System SHALL use a beautiful, minimalist design with soft colors
6. WHEN the User views session history THEN the System SHALL display statistics such as: total sessions, average duration, and most common time of day
7. WHEN the System records a session THEN the System SHALL store data locally and securely
8. WHEN the User views the calendar THEN the System SHALL allow navigation between months with smooth animations
9. WHEN the System displays session markers THEN the System SHALL use different colors or sizes to indicate session length or completion
10. WHEN the User accesses the calendar THEN the System SHALL provide an option to export data or view trends over time
11. WHEN the System displays the calendar view THEN the System SHALL ensure it is accessible from the settings menu

### Requirement 9: 卡片内容管理系统

**User Story:** 作为用户，我希望能够管理卡片内容，以便自定义我的治疗体验。

#### Acceptance Criteria

1. WHEN the User accesses Card Management in settings THEN the System SHALL display a list of all available cards
2. WHEN the System displays the card list THEN the System SHALL show each card's title, type, and current status (enabled/disabled)
3. WHEN the User taps a card in the list THEN the System SHALL open an edit interface for that card
4. WHEN the User edits a card THEN the System SHALL allow modification of: title, main text, sub-text, and button label
5. WHEN the User edits affirmation cards THEN the System SHALL allow adding, removing, or reordering affirmation statements
6. WHEN the User saves card changes THEN the System SHALL persist the modifications and apply them immediately
7. WHEN the User disables a card THEN the System SHALL skip it in the crisis flow sequence
8. WHEN the User reorders cards THEN the System SHALL allow drag-and-drop or up/down buttons to change sequence
9. WHEN the System displays the card editor THEN the System SHALL provide a preview of how the card will appear
10. WHEN the User makes changes THEN the System SHALL provide a reset button to restore default content
11. WHEN the System saves card content THEN the System SHALL validate that required fields are not empty
12. WHEN the User exits the card editor THEN the System SHALL prompt to save if there are unsaved changes

### Requirement 10: 增强的动画和交互效果

**User Story:** 作为用户，我希望应用具有丰富的动画和交互效果，以便获得更加沉浸和治愈的体验。

#### Acceptance Criteria

1. WHEN the System displays the breathing orb THEN the System SHALL use smooth, organic scaling animations
2. WHEN the breathing orb expands THEN the System SHALL apply a subtle glow effect that intensifies
3. WHEN the breathing orb contracts THEN the System SHALL reduce opacity slightly to create depth
4. WHEN the User transitions between cards THEN the System SHALL use 3D flip or slide animations
5. WHEN the System displays practice cards THEN the System SHALL use staggered fade-in animations for each card
6. WHEN the User taps a practice card THEN the System SHALL expand it with a smooth scale and position animation
7. WHEN the System displays progress indicators THEN the System SHALL animate transitions between steps
8. WHEN a step is completed THEN the System SHALL display a celebratory micro-animation (sparkles or ripple)
9. WHEN the System displays the unwinding animation THEN the System SHALL use physics-based motion for rope movement
10. WHEN the User interacts with any button THEN the System SHALL provide immediate visual feedback with scale and color changes
11. WHEN the System displays the listening card THEN the System SHALL show animated sound waves that respond to the timer
12. WHEN animations play THEN the System SHALL maintain 60fps performance on target devices
13. WHEN the System uses animations THEN the System SHALL respect the device's reduced motion accessibility settings

### Requirement 11: 改进的呼吸球设计

**User Story:** 作为用户，我希望呼吸球更加精美和引人注目，以便更容易跟随呼吸节奏。

#### Acceptance Criteria

1. WHEN the System displays the breathing orb THEN the System SHALL render it at a minimum size of 320x320 pixels
2. WHEN the breathing orb animates THEN the System SHALL use gradient colors that shift between aqua and lilac
3. WHEN the breathing orb is at full expansion THEN the System SHALL display a soft, diffused glow effect
4. WHEN the breathing orb displays the rhythm THEN the System SHALL show the timing (e.g., "4-7-8") in the center
5. WHEN the breathing orb animates THEN the System SHALL include particle effects around the edges during transitions
6. WHEN the User customizes breathing rhythm THEN the System SHALL update the orb animation in real-time
7. WHEN the breathing orb is displayed THEN the System SHALL include subtle background elements that enhance depth
8. WHEN the System renders the breathing orb THEN the System SHALL use anti-aliasing for smooth edges
9. WHEN the breathing orb transitions between phases THEN the System SHALL use easing curves that feel natural and organic
10. WHEN the User views the breathing orb THEN the System SHALL ensure it remains the focal point with appropriate contrast

### Requirement 12: Practice模块增强

**User Story:** 作为用户，我希望Practice模块具有更强的互动性和引导性，以便更有效地学习和练习技巧。

#### Acceptance Criteria

1. WHEN the User taps a practice card THEN the System SHALL open a detailed practice screen with step-by-step instructions
2. WHEN the practice screen is displayed THEN the System SHALL include animated demonstrations of the technique
3. WHEN the User follows a practice THEN the System SHALL provide interactive elements to confirm understanding
4. WHEN the System displays practice animations THEN the System SHALL use clear, simple visuals that illustrate the concept
5. WHEN the User completes a practice step THEN the System SHALL provide positive audio or haptic feedback
6. WHEN the System guides a practice THEN the System SHALL include voice-over instructions (optional, can be enabled in settings)
7. WHEN the User practices breathing THEN the System SHALL display the breathing orb with real-time guidance
8. WHEN the User practices grounding THEN the System SHALL provide interactive prompts to identify objects or sensations
9. WHEN the User completes a practice session THEN the System SHALL record it in the calendar
10. WHEN the System displays practice content THEN the System SHALL include references to the source handbook chapter
11. WHEN the User accesses practice mode THEN the System SHALL show recommended practices based on time of day or usage patterns

### Requirement 13: 性能和可访问性

**User Story:** 作为用户，我希望应用运行流畅且易于访问，以便在任何情况下都能有效使用。

#### Acceptance Criteria

1. WHEN the System renders any animation THEN the System SHALL maintain at least 60fps on target devices
2. WHEN the System loads content THEN the System SHALL display loading states with progress indicators
3. WHEN the System displays text THEN the System SHALL support dynamic font sizing based on device accessibility settings
4. WHEN the System uses colors THEN the System SHALL ensure WCAG AA contrast ratios for all text
5. WHEN the System provides haptic feedback THEN the System SHALL respect device haptic settings
6. WHEN the System plays animations THEN the System SHALL respect reduced motion accessibility preferences
7. WHEN the User navigates the app THEN the System SHALL support screen reader announcements for all interactive elements
8. WHEN the System stores data THEN the System SHALL optimize for minimal storage footprint
9. WHEN the System initializes THEN the System SHALL load within 2 seconds on target devices
10. WHEN the System runs in the background THEN the System SHALL minimize battery consumption

### Requirement 14: 数据持久化和同步

**User Story:** 作为用户，我希望我的设置和记录能够安全保存，以便在重新安装或更换设备时不会丢失。

#### Acceptance Criteria

1. WHEN the User modifies any setting THEN the System SHALL persist the change immediately to local storage
2. WHEN the User records a session THEN the System SHALL save it with timestamp and metadata
3. WHEN the User customizes card content THEN the System SHALL store the modifications securely
4. WHEN the System stores data THEN the System SHALL use encrypted storage for sensitive information
5. WHEN the User reinstalls the app THEN the System SHALL provide an option to restore from backup
6. WHEN the System backs up data THEN the System SHALL include: settings, custom cards, session history, and preferences
7. WHEN the User exports data THEN the System SHALL generate a JSON file with all user data
8. WHEN the User imports data THEN the System SHALL validate the file format and restore settings
9. WHEN the System handles data THEN the System SHALL comply with privacy regulations (GDPR, CCPA)
10. WHEN the User deletes data THEN the System SHALL provide confirmation and permanently remove the information

### Requirement 15: 多语言内容完整性

**User Story:** 作为用户，我希望所有新功能都完全支持多语言，以便无论使用哪种语言都能获得完整体验。

#### Acceptance Criteria

1. WHEN the System displays the unwinding card THEN the System SHALL show instructions in the selected language
2. WHEN the System displays the listening card THEN the System SHALL show sound categories in the selected language
3. WHEN the System displays affirmation statements THEN the System SHALL show culturally appropriate translations
4. WHEN the System displays the calendar view THEN the System SHALL use localized date formats and month names
5. WHEN the System displays settings menu THEN the System SHALL translate all category names and options
6. WHEN the System displays the breathing reminder THEN the System SHALL show text in the selected language
7. WHEN the System provides error messages THEN the System SHALL display them in the selected language
8. WHEN the User customizes card content THEN the System SHALL allow input in any supported language
9. WHEN the System displays tooltips or hints THEN the System SHALL translate them appropriately
10. WHEN the System adds new languages THEN the System SHALL ensure all new features are fully translated

## Summary

This requirements document defines a comprehensive enhancement to the Panic Relief App, focusing on improved user experience, richer visual design, innovative therapeutic techniques, and robust functionality. The enhancements maintain the app's core mission of providing immediate crisis support while adding depth, customization, and long-term tracking capabilities. All requirements are designed to be testable, implementable, and aligned with therapeutic best practices for anxiety management.
