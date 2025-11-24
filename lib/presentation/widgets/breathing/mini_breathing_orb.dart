import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Mini breathing orb (40x40) for persistent breathing reminder
/// Follows custom breathing rhythm with gentle animation
class MiniBreathingOrb extends StatefulWidget {
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;

  const MiniBreathingOrb({
    super.key,
    this.inhaleSeconds = 4,
    this.holdSeconds = 7,
    this.exhaleSeconds = 8,
  });

  @override
  State<MiniBreathingOrb> createState() => _MiniBreathingOrbState();
}

class _MiniBreathingOrbState extends State<MiniBreathingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    
    final totalDuration = widget.inhaleSeconds + 
                         widget.holdSeconds + 
                         widget.exhaleSeconds;
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalDuration),
    )..repeat();

    _setupAnimation();
  }

  void _setupAnimation() {
    _sizeAnimation = TweenSequence<double>([
      // Inhale - expand
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: widget.inhaleSeconds.toDouble(),
      ),
      // Hold - stay expanded
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: widget.holdSeconds.toDouble(),
      ),
      // Exhale - contract
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.5)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: widget.exhaleSeconds.toDouble(),
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(40, 40),
            painter: MiniOrbPainter(
              progress: _controller.value,
              size: _sizeAnimation.value,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for mini breathing orb
class MiniOrbPainter extends CustomPainter {
  final double progress;
  final double size;

  MiniOrbPainter({
    required this.progress,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final baseRadius = canvasSize.width * 0.3;
    final radius = baseRadius * size;

    // Gradient colors
    final gradient = RadialGradient(
      colors: [
        AppColors.aqua.withValues(alpha: 0.8),
        AppColors.softBlue.withValues(alpha: 0.6),
        AppColors.lilac.withValues(alpha: 0.3),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    // Main orb
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    // Glow effect
    final glowPaint = Paint()
      ..color = AppColors.aqua.withValues(alpha: 0.2 * size)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(center, radius * 1.2, glowPaint);

    // Outer ring
    final ringPaint = Paint()
      ..color = AppColors.aqua.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, radius * 1.1, ringPaint);
  }

  @override
  bool shouldRepaint(MiniOrbPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.size != size;
  }
}
