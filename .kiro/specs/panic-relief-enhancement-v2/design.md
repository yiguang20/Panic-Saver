# Design Document - Panic Relief App Enhancement V2.0

## Overview

本设计文档详细描述了 Panic Relief App V2.0 的技术实现方案。基于需求文档中定义的15个主要功能模块，我们将采用模块化、可扩展的架构设计，确保应用的性能、可维护性和用户体验。

核心设计理念：
- **治愈性优先**：所有视觉和交互设计以舒缓、治愈为核心
- **模块化架构**：功能独立、易于测试和维护
- **性能优化**：确保60fps流畅动画和快速响应
- **可定制性**：用户可以根据个人需求调整内容
- **数据驱动**：通过记录帮助用户了解自己的模式

## Architecture

### 整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Screens    │  │   Widgets    │  │  Animations  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Providers   │  │   Services   │  │    Models    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Repositories │  │    Sources   │  │   Storage    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### 层次职责

**Presentation Layer（展示层）**
- Screens: 页面级组件，管理页面状态和导航
- Widgets: 可复用的UI组件
- Animations: 动画控制器和效果

**Domain Layer（领域层）**
- Providers: 状态管理（使用Provider模式）
- Services: 业务逻辑服务
- Models: 数据模型和业务实体

**Data Layer（数据层）**
- Repositories: 数据访问抽象层
- Sources: 具体的数据源（本地存储、文件等）
- Storage: 持久化存储实现

## Components and Interfaces

### 1. 设置菜单系统

#### SettingsScreen
```dart
class SettingsScreen extends StatelessWidget {
  // 主设置页面，显示分类菜单
  // 包含：语言设置、主题设置、呼吸设置、卡片管理、关于
}
```

#### LanguageSettingsScreen
```dart
class LanguageSettingsScreen extends StatelessWidget {
  // 语言选择页面
  // 显示所有支持的语言，当前选中的高亮显示
}
```

#### CardManagementScreen
```dart
class CardManagementScreen extends StatelessWidget {
  // 卡片管理页面
  // 显示所有卡片列表，支持启用/禁用、编辑、重排序
}
```

#### CardEditorScreen
```dart
class CardEditorScreen extends StatefulWidget {
  final CrisisCard card;
  // 卡片编辑器
  // 支持编辑标题、内容、按钮文本等
  // 提供预览功能
}
```

### 2. 按住确认组件

#### HoldToConfirmButton
```dart
class HoldToConfirmButton extends StatefulWidget {
  final String label;
  final VoidCallback onConfirm;
  final Duration holdDuration; // 默认2秒
  final bool showSkipButton;
  
  // 按住确认按钮
  // 显示进度环动画
  // 完成时触发回调和触觉反馈
}
```

#### ProgressRingPainter
```dart
class ProgressRingPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;
  final double strokeWidth;
  
  // 绘制进度环
  // 支持发光效果
}
```

### 3. 解旋动画卡片

#### UnwindingCard
```dart
class UnwindingCard extends StatefulWidget {
  // 解旋卡片主组件
  // 包含解旋动画和倒数功能
}
```

#### UnwindingAnimation
```dart
class UnwindingAnimation extends StatefulWidget {
  final AnimationController controller;
  
  // 解旋动画组件
  // 显示杆子和绳子
  // 绳子从上到下逐渐解开
  // 循环播放
}
```

#### CountdownDisplay
```dart
class CountdownDisplay extends StatefulWidget {
  final int currentNumber; // 100 to 0
  
  // 倒数显示组件
  // 数字变化时使用淡入淡出动画
}
```

### 4. 聆听觉察卡片

#### ListeningCard
```dart
class ListeningCard extends StatefulWidget {
  // 聆听卡片主组件
  // 包含声音波形动画和标记界面
}
```

#### SoundWaveAnimation
```dart
class SoundWaveAnimation extends StatefulWidget {
  // 声音波形动画
  // 显示脉动的波形效果
}
```

#### SoundMarkerList
```dart
class SoundMarkerList extends StatefulWidget {
  final List<String> markedSounds;
  final Function(String) onMarkSound;
  
  // 声音标记列表
  // 显示预定义的声音类别
  // 用户点击标记后显示勾选动画
}
```

### 5. 自我肯定卡片

#### AffirmationCard
```dart
class AffirmationCard extends StatefulWidget {
  final List<String> affirmations;
  
  // 自我肯定卡片
  // 逐个显示肯定语句
  // 引导用户慢慢阅读
}
```

#### AffirmationDisplay
```dart
class AffirmationDisplay extends StatelessWidget {
  final String affirmation;
  
  // 单个肯定语句显示
  // 大字体、强调样式
  // 淡入动画
}
```

