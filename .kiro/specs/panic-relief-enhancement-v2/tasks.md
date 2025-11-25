# Implementation Plan - Panic Relief App Enhancement V2.0

## Phase 1: 基础架构和核心改进

- [x] 1. 重构颜色系统和主题



- [x] 1.1 更新 AppColors 类，添加新的配色方案


  - 添加柔和的渐变色
  - 移除或替换红色系
  - 添加温暖的中性色
  - _Requirements: 2.1, 2.2, 2.4_

- [x] 1.2 创建增强的主题配置


  - 定义新的文本样式
  - 定义新的阴影和模糊效果
  - 定义卡片样式常量
  - _Requirements: 2.3, 2.5, 2.6_

- [ ]* 1.3 编写颜色系统单元测试
  - 测试颜色值的正确性
  - 测试对比度符合WCAG AA标准
  - _Requirements: 2.7, 13.4_

- [x] 2. 重构设置菜单系统




- [x] 2.1 创建新的 SettingsScreen 主页面

  - 显示分类菜单项
  - 使用图标和标签
  - 添加导航功能
  - _Requirements: 1.1, 1.2, 1.6_


- [x] 2.2 创建 LanguageSettingsScreen

  - 显示所有支持的语言
  - 高亮当前选中语言
  - 实现语言切换
  - _Requirements: 1.3, 1.4_


- [x] 2.3 从主页面移除语言切换按钮

  - 更新 HomeScreen
  - 移除语言切换UI
  - 保留设置按钮
  - _Requirements: 1.5_

- [ ]* 2.4 编写设置菜单单元测试
  - 测试导航逻辑
  - 测试语言切换
  - _Requirements: 1.1-1.7_

- [x] 3. 实现按住确认机制




- [x] 3.1 创建 HoldToConfirmButton 组件

  - 实现长按检测
  - 添加2秒计时器
  - 触发回调和触觉反馈
  - _Requirements: 3.1, 3.3, 3.4_


- [x] 3.2 创建 ProgressRingPainter

  - 绘制圆形进度环
  - 实现发光效果
  - 支持动画更新
  - _Requirements: 3.2, 3.5_



- [x] 3.3 添加跳过按钮

  - 设计跳过按钮UI
  - 实现即时触发
  - 定位在合理位置
  - _Requirements: 3.7, 3.8, 3.9_


- [x] 3.4 集成到危机卡片

  - 替换现有的 ElevatedButton
  - 应用到所有步骤转换
  - _Requirements: 3.10_

- [ ]* 3.5 编写按住确认属性测试
  - **Property 1: 按住确认完整性**
  - **Validates: Requirements 3.3, 3.4**

- [ ]* 3.6 编写进度环属性测试
  - **Property 2: 进度环动画一致性**
  - **Validates: Requirements 3.2**

- [x] 4. Checkpoint - 确保所有测试通过

- Ensure all tests pass, ask the user if questions arise.

## Phase 2: 新卡片功能实现

- [x] 5. 实现解旋动画和倒数卡片








- [x] 5.1 创建 UnwindingCard 组件


  - 设计卡片布局
  - 集成动画和倒数
  - 添加呼吸提醒
  - _Requirements: 4.1, 4.12_


- [x] 5.2 实现 UnwindingAnimation


  - 绘制杆子和绳子
  - 实现解旋动画逻辑
  - 实现循环播放
  - _Requirements: 4.2, 4.3, 4.4, 4.5_



- [x] 5.3 实现 CountdownDisplay


  - 显示100到0的倒数
  - 实现淡入淡出动画
  - 同步绳子解开
  - _Requirements: 4.6, 4.7_




- [x] 5.4 优化动画性能


  - 使用 RepaintBoundary
  - 确保60fps
  - _Requirements: 4.11_

- [ ]* 5.5 编写解旋动画属性测试
  - **Property 3: 解旋动画循环性**
  - **Validates: Requirements 4.4, 4.5**

- [ ]* 5.6 编写倒数同步属性测试
  - **Property 4: 倒数同步性**
  - **Validates: Requirements 4.6**

- [x] 6. 实现聆听觉察卡片








