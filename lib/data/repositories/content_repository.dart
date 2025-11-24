import 'package:flutter/material.dart';
import '../models/crisis_step.dart';
import '../models/help_letter_content.dart';
import '../models/practice_item.dart';
import '../models/practice_exercise.dart';

/// Repository for providing localized content
class ContentRepository {
  /// Get crisis steps for the given locale
  List<CrisisStep> getCrisisSteps(BuildContext context) {
    // Content is loaded from generated localizations
    // Enhanced flow with new therapeutic cards
    return List.generate(12, (index) {
      final stepNum = index + 1;
      return CrisisStep(
        stepNumber: stepNum,
        iconType: _getIconType(stepNum),
        title: _getStepTitle(context, stepNum),
        text: _getStepText(context, stepNum),
        subText: _getStepSub(context, stepNum),
        buttonText: _getStepBtn(context, stepNum),
        type: _getStepType(stepNum),
      );
    });
  }

  /// Get help letter content for the given locale
  HelpLetterContent getHelpLetter(BuildContext context) {
    // Content loaded from generated localizations
    return HelpLetterContent(
      heading: _getLocalizedString(context, 'helpHeading'),
      subheading: _getLocalizedString(context, 'helpSubheading'),
      paragraph1: _getLocalizedString(context, 'helpP1'),
      paragraph2: _getLocalizedString(context, 'helpP2'),
      paragraph3: _getLocalizedString(context, 'helpP3'),
      paragraph4: _getLocalizedString(context, 'helpP4'),
      paragraph5: _getLocalizedString(context, 'helpP5'),
      backButtonText: _getLocalizedString(context, 'helpBack'),
    );
  }

  /// Get practice items for the given locale
  List<PracticeItem> getPracticeItems(BuildContext context) {
    return [
      PracticeItem(
        id: 'breath',
        iconName: 'wind',
        title: _getLocalizedString(context, 'prac1Title'),
        description: _getLocalizedString(context, 'prac1Desc'),
        chapterReference: 'Ch.4',
      ),
      PracticeItem(
        id: 'movement',
        iconName: 'person_running',
        title: _getLocalizedString(context, 'prac2Title'),
        description: _getLocalizedString(context, 'prac2Desc'),
        chapterReference: 'Ch.5',
      ),
      PracticeItem(
        id: 'self_talk',
        iconName: 'comments',
        title: _getLocalizedString(context, 'prac3Title'),
        description: _getLocalizedString(context, 'prac3Desc'),
        chapterReference: 'Ch.8',
      ),
      PracticeItem(
        id: 'acceptance',
        iconName: 'feather',
        title: _getLocalizedString(context, 'prac4Title'),
        description: _getLocalizedString(context, 'prac4Desc'),
        chapterReference: 'Ch.6',
      ),
      PracticeItem(
        id: 'unwinding',
        iconName: 'autorenew',
        title: _getLocalizedString(context, 'prac5Title'),
        description: _getLocalizedString(context, 'prac5Desc'),
        chapterReference: 'Ch.7',
      ),
      PracticeItem(
        id: 'listening',
        iconName: 'hearing',
        title: _getLocalizedString(context, 'prac6Title'),
        description: _getLocalizedString(context, 'prac6Desc'),
        chapterReference: 'Ch.9',
      ),
      PracticeItem(
        id: 'affirmation',
        iconName: 'favorite',
        title: _getLocalizedString(context, 'prac7Title'),
        description: _getLocalizedString(context, 'prac7Desc'),
        chapterReference: 'Ch.10',
      ),
    ];
  }

  /// Get detailed practice exercise content
  PracticeExercise getPracticeExercise(BuildContext context, String id) {
    final locale = Localizations.localeOf(context).languageCode;
    
    switch (id) {
      case 'breath':
        return _getBreathingExercise(locale);
      case 'movement':
        return _getMovementExercise(locale);
      case 'self_talk':
        return _getSelfTalkExercise(locale);
      case 'acceptance':
        return _getAcceptanceExercise(locale);
      case 'unwinding':
        return _getUnwindingExercise(locale);
      case 'listening':
        return _getListeningExercise(locale);
      case 'affirmation':
        return _getAffirmationExercise(locale);
      default:
        return _getBreathingExercise(locale);
    }
  }