### 6. 持续呼吸提醒

#### BreathingReminder
```dart
class BreathingReminder extends StatefulWidget {
  final BreathingSettings settings;
  final bool isExpanded;
  
  // 呼吸提醒组件
  // 显示在卡片底部
  // 包含小型呼吸球动画
  // 可点击展开显示详细说明
}
```

#### MiniBreathingOrb
```dart
class MiniBreathingOrb extends StatefulWidget {
  final BreathingSettings settings;
  final double size; // 小尺寸，如40x40
  
  // 迷你呼吸球
  // 跟随用户自定义节奏动画
}
```

### 7. 日历和记录系统

#### CalendarScreen
```dart
class CalendarScreen extends StatefulWidget {
  // 日历视图页面
  // 显示月历和标记的日期
}
```

#### CalendarView
```dart
class CalendarView extends StatefulWidget {
  final DateTime currentMonth;
  final Map<DateTime, List<SessionRecord>> sessions;
  
  // 日历组件
  // 显示月份、日期网格
  // 标记有记录的日期
}
```

#### SessionDetailSheet
```dart
class SessionDetailSheet extends StatelessWidget {
  final DateTime date;
  final List<SessionRecord> sessions;
  
  // 会话详情底部表单
  // 显示选定日期的所有会话记录
}
```

#### SessionStatistics
```dart
class SessionStatistics extends StatelessWidget {
  final List<SessionRecord> allSessions;
  
  // 统计信息组件
  // 显示总会话数、平均时长、常见时间等
}
```

### 8. 增强的呼吸球

#### EnhancedBreathingOrb
```dart
class EnhancedBreathingOrb extends StatefulWidget {
  final BreathingSettings settings;
  final double size; // 320x320或更大
  
  // 增强版呼吸球
  // 渐变色、发光效果、粒子效果
  // 显示节奏数字
}
```

#### ParticleEffect
```dart
class ParticleEffect extends StatefulWidget {
  final List<Particle> particles;
  
  // 粒子效果
  // 在呼吸球边缘显示
  // 过渡时出现
}
```

### 9. Practice模块增强

#### PracticeDetailScreen
```dart
class PracticeDetailScreen extends StatefulWidget {
  final PracticeItem practice;
  
  // 练习详情页面
  // 显示分步说明
  // 包含动画演示
  // 交互式确认
}
```

#### PracticeAnimationPlayer
```dart
class PracticeAnimationPlayer extends StatefulWidget {
  final String animationType;
  
  // 练习动画播放器
  // 根据类型播放不同的演示动画
}
```

## Data Models

### CrisisCard
```dart
class CrisisCard {
  final String id;
  final String title;
  final String mainText;
  final String subText;
  final String buttonText;
  final CardType type;
  final bool isEnabled;
  final int order;
  final Map<String, dynamic>? customData;
  
  // 危机卡片数据模型
  // 支持自定义内容
}

enum CardType {
  standard,
  breathing,
  unwinding,
  listening,
  affirmation,
  grounding,
}
```

### SessionRecord
```dart
class SessionRecord {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final int stepsCompleted;
  final List<int> completedSteps;
  final Map<String, dynamic>? metadata;
  
  // 会话记录模型
  // 记录每次使用的详细信息
}
```

### BreathingSettings
```dart
class BreathingSettings {
  final double inhaleDuration;
  final double holdDuration;
  final double exhaleDuration;
  
  // 呼吸设置模型（已存在，保持不变）
}
```

### AppSettings
```dart
class AppSettings {
  final String languageCode;
  final ThemeMode themeMode;
  final BreathingSettings breathingSettings;
  final bool hapticsEnabled;
  final bool soundEnabled;
  final bool reducedMotion;
  
  // 应用设置模型
}
```

### AffirmationSet
```dart
class AffirmationSet {
  final String id;
  final String name;
  final List<String> affirmations;
  final bool isDefault;
  
  // 肯定语句集合
  // 支持多个自定义集合
}
```