- [x] 6.1 创建 ListeningCard 组件



  - 设计卡片布局
  - 添加说明文本
  - 集成动画和标记界面
  - _Requirements: 5.1, 5.9_

- [x] 6.2 实现 SoundWaveAnimation

  - 绘制声音波形
  - 实现脉动动画
  - 同步计时器
  - _Requirements: 5.2, 5.10_

- [x] 6.3 实现 SoundMarkerList

  - 显示声音类别
  - 实现标记功能
  - 添加勾选动画
  - _Requirements: 5.3, 5.4, 5.5_

- [x] 6.4 添加计时器和完成逻辑

  - 显示经过时间
  - 2分钟后启用继续按钮
  - 提供正面反馈
  - _Requirements: 5.6, 5.7, 5.8_

- [ ]* 6.5 编写声音标记属性测试
  - **Property 5: 声音标记唯一性**
  - **Validates: Requirements 5.4**

- [x] 7. 实现自我肯定卡片


- [x] 7.1 创建 AffirmationCard 组件


  - 设计卡片布局
  - 实现语句切换逻辑
  - 添加呼吸提醒
  - _Requirements: 6.1, 6.8_

- [x] 7.2 实现 AffirmationDisplay

  - 大字体显示
  - 淡入动画
  - 强调样式
  - _Requirements: 6.3, 6.7_

- [x] 7.3 添加默认肯定语句

  - 中文版本
  - 英文版本
  - 其他语言版本
  - _Requirements: 6.2_

- [x] 7.4 实现阅读引导

  - 下一步按钮
  - 完成消息
  - _Requirements: 6.4, 6.5, 6.6_

- [ ]* 7.5 编写肯定语句属性测试
  - **Property 6: 肯定语句顺序性**
  - **Validates: Requirements 6.4, 6.5**

- [x] 8. Checkpoint - 确保所有测试通过

- Ensure all tests pass, ask the user if questions arise.

## Phase 3: 持续呼吸提醒和增强呼吸球

- [x] 9. 实现持续呼吸提醒系统


- [x] 9.1 创建 BreathingReminder 组件


  - 设计底部提醒UI
  - 实现展开/收起功能
  - 添加详细说明
  - _Requirements: 7.1, 7.4, 7.5_

- [x] 9.2 创建 MiniBreathingOrb


  - 小尺寸呼吸球（40x40）
  - 跟随自定义节奏
  - 柔和的动画
  - _Requirements: 7.2, 7.3_

- [x] 9.3 集成到所有危机卡片

  - 添加到卡片底部
  - 在呼吸卡片中隐藏
  - 保持可见性
  - _Requirements: 7.6, 7.7, 7.8_

- [x] 9.4 实现动画同步

  - 同步主呼吸球
  - 使用相同节奏
  - _Requirements: 7.9_

- [ ]* 9.5 编写呼吸提醒属性测试
  - **Property 7: 呼吸提醒持久性**
  - **Validates: Requirements 7.1, 7.7, 7.8**

- [ ]* 9.6 编写动画同步属性测试
  - **Property 8: 呼吸动画同步性**
  - **Validates: Requirements 7.9**

- [x] 10. 增强呼吸球设计


- [x] 10.1 更新 EnhancedBreathingOrb


  - 增大到320x320
  - 添加渐变色
  - 添加发光效果
  - _Requirements: 11.1, 11.2, 11.3_

- [x] 10.2 实现粒子效果

  - 创建 ParticleEffect 组件
  - 边缘粒子动画
  - 过渡时显示
  - _Requirements: 11.5_

- [x] 10.3 优化视觉效果

  - 显示节奏数字
  - 添加背景元素
  - 抗锯齿处理
  - _Requirements: 11.4, 11.7, 11.8_

- [x] 10.4 优化动画曲线

  - 自然的缓动函数
  - 有机的运动感
  - _Requirements: 11.9, 11.10_

- [ ]* 10.5 编写呼吸球尺寸属性测试
  - **Property 14: 呼吸球尺寸一致性**
  - **Validates: Requirements 11.1**

- [x] 11. Checkpoint - 确保所有测试通过


- Ensure all tests pass, ask the user if questions arise.

## Phase 4: 记录和日历功能

- [x] 12. 实现数据模型和存储