  PracticeExercise _getBreathingExercise(String locale) {
    if (locale == 'zh') {
      return const PracticeExercise(
        id: 'breath',
        title: '腹式呼吸',
        subtitle: '降低生理唤醒的核心技术',
        description: '腹式呼吸是对抗焦虑最基础也最有效的工具。当你焦虑时，呼吸会变浅变快，主要使用胸部呼吸。这会激活交感神经系统，加剧焦虑。腹式呼吸则相反，它能激活副交感神经系统，让身体进入放松状态。',
        steps: [
          '找一个安静的地方，舒服地坐下或躺下',
          '一只手放在胸部，另一只手放在腹部',
          '用鼻子缓慢吸气，数到4，感受腹部隆起（胸部保持相对静止）',
          '屏住呼吸，数到7',
          '用嘴缓慢呼气，数到8，感受腹部下沉',
          '重复这个循环10-15次',
        ],
        benefits: [
          '立即降低心率和血压',
          '减少肌肉紧张',
          '打断焦虑的恶性循环',
          '增加大脑供氧，改善思维清晰度',
          '可以随时随地练习',
        ],
        duration: '10-15分钟',
        frequency: '每天2-3次',
        tips: [
          '刚开始可能会感到头晕，这是正常的，放慢速度即可',
          '不要强迫自己，让呼吸自然流动',
          '在焦虑发作前就开始练习，不要等到危机时刻',
          '可以配合舒缓的音乐',
          '坚持练习2-3周后效果最明显',
        ],
      );
    } else {
      return const PracticeExercise(
        id: 'breath',
        title: 'Abdominal Breathing',
        subtitle: 'Core technique for reducing physiological arousal',
        description: 'Abdominal breathing is the most fundamental and effective tool against anxiety. When anxious, breathing becomes shallow and rapid, primarily using chest breathing. This activates the sympathetic nervous system, intensifying anxiety. Abdominal breathing does the opposite—it activates the parasympathetic nervous system, bringing the body into a relaxed state.',
        steps: [
          'Find a quiet place and sit or lie down comfortably',
          'Place one hand on your chest and the other on your abdomen',
          'Slowly inhale through your nose for a count of 4, feeling your abdomen rise (chest remains relatively still)',
          'Hold your breath for a count of 7',
          'Slowly exhale through your mouth for a count of 8, feeling your abdomen fall',
          'Repeat this cycle 10-15 times',
        ],
        benefits: [
          'Immediately lowers heart rate and blood pressure',
          'Reduces muscle tension',
          'Interrupts the anxiety cycle',
          'Increases oxygen to the brain, improving mental clarity',
          'Can be practiced anytime, anywhere',
        ],
        duration: '10-15 minutes',
        frequency: '2-3 times daily',
        tips: [
          'You may feel dizzy at first—this is normal, just slow down',
          'Don\'t force it, let the breath flow naturally',
          'Practice before anxiety strikes, not just during crisis',
          'Can be combined with calming music',
          'Effects are most noticeable after 2-3 weeks of consistent practice',
        ],
      );
    }
  }

