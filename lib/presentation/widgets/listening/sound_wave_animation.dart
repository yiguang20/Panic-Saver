import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/colors.dart';

/// Animated sound wave visualization
class SoundWaveAnimation extends StatefulWidget {
  final bool isActive;

  const SoundWaveAnimation({
    super.key,
    required this.isActive,
  });

  @override
  State<SoundWaveAnimation> createState() => _SoundWaveAnimationState();
}

class _SoundWaveAnimationState extends State<SoundWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
            size: const Size(double.infinity, 100),
            painter: SoundWavePainter(
              progress: _controller.value,
              isActive: widget.isActive,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for sound waves
class SoundWavePainter extends CustomPainter {
  final double progress;
  final bool isActive;

  SoundWavePainter({
    required this.progress,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final waveCount = 5;
    
    for (int i = 0; i < waveCount; i++) {
      _drawWave(
        canvas,
        size,
        centerY,
        i,
        waveCount,
      );
    }
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double centerY,
    int index,
    int total,
  ) {
    final paint = Paint()
      ..color = _getWaveColor(index, total)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final amplitude = isActive ? 20.0 + (index * 5) : 10.0;
    final frequency = 0.02 + (index * 0.005);
    final phase = progress * 2 * math.pi + (index * math.pi / total);

    path.moveTo(0, centerY);

    for (double x = 0; x <= size.width; x += 2) {
      final y = centerY + math.sin(x * frequency + phase) * amplitude;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  Color _getWaveColor(int index, int total) {
    final colors = [
      AppColors.aqua,
      AppColors.softBlue,
      AppColors.lilac,
      AppColors.deepPurple,
      AppColors.mintGreen,
    ];
    
    final alpha = isActive ? 0.8 - (index * 0.15) : 0.3 - (index * 0.05);
    return colors[index % colors.length].withValues(alpha: alpha);
  }

  @override
  bool shouldRepaint(SoundWavePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isActive != isActive;
  }
}