- [x] 12.1 创建 SessionRecord 模型


  - 定义数据结构
  - 实现序列化
  - 实现反序列化
  - _Requirements: 8.1_


- [x] 12.2 创建数据库Schema

  - 设计 session_records 表
  - 添加索引
  - 实现迁移
  - _Requirements: 8.7_


- [x] 12.3 实现 SessionRepository

  - 保存会话记录
  - 查询会话记录
  - 删除会话记录
  - _Requirements: 8.1, 8.7_

- [ ]* 12.4 编写会话记录属性测试
  - **Property 9: 会话记录完整性**
  - **Validates: Requirements 8.1**

- [x] 13. 实现日历视图



- [x] 13.1 创建 CalendarScreen

  - 设计页面布局
  - 添加导航
  - 集成日历组件
  - _Requirements: 8.2, 8.11_


- [x] 13.2 实现 CalendarView

  - 显示月历
  - 标记有记录的日期
  - 月份导航
  - _Requirements: 8.2, 8.3, 8.8_


- [x] 13.3 实现 SessionDetailSheet

  - 显示会话详情
  - 格式化时间和时长
  - 显示完成步骤
  - _Requirements: 8.4_


- [x] 13.4 实现 SessionStatistics

  - 计算总会话数
  - 计算平均时长
  - 分析常见时间
  - _Requirements: 8.6_


- [x] 13.5 优化日历UI设计

  - 美观的视觉设计
  - 柔和的配色
  - 流畅的动画
  - _Requirements: 8.5, 8.8, 8.9_

- [ ]* 13.6 编写日历标记属性测试
  - **Property 10: 日历标记准确性**
  - **Validates: Requirements 8.3**

- [x] 14. 实现数据导出功能



- [x] 14.1 实现导出功能

  - 生成JSON文件
  - 包含所有数据
  - _Requirements: 8.10_


- [ ] 14.2 实现导入功能
  - 解析JSON文件
  - 验证数据格式
  - 恢复数据
  - _Requirements: 14.8_

- [ ]* 14.3 编写数据导出属性测试
  - **Property 16: 数据导出完整性**
  - **Validates: Requirements 14.7**

- [x] 15. Checkpoint - 确保所有测试通过


- Ensure all tests pass, ask the user if questions arise.

## Phase 5: 卡片管理系统

- [x] 16. 实现卡片数据模型



- [x] 16.1 更新 CrisisCard 模型

  - 添加自定义字段
  - 支持启用/禁用
  - 支持排序
  - _Requirements: 9.2, 9.7, 9.8_


- [x] 16.2 创建数据库Schema

  - 设计 custom_cards 表
  - 设计 affirmation_sets 表
  - _Requirements: 9.6_

- [x] 16.3 实现 CardRepository


  - CRUD操作
  - 排序功能
  - _Requirements: 9.6, 9.8_

- [x] 17. 实现卡片管理界面

- [x] 17.1 创建 CardManagementScreen


  - 显示卡片列表
  - 显示状态
  - 添加操作按钮
  - _Requirements: 9.1, 9.2_


- [x] 17.2 创建 CardEditorScreen

  - 编辑表单
  - 实时预览
  - 保存功能
  - _Requirements: 9.3, 9.4, 9.9_


- [x] 17.3 实现拖拽排序
  - 拖拽手势
  - 视觉反馈
  - 保存顺序
  - _Requirements: 9.8_

- [x] 17.4 实现肯定语句编辑

  - 添加/删除语句
  - 重排序
  - _Requirements: 9.5, 6.9_


- [x] 17.5 实现重置功能
  - 恢复默认内容
  - 确认对话框
  - _Requirements: 9.10_


- [x] 17.6 实现验证逻辑
  - 必填字段检查
  - 保存提示
  - _Requirements: 9.11, 9.12_

- [ ]* 17.7 编写卡片编辑属性测试
  - **Property 11: 卡片编辑持久性**
  - **Validates: Requirements 9.6**

- [ ]* 17.8 编写卡片禁用属性测试
  - **Property 12: 卡片禁用跳过性**
  - **Validates: Requirements 9.7**

- [x] 18. Checkpoint - 确保所有测试通过



- Ensure all tests pass, ask the user if questions arise.

## Phase 6: Practice模块增强