  PracticeExercise _getMovementExercise(String locale) {
    if (locale == 'zh') {
      return const PracticeExercise(
        id: 'movement',
        title: '运动释放',
        subtitle: '消耗过剩的肾上腺素',
        description: '焦虑时，身体会分泌大量肾上腺素准备"战斗或逃跑"。如果这些能量没有被释放，就会转化为持续的紧张感。规律的运动是消耗这些能量、降低基线焦虑水平的最佳方式。',
        steps: [
          '选择你喜欢的运动：快走、慢跑、游泳、骑车、跳舞等',
          '从每次15分钟开始，逐渐增加到30-40分钟',
          '保持中等强度：能说话但不能唱歌',
          '专注于身体的感觉，而不是思绪',
          '运动后做5分钟拉伸放松',
        ],
        benefits: [
          '降低静息心率，提高心血管健康',
          '促进内啡肽分泌，改善情绪',
          '提高睡眠质量',
          '增强自信心和掌控感',
          '长期降低焦虑基线水平',
        ],
        duration: '30-40分钟',
        frequency: '每周4-5次',
        tips: [
          '选择你真正喜欢的运动，这样更容易坚持',
          '不要在睡前2小时内剧烈运动',
          '户外运动效果更好',
          '可以找朋友一起，增加社交支持',
          '即使只是散步10分钟也有帮助',
        ],
      );
    } else {
      return const PracticeExercise(
        id: 'movement',
        title: 'Physical Exercise',
        subtitle: 'Burn off excess adrenaline',
        description: 'During anxiety, the body releases large amounts of adrenaline for "fight or flight." If this energy isn\'t released, it converts into persistent tension. Regular exercise is the best way to burn this energy and lower baseline anxiety levels.',
        steps: [
          'Choose an activity you enjoy: brisk walking, jogging, swimming, cycling, dancing, etc.',
          'Start with 15 minutes per session, gradually increase to 30-40 minutes',
          'Maintain moderate intensity: able to talk but not sing',
          'Focus on bodily sensations, not thoughts',
          'Cool down with 5 minutes of stretching',
        ],
        benefits: [
          'Lowers resting heart rate, improves cardiovascular health',
          'Promotes endorphin release, improves mood',
          'Enhances sleep quality',
          'Builds confidence and sense of control',
          'Long-term reduction in baseline anxiety',
        ],
        duration: '30-40 minutes',
        frequency: '4-5 times per week',
        tips: [
          'Choose activities you genuinely enjoy for better adherence',
          'Avoid vigorous exercise within 2 hours of bedtime',
          'Outdoor exercise is more effective',
          'Exercise with friends for social support',
          'Even a 10-minute walk helps',
        ],
      );
    }
  }

  PracticeExercise _getSelfTalkExercise(String locale) {
    if (locale == 'zh') {
      return const PracticeExercise(
        id: 'self_talk',
        title: '认知重构',
        subtitle: '改变灾难化思维模式',
        description: '焦虑的核心是灾难化思维："我会死""我会发疯""我无法应对"。这些想法不是事实，而是焦虑制造的谎言。认知重构就是学会识别、质疑并替换这些扭曲的想法。',
        steps: [
          '写下让你焦虑的想法（如"我的心脏会停止跳动"）',
          '问自己：有什么证据支持这个想法？',
          '问自己：有什么证据反驳这个想法？',
          '问自己：最坏的情况是什么？我能应对吗？',
          '用更现实的想法替换（如"这只是焦虑，我的心脏很健康"）',
          '大声重复新的想法，直到相信它',
        ],
        benefits: [
          '打破焦虑的认知循环',
          '减少预期性焦虑',
          '提高对身体感觉的耐受度',
          '增强理性思维能力',
          '长期改变思维模式',
        ],
        duration: '15-20分钟',
        frequency: '每天1次，焦虑时随时使用',
        tips: [
          '把常用的应对陈述写在卡片上随身携带',
          '不要期待立即相信新想法，需要反复练习',
          '可以请朋友帮你质疑灾难化想法',
          '记录成功应对的经历作为证据',
          '对自己温柔，改变需要时间',
        ],
      );
    } else {
      return const PracticeExercise(
        id: 'self_talk',
        title: 'Cognitive Restructuring',
        subtitle: 'Transform catastrophic thinking patterns',
        description: 'The core of anxiety is catastrophic thinking: "I\'m going to die," "I\'m going crazy," "I can\'t cope." These thoughts are not facts—they\'re lies created by anxiety. Cognitive restructuring teaches you to identify, challenge, and replace these distorted thoughts.',
        steps: [
          'Write down the anxious thought (e.g., "My heart will stop beating")',
          'Ask yourself: What evidence supports this thought?',
          'Ask yourself: What evidence contradicts this thought?',
          'Ask yourself: What\'s the worst that could happen? Can I cope?',
          'Replace with a more realistic thought (e.g., "This is just anxiety, my heart is healthy")',
          'Repeat the new thought aloud until you believe it',
        ],
        benefits: [
          'Breaks the cognitive cycle of anxiety',
          'Reduces anticipatory anxiety',
          'Increases tolerance for bodily sensations',
          'Strengthens rational thinking',
          'Long-term transformation of thought patterns',
        ],
        duration: '15-20 minutes',
        frequency: 'Once daily, use anytime during anxiety',
        tips: [
          'Write common coping statements on cards to carry with you',
          'Don\'t expect to believe new thoughts immediately—practice is key',
          'Ask a friend to help challenge catastrophic thoughts',
          'Record successful coping experiences as evidence',
          'Be gentle with yourself—change takes time',
        ],
      );
    }
  }