### SoundCategory
```dart
class SoundCategory {
  final String id;
  final String name;
  final IconData icon;
  
  // 声音类别
  // 用于聆听卡片
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: 按住确认完整性
*For any* hold-to-confirm button, if the user holds for the full duration (2 seconds), then the action should be triggered exactly once with haptic feedback
**Validates: Requirements 3.3, 3.4**

### Property 2: 进度环动画一致性
*For any* progress ring animation, the completion time should match the configured hold duration within 100ms tolerance
**Validates: Requirements 3.2**

### Property 3: 解旋动画循环性
*For any* unwinding animation cycle, after completing one full unwinding sequence, the animation should seamlessly restart with new rope sections
**Validates: Requirements 4.4, 4.5**

### Property 4: 倒数同步性
*For any* countdown display, the number changes should be synchronized with rope unwinding segments within one frame
**Validates: Requirements 4.6**

### Property 5: 声音标记唯一性
*For any* listening card session, each sound category should be markable only once, and marking should display a checkmark animation
**Validates: Requirements 5.4**

### Property 6: 肯定语句顺序性
*For any* affirmation card session, affirmations should be displayed in the configured order, one at a time
**Validates: Requirements 6.4, 6.5**

### Property 7: 呼吸提醒持久性
*For any* crisis card (except the breathing-focused card), the breathing reminder should be visible at the bottom
**Validates: Requirements 7.1, 7.7, 7.8**

### Property 8: 呼吸动画同步性
*For any* breathing reminder and main breathing orb displayed simultaneously, their animations should be synchronized
**Validates: Requirements 7.9**

### Property 9: 会话记录完整性
*For any* completed crisis session, a session record should be created with accurate start time, end time, and steps completed
**Validates: Requirements 8.1**

### Property 10: 日历标记准确性
*For any* date with recorded sessions, the calendar should display a visual indicator on that date
**Validates: Requirements 8.3**

### Property 11: 卡片编辑持久性
*For any* card content modification, the changes should be persisted immediately and reflected in the crisis flow
**Validates: Requirements 9.6**

### Property 12: 卡片禁用跳过性
*For any* disabled card, it should be skipped in the crisis flow sequence
**Validates: Requirements 9.7**

### Property 13: 动画性能保证
*For any* animation, the frame rate should maintain at least 60fps on target devices
**Validates: Requirements 10.12, 13.1**

### Property 14: 呼吸球尺寸一致性
*For any* breathing orb display, the minimum size should be 320x320 pixels
**Validates: Requirements 11.1**

### Property 15: 设置持久化即时性
*For any* setting modification, the change should be persisted to local storage within 100ms
**Validates: Requirements 14.1**

### Property 16: 数据导出完整性
*For any* data export operation, the generated file should include all user settings, custom cards, and session history
**Validates: Requirements 14.7**

### Property 17: 多语言内容覆盖性
*For any* new feature, all text content should have translations in all supported languages
**Validates: Requirements 15.1-15.9**

### Property 18: 跳过按钮可见性
*For any* hold-to-confirm button, a skip button should be visible nearby in a non-intrusive location
**Validates: Requirements 3.7, 3.9**

### Property 19: 卡片大小规范性
*For any* crisis card display, the card should occupy at least 85% of screen width and 70% of visible height
**Validates: Requirements 2.3**

### Property 20: 求助信颜色柔和性
*For any* Help Letter display, no red or aggressive colors should be used
**Validates: Requirements 2.4**

## Error Handling

### 用户输入错误
- **无效的呼吸时长**：显示友好提示，要求输入大于0的数字
- **空的肯定语句**：阻止保存，提示必须输入内容
- **无效的日期选择**：限制日期选择范围，防止未来日期

### 数据持久化错误
- **存储空间不足**：显示警告，建议清理旧数据
- **写入失败**：重试机制，最多3次
- **读取失败**：使用默认值，记录错误日志

### 动画性能问题
- **帧率下降**：自动降低动画复杂度
- **内存不足**：释放不必要的资源
- **设备过热**：暂停非关键动画

### 导入导出错误
- **文件格式错误**：显示详细错误信息
- **数据损坏**：尝试部分恢复，提示用户
- **版本不兼容**：提供迁移方案

## Testing Strategy

### Unit Testing
- 测试所有数据模型的序列化/反序列化
- 测试业务逻辑服务的核心功能
- 测试工具类和辅助函数
- 测试状态管理Provider的状态转换

### Widget Testing
- 测试所有自定义Widget的渲染
- 测试用户交互（点击、滑动、长按）
- 测试动画的开始和结束状态
- 测试条件渲染逻辑

### Integration Testing
- 测试完整的用户流程（从启动到完成会话）
- 测试设置修改的端到端流程
- 测试数据持久化和恢复
- 测试多语言切换

### Property-Based Testing
使用 `test` 包和自定义生成器进行属性测试：

**测试库选择**：Dart的 `test` 包 + 自定义生成器

**配置**：每个属性测试运行至少100次迭代

**标记格式**：`// Feature: panic-relief-enhancement-v2, Property X: [property text]`

#### 关键属性测试

1. **按住确认测试**
   - 生成随机的按住时长
   - 验证只有达到阈值才触发

2. **倒数同步测试**
   - 生成随机的动画进度
   - 验证数字变化与进度匹配