- [x] 19. 增强Practice详情页面




- [x] 19.1 查看 PracticeDetailScreen

  - 设计详情页面布局
  - 分步说明
  - 导航控制
  - _Requirements: 12.1_


- [x] 19.2 实现 PracticeAnimationPlayer

  - 根据类型播放动画
  - 呼吸动画
  - 着地动画
  - 其他练习动画
  - _Requirements: 12.2, 12.4_


- [x] 19.3 添加交互式元素

  - 确认按钮
  - 进度指示
  - _Requirements: 12.3_


- [x] 19.4 实现反馈系统
  - 触觉反馈
  - 音频反馈（可选）
  - 视觉反馈
  - _Requirements: 12.5_

- [ ]* 19.5 添加语音指导（可选）
  - 录制语音
  - 播放控制
  - 设置开关
  - _Requirements: 12.6_


- [x] 19.6 集成呼吸球


  - 实时引导
  - 同步动画
  - _Requirements: 12.7_


- [x] 19.7 实现着地练习
  - 交互式提示
  - 物体识别
  - _Requirements: 12.8_

- [x] 19.8 记录练习会话

  - 保存到日历
  - 统计数据
  - _Requirements: 12.9_


- [x] 19.9 添加手册引用

  - 章节链接
  - 参考信息
  - _Requirements: 12.10_

- [ ]* 19.10 编写Practice模块集成测试
  - 测试完整练习流程
  - 测试记录功能
  - _Requirements: 12.1-12.11_

- [x] 20. Checkpoint - 确保所有测试通过


- Ensure all tests pass, ask the user if questions arise.

## Phase 7: 性能优化和可访问性

- [x] 21. 性能优化




- [x] 21.1 优化动画性能

  - 使用 RepaintBoundary
  - 优化 CustomPainter
  - 缓存计算结果
  - _Requirements: 13.1, 10.12_



- [x] 21.2 优化加载性能

  - 添加加载状态
  - 优化初始化
  - _Requirements: 13.2, 13.9_




- [x] 21.3 优化内存使用

  - 及时释放资源
  - 使用 ListView.builder
  - 优化图片
  - _Requirements: 13.8_

- [ ]* 21.4 编写性能测试
  - **Property 13: 动画性能保证**
  - **Validates: Requirements 10.12, 13.1**

- [x] 22. 可访问性实现



- [x] 22.1 添加语义标签

  - 所有交互元素
  - 清晰的描述
  - _Requirements: 13.7_

- [x] 22.2 确保对比度


  - 检查所有文本
  - WCAG AA标准
  - _Requirements: 13.4_

- [x] 22.3 支持动态字体

  - 响应系统设置
  - 测试不同大小
  - _Requirements: 13.3_


- [x] 22.4 支持减少动画
  - 检测系统设置
  - 提供静态替代
  - _Requirements: 13.6, 10.13_

- [x] 22.5 支持触觉设置
  - 尊重系统设置
  - 提供开关
  - _Requirements: 13.5_

- [ ]* 22.6 编写可访问性测试
  - 测试屏幕阅读器
  - 测试对比度
  - 测试字体缩放
  - _Requirements: 13.3-13.7_

- [x] 23. Checkpoint - 确保所有测试通过



- Ensure all tests pass, ask the user if questions arise.

## Phase 8: 国际化和本地化

- [x] 24. 完善多语言支持


- [x] 24.1 更新ARB文件

  - 添加所有新文本
  - 解旋卡片文本
  - 聆听卡片文本
  - 肯定语句文本
  - 设置菜单文本
  - _Requirements: 15.1, 15.2, 15.3, 15.6_


- [x] 24.2 翻译日历相关文本
  - 日期格式
  - 月份名称
  - 统计文本
  - _Requirements: 15.4_


- [x] 24.3 翻译设置菜单
  - 类别名称
  - 选项文本
  - 错误消息
  - _Requirements: 15.5, 15.7_


- [x] 24.4 翻译提示和工具提示
  - 所有提示文本
  - 帮助信息
  - _Requirements: 15.9_

- [x] 24.5 支持自定义内容多语言

  - 允许多语言输入
  - 存储语言标记
  - _Requirements: 15.8_