  PracticeExercise _getAcceptanceExercise(String locale) {
    if (locale == 'zh') {
      return const PracticeExercise(
        id: 'acceptance',
        title: '接纳漂浮',
        subtitle: '威克斯博士的核心方法',
        description: '对抗焦虑只会让它更强。接纳漂浮法教你不再与焦虑搏斗，而是像羽毛一样漂浮在焦虑的波浪上。当你停止抵抗，焦虑反而会自然消退。这是克莱尔·威克斯博士提出的革命性方法。',
        steps: [
          '当焦虑来临时，停止对抗的冲动',
          '对自己说："好的，来吧，我接受你"',
          '想象自己是一片羽毛，漂浮在海浪上',
          '观察身体的感觉，不评判，不逃避',
          '提醒自己："这只是感觉，不是危险"',
          '等待焦虑自然消退（通常5-10分钟）',
        ],
        benefits: [
          '减少对焦虑的恐惧（二次恐惧）',
          '打破回避行为的恶性循环',
          '提高对不适感的耐受度',
          '减少惊恐发作的频率和强度',
          '获得真正的内心平静',
        ],
        duration: '5-15分钟',
        frequency: '焦虑时使用',
        tips: [
          '接纳不是喜欢，而是不再抵抗',
          '刚开始会很难，这是正常的',
          '可以配合腹式呼吸使用',
          '记住：焦虑的波峰通常只持续几分钟',
          '每次成功接纳都会让下次更容易',
        ],
      );
    } else {
      return const PracticeExercise(
        id: 'acceptance',
        title: 'Acceptance & Floating',
        subtitle: 'Dr. Weekes\' core method',
        description: 'Fighting anxiety only makes it stronger. The floating technique teaches you to stop battling anxiety and instead float on its waves like a feather. When you stop resisting, anxiety naturally subsides. This is the revolutionary method developed by Dr. Claire Weekes.',
        steps: [
          'When anxiety arrives, resist the urge to fight it',
          'Tell yourself: "Okay, come on, I accept you"',
          'Imagine yourself as a feather floating on ocean waves',
          'Observe bodily sensations without judgment or avoidance',
          'Remind yourself: "This is just a feeling, not danger"',
          'Wait for anxiety to naturally subside (usually 5-10 minutes)',
        ],
        benefits: [
          'Reduces fear of anxiety (secondary fear)',
          'Breaks the vicious cycle of avoidance',
          'Increases tolerance for discomfort',
          'Reduces frequency and intensity of panic attacks',
          'Achieves genuine inner peace',
        ],
        duration: '5-15 minutes',
        frequency: 'Use during anxiety',
        tips: [
          'Acceptance isn\'t liking it—it\'s not resisting it',
          'It will be difficult at first—this is normal',
          'Can be combined with abdominal breathing',
          'Remember: anxiety peaks usually last only minutes',
          'Each successful acceptance makes the next easier',
        ],
      );
    }
  }

  CrisisStepType _getStepType(int stepNum) {
    switch (stepNum) {
      case 3:
        return CrisisStepType.breathing;
      case 5:
        return CrisisStepType.unwinding;
      case 7:
        return CrisisStepType.listening;
      case 9:
        return CrisisStepType.affirmation;
      default:
        return CrisisStepType.standard;
    }
  }

