import 'dart:math' as math;
import 'package:flutter/material.dart';

class UnwindingAnimation extends StatefulWidget {
  final AnimationController controller;
  final Color? ropeColor;
  final Color? stickColor;

  const UnwindingAnimation({
    super.key,
    required this.controller,
    this.ropeColor,
    this.stickColor,
  });

  @override
  State<UnwindingAnimation> createState() => _UnwindingAnimationState();
}

class _UnwindingAnimationState extends State<UnwindingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([widget.controller, _rotationController]),
        builder: (context, child) {
          return CustomPaint(
            size: const Size(300, 600),
            painter: TightRopePainter(
              unwindProgress: widget.controller.value,
              rotationValue: _rotationController.value,
              colorA: widget.ropeColor ?? const Color(0xFF00E5FF),
              colorB: widget.stickColor ?? const Color(0xFFD500F9),
            ),
          );
        },
      ),
    );
  }
}

class TightRopePainter extends CustomPainter {
  final double unwindProgress;
  final double rotationValue;
  final Color colorA;
  final Color colorB;

  // --- 配置区域 ---
  static const int particleCount = 100;
  static const double verticalSpacing = 5.0;
  static const double baseRadius = 30.0;
  static const double waveFrequency = 0.45;

  TightRopePainter({
    required this.unwindProgress,
    required this.rotationValue,
    required this.colorA,
    required this.colorB,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final ropeHeight = particleCount * verticalSpacing;
    final startY = size.height - (size.height - ropeHeight) / 2;

    List<_RopeParticle> particles = [];

    for (int i = 0; i < particleCount; i++) {
      final double indexRatio = i / particleCount;

      // 1. 计算解开阈值
      // 线性一点，让解开的过程均匀
      final double activeHeightLimit = 1.0 - unwindProgress;

      // 判断状态
      bool isReleased = indexRatio > activeHeightLimit;

      // unravelFactor: 0.0 (绳子上) -> 很大 (飞远)
      double unravelFactor = 0.0;
      if (isReleased) {
        // 计算脱离程度
        unravelFactor = (indexRatio - activeHeightLimit) * 2.5;
      }

      // --- 透明度控制 ---
      // 粒子飞出一段距离后彻底消失，防止堆积
      double particleAlpha = (1.0 - unravelFactor * 0.8).clamp(0.0, 1.0);
      if (particleAlpha <= 0.001) continue;

      // --- 物理位置计算 ---

      // A. 基础 Y 坐标
      final double yBase = startY - (i * verticalSpacing);

      // B. 旋转计算 (仅用于未解开部分和 Z轴深度)
      final double baseAngle =
          (i * waveFrequency) + (rotationValue * math.pi * 2);

      // 原始螺旋位置 (Bound State)
      double rotXA = centerX + math.sin(baseAngle) * baseRadius;
      double rotXB = centerX + math.sin(baseAngle + math.pi) * baseRadius;

      // 深度 (Z) 始终保持旋转感，这样飞出的粒子也有大小变化，看起来立体
      double zA = math.cos(baseAngle);
      double zB = math.cos(baseAngle + math.pi);

      // --- 核心修正：强制直线逸散 ---

      // C. 直线飞行位置 (Straight Flight State)
      // 设定为：从绳子边缘(Radius)处开始，直接向外延伸
      // 这里的 180.0 是向左右扩散的力度
      double straightXA =
          centerX - baseRadius - (unravelFactor * 180.0); // 左股强制往左
      double straightXB =
          centerX + baseRadius + (unravelFactor * 180.0); // 右股强制往右

      // D. 向上升腾
      double straightY = yBase - (unravelFactor * 250.0);

      // --- E. 状态切换 (Transition) ---

      double finalXA, finalXB, finalY;

      if (!isReleased) {
        // 1. 未解开：严格贴合螺旋
        finalXA = rotXA;
        finalXB = rotXB;
        finalY = yBase;
      } else {
        // 2. 已解开：
        // 我们需要一个极短的过渡，防止粒子瞬间瞬移 (Snap)
        // 这个 transition 因子在解开的头 10% 距离内，从 0 变到 1
        // 作用是将旋转的粒子快速"拉平"到直线轨迹上
        double transition = (unravelFactor * 10.0).clamp(0.0, 1.0);

        // 使用 lerp 快速修正位置
        finalXA = _lerp(rotXA, straightXA, transition);
        finalXB = _lerp(rotXB, straightXB, transition);
        finalY = _lerp(yBase, straightY, transition);

        // 飞出后，Z轴深度逐渐归零(变平)，不再有前后遮挡
        zA = _lerp(zA, 0.0, transition);
        zB = _lerp(zB, 0.0, transition);
      }

      // 连接线：一旦解开，瞬间消失
      double connectionAlpha = (1.0 - unravelFactor * 20.0).clamp(0.0, 1.0);

      // --- 添加粒子 ---

      if (connectionAlpha > 0.0) {
        particles.add(
          _RopeParticle(
            type: _ParticleType.connection,
            x: finalXA,
            y: finalY,
            z: zA,
            x2: finalXB,
            y2: finalY,
            opacity: connectionAlpha * 0.6,
            color: Colors.white,
          ),
        );
      }

      particles.add(
        _RopeParticle(
          type: _ParticleType.dot,
          x: finalXA,
          y: finalY,
          z: zA,
          color: colorA,
          opacity: particleAlpha,
          scale: 0.8,
        ),
      );

      particles.add(
        _RopeParticle(
          type: _ParticleType.dot,
          x: finalXB,
          y: finalY,
          z: zB,
          color: colorB,
          opacity: particleAlpha,
          scale: 0.8,
        ),
      );
    }

    // 排序
    particles.sort((a, b) => a.z.compareTo(b.z));

    // 绘制
    for (var p in particles) {
      final double perspective = 0.85 + (p.z + 1) * 0.15;
      double finalAlpha = p.opacity;
      if (p.z < 0) finalAlpha *= 0.8;

      if (p.type == _ParticleType.connection) {
        final Paint linePaint = Paint()
          ..color = p.color!.withOpacity(finalAlpha)
          ..strokeWidth = 1.0 * perspective
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(p.x, p.y), Offset(p.x2!, p.y2!), linePaint);
      } else {
        final double radius = 4.0 * perspective * p.scale;
        final Paint dotPaint = Paint()
          ..color = p.color!.withOpacity(finalAlpha)
          ..style = PaintingStyle.fill;

        if (finalAlpha > 0.4) {
          canvas.drawCircle(
            Offset(p.x, p.y),
            radius * 1.6,
            Paint()
              ..color = p.color!.withOpacity(finalAlpha * 0.5)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5),
          );
        }
        canvas.drawCircle(Offset(p.x, p.y), radius, dotPaint);
      }
    }
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  @override
  bool shouldRepaint(covariant TightRopePainter oldDelegate) {
    return oldDelegate.unwindProgress != unwindProgress ||
        oldDelegate.rotationValue != rotationValue;
  }
}

enum _ParticleType { dot, connection }

class _RopeParticle {
  final _ParticleType type;
  final double x;
  final double y;
  final double z;
  final double? x2;
  final double? y2;
  final Color? color;
  final double opacity;
  final double scale;

  _RopeParticle({
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    this.x2,
    this.y2,
    this.color,
    this.opacity = 1.0,
    this.scale = 1.0,
  });
}