3. **会话记录测试**
   - 生成随机的会话数据
   - 验证存储和检索的一致性

4. **卡片编辑测试**
   - 生成随机的卡片内容
   - 验证保存后能正确恢复

### Performance Testing
- 使用Flutter DevTools监控帧率
- 测试大量数据下的滚动性能
- 测试动画在低端设备上的表现
- 测试内存使用和泄漏

### Accessibility Testing
- 使用屏幕阅读器测试
- 测试不同字体大小设置
- 测试高对比度模式
- 测试减少动画模式

## Implementation Notes

### 技术栈
- **Flutter**: 3.10+
- **Dart**: 3.0+
- **状态管理**: Provider
- **本地存储**: shared_preferences + sqflite
- **动画**: Flutter内置动画系统 + CustomPainter
- **国际化**: flutter_localizations + intl

### 性能优化策略

1. **动画优化**
   - 使用 `RepaintBoundary` 隔离动画区域
   - 使用 `AnimatedBuilder` 而非 `setState`
   - 缓存复杂的 `CustomPainter` 结果

2. **内存优化**
   - 及时释放不用的 `AnimationController`
   - 使用 `ListView.builder` 而非 `ListView`
   - 图片使用适当的分辨率

3. **存储优化**
   - 批量写入而非频繁单次写入
   - 使用索引加速查询
   - 定期清理过期数据

### 可访问性实现

1. **语义标签**
   - 所有交互元素添加 `Semantics` widget
   - 提供清晰的标签和提示

2. **对比度**
   - 确保所有文本符合WCAG AA标准
   - 提供高对比度主题选项

3. **动画控制**
   - 检测 `MediaQuery.of(context).disableAnimations`
   - 提供静态替代方案

### 国际化实现

1. **ARB文件结构**
```
lib/presentation/l10n/
  ├── app_en.arb
  ├── app_zh.arb
  ├── app_es.arb
  ├── app_fr.arb
  └── app_de.arb
```

2. **新增内容**
   - 所有新功能的文本都需要添加到ARB文件
   - 使用描述性的key名称
   - 提供上下文注释

### 数据库Schema

```sql
-- 会话记录表
CREATE TABLE session_records (
  id TEXT PRIMARY KEY,
  start_time INTEGER NOT NULL,
  end_time INTEGER NOT NULL,
  duration INTEGER NOT NULL,
  steps_completed INTEGER NOT NULL,
  completed_steps TEXT NOT NULL, -- JSON array
  metadata TEXT -- JSON object
);

-- 自定义卡片表
CREATE TABLE custom_cards (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  main_text TEXT NOT NULL,
  sub_text TEXT,
  button_text TEXT NOT NULL,
  type TEXT NOT NULL,
  is_enabled INTEGER NOT NULL,
  order_index INTEGER NOT NULL,
  custom_data TEXT -- JSON object
);

-- 肯定语句集合表
CREATE TABLE affirmation_sets (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  affirmations TEXT NOT NULL, -- JSON array
  is_default INTEGER NOT NULL
);
```

## Security Considerations

### 数据加密
- 使用 `flutter_secure_storage` 存储敏感设置
- 会话记录使用SQLCipher加密
- 导出文件可选加密

### 隐私保护
- 不收集任何个人身份信息
- 所有数据仅存储在本地
- 提供完全删除数据的选项
- 符合GDPR和CCPA要求

### 权限管理
- 最小权限原则
- 仅请求必要的权限（存储）
- 清晰说明权限用途

## Deployment Strategy

### 版本发布计划

**V2.0 Alpha**
- 核心功能实现
- 内部测试

**V2.0 Beta**
- 完整功能
- 公开测试
- 收集反馈

**V2.0 Release**
- 修复所有已知问题
- 性能优化
- 正式发布

### 向后兼容
- 检测旧版本数据
- 自动迁移到新格式
- 保留旧版本设置

### 渐进式发布
- 先发布核心改进
- 逐步启用新功能
- 监控性能指标

## Future Enhancements

### 短期（3-6个月）
- 添加更多练习类型
- 支持更多语言
- 优化动画效果

### 中期（6-12个月）
- 云同步功能（可选）
- 社区分享卡片
- AI个性化建议

### 长期（12个月+）
- 可穿戴设备集成
- 语音引导
- VR/AR体验

## Conclusion

本设计文档提供了Panic Relief App V2.0的完整技术实现方案。通过模块化的架构、清晰的组件划分、详细的数据模型和全面的测试策略，我们将能够构建一个高质量、高性能、易维护的应用，为焦虑症患者提供更好的支持和帮助。

所有设计决策都基于需求文档中定义的功能需求，并考虑了性能、可访问性、安全性和未来扩展性。