- [x] 24.6 确保新功能完全翻译

  - 检查所有新功能
  - 补充缺失翻译
  - _Requirements: 15.10_

- [ ]* 24.7 编写多语言覆盖属性测试
  - **Property 17: 多语言内容覆盖性**
  - **Validates: Requirements 15.1-15.9**


- [ ] 25. Checkpoint - 确保所有测试通过
- Ensure all tests pass, ask the user if questions arise.

## Phase 9: 数据持久化和安全

- [x] 26. 实现数据持久化


- [x] 26.1 实现设置持久化

  - 即时保存
  - 加密敏感数据
  - _Requirements: 14.1, 14.4_


- [x] 26.2 实现会话记录持久化
  - 保存时间戳
  - 保存元数据
  - _Requirements: 14.2_


- [x] 26.3 实现卡片内容持久化
  - 安全存储
  - 版本控制
  - _Requirements: 14.3, 14.4_

- [ ]* 26.4 编写设置持久化属性测试
  - **Property 15: 设置持久化即时性**
  - **Validates: Requirements 14.1**

- [x] 27. 实现备份和恢复



- [x] 27.1 实现备份功能
  - 包含所有数据
  - 生成备份文件
  - _Requirements: 14.6, 14.7_


- [x] 27.2 实现恢复功能
  - 验证备份文件
  - 恢复数据
  - _Requirements: 14.5, 14.8_


- [x] 27.3 实现数据删除
  - 确认对话框
  - 永久删除
  - _Requirements: 14.10_


- [x] 27.4 确保隐私合规
  - GDPR合规
  - CCPA合规
  - _Requirements: 14.9_


- [ ] 28. Checkpoint - 确保所有测试通过
- Ensure all tests pass, ask the user if questions arise.

## Phase 10: 集成和最终测试


- [x] 29. 集成所有功能

- [x] 29.1 更新危机流程

  - 集成新卡片
  - 更新导航
  - 测试完整流程
  - _Requirements: All_


- [x] 29.2 更新主页面
  - 集成新UI
  - 更新导航
  - _Requirements: 2.3_


- [x] 29.3 更新设置页面
  - 集成所有设置
  - 测试所有功能
  - _Requirements: 1.1-1.7_

- [x] 29.4 测试卡片大小
  - 验证85%宽度
  - 验证70%高度
  - _Requirements: 2.3_

- [ ]* 29.5 编写卡片大小属性测试
  - **Property 19: 卡片大小规范性**
  - **Validates: Requirements 2.3**

- [ ]* 29.6 编写求助信颜色属性测试
  - **Property 20: 求助信颜色柔和性**
  - **Validates: Requirements 2.4**

- [x] 30. 端到端测试


- [x] 30.1 测试完整用户流程

  - 从启动到完成会话
  - 测试所有新功能
  - _Requirements: All_

- [x] 30.2 测试边缘情况

  - 空数据
  - 大量数据
  - 网络断开
  - _Requirements: All_

- [x] 30.3 性能测试

  - 测试低端设备
  - 测试动画流畅度
  - 测试内存使用
  - _Requirements: 13.1, 13.8, 13.9_

- [x] 30.4 可访问性测试

  - 屏幕阅读器测试
  - 不同字体大小测试
  - 减少动画测试
  - _Requirements: 13.3-13.7_


- [x] 31. 最终Checkpoint - 确保所有测试通过

- Ensure all tests pass, ask the user if questions arise.

## Phase 11: 文档和发布准备

- [ ] 32. 更新文档


- [ ] 32.1 更新README
  - 新功能说明
  - 使用指南
  - 截图更新

- [ ] 32.2 更新用户指南
  - 新功能教程
  - 常见问题

- [ ] 32.3 更新开发文档
  - 架构说明
  - API文档
  - 贡献指南

- [ ] 33. 发布准备
- [ ] 33.1 版本号更新
  - 更新到2.0.0
  - 更新changelog

- [ ] 33.2 构建测试
  - Android构建
  - iOS构建（如果支持）
  - 测试安装

- [ ] 33.3 准备发布说明
  - 新功能列表
  - 改进说明
  - 已知问题

- [ ] 34. 最终审查
- 完成所有任务，准备发布！