  String _getIconType(int stepNum) {
    switch (stepNum) {
      case 1:
        return 'prep';
      case 2:
        return 'stop';
      case 3:
        return 'breathe';
      case 4:
        return 'ground';
      case 5:
        return 'unwinding';
      case 6:
        return 'talk';
      case 7:
        return 'listening';
      case 8:
        return 'float';
      case 9:
        return 'affirmation';
      case 10:
        return 'compassion';
      case 11:
        return 'wait';
      case 12:
        return 'end';
      default:
        return 'prep';
    }
  }

  String _getStepTitle(BuildContext context, int stepNum) {
    return _getLocalizedString(context, 'step${stepNum}Title');
  }

  String _getStepText(BuildContext context, int stepNum) {
    return _getLocalizedString(context, 'step${stepNum}Text');
  }

  String _getStepSub(BuildContext context, int stepNum) {
    return _getLocalizedString(context, 'step${stepNum}Sub');
  }

  String _getStepBtn(BuildContext context, int stepNum) {
    return _getLocalizedString(context, 'step${stepNum}Btn');
  }

  PracticeExercise _getUnwindingExercise(String locale) {
    if (locale == 'zh') {
      return const PracticeExercise(
        id: 'unwinding',
        title: '解旋放松',
        subtitle: '通过视觉隐喻释放紧张',
        description: '解旋动画是一种强大的视觉隐喻，帮助你释放身体和心理的紧张。看着绳子慢慢解开，想象你的焦虑也在随之消散。',
        steps: [
          '找一个舒适的位置坐下或躺下',
          '专注于屏幕上的解旋动画',
          '想象绳子代表你的紧张和焦虑',
          '随着绳子解开，感受你的身体也在放松',
          '配合深呼吸，让放松更深入',
          '观看完整的100秒倒数',
        ],
        benefits: [
          '提供视觉焦点，转移注意力',
          '通过隐喻帮助理解放松过程',
          '倒数提供时间感和控制感',
          '可以重复观看，强化放松效果',
          '简单易行，随时可用',
        ],
        duration: '2-3分钟',
        frequency: '焦虑时使用，或每天1-2次',
        tips: [
          '不要强迫自己放松，只是观察',
          '可以配合腹式呼吸使用',
          '如果感觉有帮助，可以多看几次',
          '想象绳子是你的焦虑，正在离开你',
        ],
      );
    } else {
      return const PracticeExercise(
        id: 'unwinding',
        title: 'Unwinding Relaxation',
        subtitle: 'Release tension through visual metaphor',
        description: 'The unwinding animation is a powerful visual metaphor to help you release physical and mental tension. Watch the rope slowly unwind and imagine your anxiety dissipating with it.',
        steps: [
          'Find a comfortable position, sitting or lying down',
          'Focus on the unwinding animation on screen',
          'Imagine the rope represents your tension and anxiety',
          'As the rope unwinds, feel your body relaxing too',
          'Combine with deep breathing for deeper relaxation',
          'Watch the complete 100-second countdown',
        ],
        benefits: [
          'Provides visual focus to redirect attention',
          'Uses metaphor to understand the relaxation process',
          'Countdown provides sense of time and control',
          'Can be repeated to reinforce relaxation',
          'Simple and accessible anytime',
        ],
        duration: '2-3 minutes',
        frequency: 'Use during anxiety, or 1-2 times daily',
        tips: [
          'Don\'t force relaxation, just observe',
          'Can be combined with abdominal breathing',
          'If helpful, watch multiple times',
          'Imagine the rope is your anxiety leaving you',
        ],
      );
    }
  }

