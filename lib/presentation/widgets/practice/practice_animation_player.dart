import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/colors.dart';
import '../breathing/enhanced_breathing_orb.dart';

/// Animation player for different practice types
/// Supports breathing, grounding, muscle relaxation, and mindfulness animations
class PracticeAnimationPlayer extends StatefulWidget {
  final String practiceType;
  final int currentStep;
  final VoidCallback? onStepComplete;

  const PracticeAnimationPlayer({
    super.key,
    required this.practiceType,
    this.currentStep = 0,
    this.onStepComplete,
  });

  @override
  State<PracticeAnimationPlayer> createState() => _PracticeAnimationPlayerState();
}

class _PracticeAnimationPlayerState extends State<PracticeAnimationPlayer>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _waveController;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.practiceType) {
      case 'breathing':
        return _buildBreathingAnimation();
      case 'grounding':
        return _buildGroundingAnimation();
      case 'muscle_relaxation':
        return _buildMuscleRelaxationAnimation();
      case 'mindfulness':
        return _buildMindfulnessAnimation();
      case 'positive_self_talk':
        return _buildPositiveTalkAnimation();
      case 'listening':
        return _buildListeningAnimation();
      default:
        return _buildDefaultAnimation();
    }
  }

  Widget _buildBreathingAnimation() {
    return const Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: EnhancedBreathingOrb(
          inhaleSeconds: 4,
          holdSeconds: 7,
          exhaleSeconds: 8,
          showRhythm: true,
        ),
      ),
    );
  }


  Widget _buildGroundingAnimation() {
    // 5-4-3-2-1 grounding technique visualization
    final senses = [
      {'icon': Icons.visibility, 'count': 5, 'label': _getSenseLabel(context, 'see')},
      {'icon': Icons.touch_app, 'count': 4, 'label': _getSenseLabel(context, 'touch')},
      {'icon': Icons.hearing, 'count': 3, 'label': _getSenseLabel(context, 'hear')},
      {'icon': Icons.air, 'count': 2, 'label': _getSenseLabel(context, 'smell')},
      {'icon': Icons.restaurant, 'count': 1, 'label': _getSenseLabel(context, 'taste')},
    ];

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Current sense indicator
              if (widget.currentStep < senses.length) ...[
                _buildSenseIndicator(
                  senses[widget.currentStep]['icon'] as IconData,
                  senses[widget.currentStep]['count'] as int,
                  senses[widget.currentStep]['label'] as String,
                  isActive: true,
                ),
                const SizedBox(height: 24),
              ],
              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final isCompleted = index < widget.currentStep;
                  final isCurrent = index == widget.currentStep;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: isCurrent ? 16 : 12,
                    height: isCurrent ? 16 : 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.aqua
                          : isCurrent
                              ? AppColors.aqua.withValues(alpha: 0.5 + _pulseController.value * 0.5)
                              : AppColors.cardBorder.withValues(alpha: 0.3),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: AppColors.aqua.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSenseIndicator(IconData icon, int count, String label, {bool isActive = false}) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = isActive ? 1.0 + _pulseController.value * 0.1 : 1.0;
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.mintGreen.withValues(alpha: 0.3),
                  AppColors.mintGreen.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: AppColors.mintGreen.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.mintGreen, size: 48),
                const SizedBox(height: 12),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMuscleRelaxationAnimation() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final isTensing = _pulseController.value < 0.5;
        final intensity = isTensing 
            ? _pulseController.value * 2 
            : (1 - (_pulseController.value - 0.5) * 2);
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Body visualization
              Container(
                width: 120 + (intensity * 30),
                height: 180 + (intensity * 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isTensing
                        ? [
                            AppColors.warning.withValues(alpha: 0.3 + intensity * 0.3),
                            AppColors.warning.withValues(alpha: 0.2),
                          ]
                        : [
                            AppColors.aqua.withValues(alpha: 0.3 + intensity * 0.3),
                            AppColors.aqua.withValues(alpha: 0.2),
                          ],
                  ),
                  border: Border.all(
                    color: isTensing ? AppColors.warning : AppColors.aqua,
                    width: 2 + intensity * 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isTensing ? Icons.fitness_center : Icons.self_improvement,
                    color: isTensing ? AppColors.warning : AppColors.aqua,
                    size: 48 + intensity * 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isTensing ? _getTenseText(context) : _getRelaxText(context),
                style: TextStyle(
                  color: isTensing ? AppColors.warning : AppColors.aqua,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildMindfulnessAnimation() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _rotateController]),
      builder: (context, child) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating ring
              Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.lilac.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: CustomPaint(
                    painter: _MindfulnessRingPainter(
                      progress: _rotateController.value,
                      color: AppColors.lilac,
                    ),
                  ),
                ),
              ),
              // Inner pulsing orb
              Container(
                width: 120 + (_pulseController.value * 30),
                height: 120 + (_pulseController.value * 30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.lilac.withValues(alpha: 0.4),
                      AppColors.lilac.withValues(alpha: 0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lilac.withValues(alpha: 0.2 + _pulseController.value * 0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.self_improvement,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPositiveTalkAnimation() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.lavender.withValues(alpha: 0.3 + _pulseController.value * 0.2),
                  AppColors.lavender.withValues(alpha: 0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lavender.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.favorite,
              color: AppColors.lavender,
              size: 64 + (_pulseController.value * 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListeningAnimation() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Center(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: _SoundWavePainter(
              progress: _waveController.value,
              color: AppColors.softBlue,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultAnimation() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Center(
          child: Container(
            width: 150 + (_pulseController.value * 30),
            height: 150 + (_pulseController.value * 30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.softBlue.withValues(alpha: 0.3),
                  AppColors.softBlue.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: AppColors.softBlue.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.psychology,
                color: AppColors.softBlue,
                size: 60,
              ),
            ),
          ),
        );
      },
    );
  }

  // Localization helpers
  String _getSenseLabel(BuildContext context, String sense) {
    final locale = Localizations.localeOf(context).languageCode;
    final labels = {
      'en': {'see': 'things to see', 'touch': 'things to touch', 'hear': 'things to hear', 'smell': 'things to smell', 'taste': 'thing to taste'},
      'zh': {'see': '看到的事物', 'touch': '触摸的事物', 'hear': '听到的声音', 'smell': '闻到的气味', 'taste': '尝到的味道'},
    };
    return labels[locale]?[sense] ?? labels['en']![sense]!;
  }

  String _getTenseText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '紧张肌肉' : 'Tense muscles';
  }

  String _getRelaxText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '放松' : 'Relax';
  }
}


/// Custom painter for mindfulness ring animation
class _MindfulnessRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _MindfulnessRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Draw dots around the circle
    const dotCount = 12;
    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * math.pi - math.pi / 2;
      final dotProgress = ((progress * dotCount) - i).clamp(0.0, 1.0);
      final dotRadius = 4.0 + dotProgress * 4.0;
      final dotOpacity = 0.3 + dotProgress * 0.7;
      
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      final paint = Paint()
        ..color = color.withValues(alpha: dotOpacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MindfulnessRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Custom painter for sound wave animation
class _SoundWavePainter extends CustomPainter {
  final double progress;
  final Color color;

  _SoundWavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw concentric circles expanding outward
    for (int i = 0; i < 4; i++) {
      final waveProgress = (progress + i * 0.25) % 1.0;
      final radius = 20 + waveProgress * 80;
      final opacity = (1 - waveProgress) * 0.6;
      
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawCircle(center, radius, paint);
    }
    
    // Draw center icon background
    final centerPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 30, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _SoundWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