  PracticeExercise _getListeningExercise(String locale) {
    if (locale == 'zh') {
      return const PracticeExercise(
        id: 'listening',
        title: '聆听觉察',
        subtitle: '通过声音接地到当下',
        description: '聆听觉察是一种感官接地技术，通过专注于周围的声音，帮助你从焦虑的思绪中脱离，回到当下的现实。',
        steps: [
          '找一个相对安静的地方',
          '闭上眼睛或保持柔和的目光',
          '开始注意周围的声音',
          '识别不同类型的声音：人声、自然声、机械声等',
          '不要评判声音，只是观察和标记',
          '持续至少2分钟',
        ],
        benefits: [
          '将注意力从内部转向外部',
          '激活感官，增强现实感',
          '打断焦虑的思维循环',
          '培养正念和觉察能力',
          '可以在任何环境中练习',
        ],
        duration: '2-5分钟',
        frequency: '焦虑时使用，或每天练习',
        tips: [
          '不需要安静的环境，任何声音都可以',
          '如果思绪飘走，温柔地带回到声音上',
          '可以配合深呼吸',
          '标记声音类别可以增强专注',
        ],
      );
    } else {
      return const PracticeExercise(
        id: 'listening',
        title: 'Listening Awareness',
        subtitle: 'Ground yourself through sound',
        description: 'Listening awareness is a sensory grounding technique that helps you disconnect from anxious thoughts and return to present reality by focusing on surrounding sounds.',
        steps: [
          'Find a relatively quiet place',
          'Close your eyes or maintain a soft gaze',
          'Begin noticing sounds around you',
          'Identify different types: voices, nature, mechanical, etc.',
          'Don\'t judge the sounds, just observe and mark them',
          'Continue for at least 2 minutes',
        ],
        benefits: [
          'Shifts attention from internal to external',
          'Activates senses, enhances sense of reality',
          'Interrupts anxious thought cycles',
          'Cultivates mindfulness and awareness',
          'Can be practiced in any environment',
        ],
        duration: '2-5 minutes',
        frequency: 'Use during anxiety, or practice daily',
        tips: [
          'No need for quiet environment, any sound works',
          'If mind wanders, gently return to sounds',
          'Can be combined with deep breathing',
          'Marking sound categories enhances focus',
        ],
      );
    }
  }

  PracticeExercise _getAffirmationExercise(String locale) {
    if (locale == 'zh') {
      return const PracticeExercise(
        id: 'affirmation',
        title: '自我肯定',
        subtitle: '通过积极对话建立安全感',
        description: '自我肯定是一种认知技术，通过重复积极、真实的陈述，帮助你对抗焦虑的灾难化思维，建立内在的安全感和信心。',
        steps: [
          '找一个安静的地方',
          '慢慢阅读每一句肯定语',
          '让每句话深入内心',
          '可以大声重复',
          '感受话语带来的平静',
          '完成所有肯定语',
        ],
        benefits: [
          '对抗灾难化思维',
          '建立内在安全感',
          '增强自我信心',
          '提供情感支持',
          '可以随时使用',
        ],
        duration: '3-5分钟',
        frequency: '焦虑时使用，或每天早晚各一次',
        tips: [
          '不要期待立即相信，需要重复练习',
          '可以选择最有共鸣的语句重复',
          '可以创建自己的肯定语',
          '配合深呼吸效果更好',
        ],
      );
    } else {
      return const PracticeExercise(
        id: 'affirmation',
        title: 'Self-Affirmation',
        subtitle: 'Build safety through positive dialogue',
        description: 'Self-affirmation is a cognitive technique that helps you counter catastrophic thinking and build inner safety and confidence through repeating positive, truthful statements.',
        steps: [
          'Find a quiet place',
          'Read each affirmation slowly',
          'Let each statement sink in',
          'Can repeat aloud',
          'Feel the calm the words bring',
          'Complete all affirmations',
        ],
        benefits: [
          'Counters catastrophic thinking',
          'Builds inner sense of safety',
          'Strengthens self-confidence',
          'Provides emotional support',
          'Can be used anytime',
        ],
        duration: '3-5 minutes',
        frequency: 'Use during anxiety, or morning and evening daily',
        tips: [
          'Don\'t expect immediate belief, needs repeated practice',
          'Can repeat statements that resonate most',
          'Can create your own affirmations',
          'Works better with deep breathing',
        ],
      );
    }
  }

  String _getLocalizedString(BuildContext context, String key) {
    try {
      // Temporary: Return hardcoded strings based on key
      // This will be replaced with actual AppLocalizations when generated
      final Map<String, Map<String, String>> translations = {
      'en': {
        'step1Title': 'Preparation',
        'step1Text': 'If possible, put on your headphones. Find a quiet corner. You are entering a safe space.',
        'step1Sub': 'Create a physical barrier.',
        'step1Btn': "I'm ready",
        'step2Title': 'Stop & Pause',
        'step2Text': 'Stop whatever you are doing. Sit down. Feel the chair supporting you. You are safe.',
        'step2Sub': '"I am uncomfortable, but I am not in danger."',
        'step2Btn': "I've paused",
        'step3Title': 'Breathe with Me',
        'step3Text': 'Focus on the circle. Inhale as it expands. Exhale as it shrinks. Let your belly rise.',
        'step3Sub': '4-7-8 Rhythm',
        'step3Btn': 'Continue',
        'step4Title': 'Grounding',
        'step4Text': 'Look around. Find 3 distinct colors. Name them out loud. Bring your mind back to reality.',
        'step4Sub': 'You are here, right now.',
        'step4Btn': 'I see them',
        'step5Title': 'Unwinding',
        'step5Text': 'Watch the rope unwind. Count down with it. Feel your tension releasing.',
        'step5Sub': 'Let go of what you cannot control.',
        'step5Btn': 'Continue',
        'step6Title': 'Truth Talk',
        'step6Text': 'Your heart is racing because of adrenaline. It\'s a false alarm from your body.',
        'step6Sub': '"This feeling will pass in minutes."',
        'step6Btn': 'I understand',
        'step7Title': 'Listening',
        'step7Text': 'Close your eyes. Listen to the sounds around you. Ground yourself in reality.',
        'step7Sub': 'You are safe in this moment.',
        'step7Btn': 'Continue',
        'step8Title': 'Floating',
        'step8Text': 'Don\'t fight the feeling. Imagine you are a feather floating on a wave. Let the wave carry you.',
        'step8Sub': 'Acceptance dissolves the tension.',
        'step8Btn': 'I am floating',
        'step9Title': 'Affirmation',
        'step9Text': 'Read these words slowly. Let them sink in. Believe in your strength.',
        'step9Sub': 'You are capable and safe.',
        'step9Btn': 'Continue',
        'step10Title': 'Be Gentle',
        'step10Text': 'Don\'t blame yourself. You are handling this difficult moment with great courage.',
        'step10Sub': '"I love and accept myself."',
        'step10Btn': 'I am trying',
        'step11Title': 'Waiting',
        'step11Text': 'The peak is over. Let time pass. Do not rush to feel \'normal\' immediately.',
        'step11Sub': 'Patience is key.',
        'step11Btn': 'Waiting...',
        'step12Title': 'Return',
        'step12Text': 'You have ridden the wave. You are strong. Take a sip of water when you are ready.',
        'step12Sub': 'Welcome back.',
        'step12Btn': 'Start Over',
        // Help Letter
        'helpHeading': 'I Need Help',
        'helpSubheading': 'PLEASE READ THIS',
        'helpP1': 'I am having a Panic Attack. I cannot speak clearly right now.',
        'helpP2': 'I am NOT dying.',
        'helpP3': 'I am NOT dangerous.',
        'helpP4': 'Please do not call an ambulance unless I ask.',
        'helpP5': 'Please just sit with me calmly until my breathing slows down. Thank you for your kindness.',
        'helpBack': 'Back to Guide',
        // Practice Items
        'prac1Title': 'Deep Breath',
        'prac1Desc': 'Abdominal breathing ',
        'prac2Title': 'Movement',
        'prac2Desc': 'Release energy ',
        'prac3Title': 'Self Talk',
        'prac3Desc': 'Positive logic ',
        'prac4Title': 'Acceptance',
        'prac4Desc': 'Floating technique ',
        'prac5Title': 'Unwinding',
        'prac5Desc': 'Visual relaxation ',
        'prac6Title': 'Listening',
        'prac6Desc': 'Sound awareness ',
        'prac7Title': 'Affirmation',
        'prac7Desc': 'Positive self-talk ',
      },
      'zh': {
        'step1Title': '准备',
        'step1Text': '如果可以，请戴上耳机。或者找一个相对安静的角落。这里只有你和当下。',
        'step1Sub': '建立物理屏障，创造安全感。',
        'step1Btn': '准备好了',
        'step2Title': '立刻停下',
        'step2Text': '停下你手里的动作。坐下来。你是安全的。这种感觉很强烈，但它没有危险。',
        'step2Sub': '"这只是身体的误报。"',
        'step2Btn': '暂停中',
        'step3Title': '跟随呼吸',
        'step3Text': '看着上方的光球。随着它变大吸气，随着它变小呼气。把气吸到肚子里。',
        'step3Sub': '呼气要比吸气长。',
        'step3Btn': '继续',
        'step4Title': '着地技术',
        'step4Text': '看看周围。找出 3 个蓝色的东西。大声说出它们的名字。感受双脚踩在地面的实感。',
        'step4Sub': '你就在这里，现实世界很安全。',
        'step4Btn': '我找到了',
        'step5Title': '解旋放松',
        'step5Text': '看着绳子慢慢解开。跟着倒数。感受你的紧张也在释放。',
        'step5Sub': '放下你无法控制的。',
        'step5Btn': '继续',
        'step6Title': '自我对话',
        'step6Text': '心跳快只是因为肾上腺素。你不会死，也不会发疯。这只是暂时的生理反应。',
        'step6Sub': '"我以前经历过，每次都平安度过了。"',
        'step6Btn': '我相信',
        'step7Title': '聆听觉察',
        'step7Text': '闭上眼睛。聆听周围的声音。让自己回到现实。',
        'step7Sub': '此刻你是安全的。',
        'step7Btn': '继续',
        'step8Title': '漂浮',
        'step8Text': '不要对抗这种感觉。对抗只会增加焦虑。像羽毛一样漂浮在海浪上，任由它起伏。',
        'step8Sub': '面对，接受，漂浮，等待。',
        'step8Btn': '正在漂浮',
        'step9Title': '自我肯定',
        'step9Text': '慢慢阅读这些话。让它们深入内心。相信你的力量。',
        'step9Sub': '你有能力，你很安全。',
        'step9Btn': '继续',
        'step10Title': '自我关怀',
        'step10Text': '你做得很好。不要责怪自己。你正在勇敢地面对困难。',
        'step10Sub': '对自己温柔一点。',
        'step10Btn': '感受中',
        'step11Title': '等待消退',
        'step11Text': '风暴正在减弱。给自己一点时间。不要急着立刻好起来。',
        'step11Sub': '让时间治愈一切。',
        'step11Btn': '等待中...',
        'step12Title': '回归',
        'step12Text': '你战胜了这次海浪。你很坚强。喝口水，准备好后再回到生活中。',
        'step12Sub': '欢迎回来。',
        'step12Btn': '重新开始',
        // Help Letter
        'helpHeading': '我需要帮助',
        'helpSubheading': '请阅读这段话',
        'helpP1': '我正在经历惊恐发作（焦虑症）。我现在很难说话。',
        'helpP2': '我没有生命危险。',
        'helpP3': '我不会伤害任何人。',
        'helpP4': '除非我主动要求，请不要叫救护车。',
        'helpP5': '请只是陪我安静地坐一会儿，直到我的呼吸平稳。谢谢您的善良。',
        'helpBack': '返回引导',
        // Practice Items
        'prac1Title': '深呼吸',
        'prac1Desc': '腹式呼吸法 ',
        'prac2Title': '运动释放',
        'prac2Desc': '消耗多余能量 ',
        'prac3Title': '自我对话',
        'prac3Desc': '改变灾难化思维 ',
        'prac4Title': '接纳漂浮',
        'prac4Desc': '威克斯漂浮法 ',
        'prac5Title': '解旋放松',
        'prac5Desc': '视觉放松 ',
        'prac6Title': '聆听觉察',
        'prac6Desc': '声音觉察 ',
        'prac7Title': '自我肯定',
        'prac7Desc': '积极对话 ',
      },
    };

      // Get current locale from context (simplified)
      final locale = Localizations.localeOf(context).languageCode;
      final langMap = translations[locale] ?? translations['en']!;
      return langMap[key] ?? key;
    } catch (e) {
      // Fallback to key if any error occurs
      return key;
    }
  }
}
