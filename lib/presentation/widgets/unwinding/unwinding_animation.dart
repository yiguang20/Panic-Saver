import 'dart:math' as math;
import 'package:flutter/material.dart';

class UnwindingAnimation extends StatefulWidget {
  final AnimationController controller;
  // 兼容旧参数，实际使用内部默认霓虹色
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
      duration: const Duration(seconds: 4),
    )..repeat(); // 让DNA持续自转
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, _rotationController]),
      builder: (context, child) {
        return CustomPaint(
          size: const Size(300, 500), 
          painter: DnaHelixPainter(
            unwindProgress: widget.controller.value,
            rotationValue: _rotationController.value,
            colorA: widget.ropeColor ?? const Color(0xFF00E5FF), // 青色流光
            colorB: widget.stickColor ?? const Color(0xFFE040FB), // 紫色流光
          ),
        );
      },
    );
  }
}

class DnaHelixPainter extends CustomPainter {
  final double unwindProgress;
  final double rotationValue;
  final Color colorA;
  final Color colorB;

  // 配置参数
  static const int particleCount = 42; 
  static const double baseRadius = 40.0;
  static const double verticalSpacing = 11.0;

  DnaHelixPainter({
    required this.unwindProgress,
    required this.rotationValue,
    required this.colorA,
    required this.colorB,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    // 让整体稍微靠下一点，留出顶部飘散空间
    final contentHeight = particleCount * verticalSpacing;
    final startY = (size.height - contentHeight) / 2 + contentHeight + 20;

    List<_DnaParticle> particles = [];

    for (int i = 0; i < particleCount; i++) {
      // 归一化索引
      final double indexRatio = i / particleCount;
      
      // 计算解旋阈值：1.0 - progress 代表剩下的完整部分
      final double activeLimit = 1.0 - unwindProgress;
      
      bool isUnraveling = indexRatio > activeLimit;
      
      // unravelFactor: 0.0 (未解开) -> 1.0 (完全解开)
      double unravelFactor = 0.0;
      if (isUnraveling) {
         // 使用较小的乘数让过渡稍微平滑一点点，防止瞬间跳变，
         // 但后续会用这个因子做激进的透明度计算
         double distinctness = (indexRatio - activeLimit) * 3.5;
         unravelFactor = distinctness.clamp(0.0, 1.0);
      }

      // --- 核心修改：透明度控制逻辑 ---

      // 1. 粒子透明度：加速消失
      // 乘以 1.8 意味着粒子飞出路程的 55% 左右就会完全消失
      double particleAlpha = (1.0 - unravelFactor * 1.8).clamp(0.0, 1.0);

      // 2. 连接键透明度：极速断裂
      // 乘以 6.0 意味着只要有一点点解开的趋势 (16%的进度)，连接线就立刻消失
      // 视觉上会造成"啪"一下断开的效果
      double connectionAlpha = (1.0 - unravelFactor * 6.0).clamp(0.0, 1.0);

      // 如果粒子已经完全看不见了，就不处理了，节省性能
      if (particleAlpha <= 0.0) continue;

      // 物理位置计算
      final double yBase = startY - (i * verticalSpacing);
      // 稍微增加向上漂浮的速度 (* 100)
      final double yPos = yBase - (unravelFactor * 100); 
      
      // 旋转角度
      final double angle = (i * 0.55) + (rotationValue * math.pi * 2);

      // 半径扩散：解开时半径迅速变大
      final double currentRadius = baseRadius + (unravelFactor * 140); 
      
      // 3D 坐标转换
      double zA = math.cos(angle); 
      double xA = centerX + math.sin(angle) * currentRadius;
      
      double zB = math.cos(angle + math.pi); 
      double xB = centerX + math.sin(angle + math.pi) * currentRadius;

      // --- 添加粒子 ---

      // 连接线 (Bond)
      // 只有当 connectionAlpha 还有值时才添加
      if (connectionAlpha > 0.05) {
        particles.add(_DnaParticle(
          type: _ParticleType.connection,
          x: xA, y: yPos, z: (zA + zB) / 2,
          x2: xB, y2: yPos,
          // 连接线的基础透明度本来就低一点(0.3)，现在还要乘以快速衰减系数
          opacity: connectionAlpha * 0.3, 
          color: Colors.white,
        ));
      }

      // Strand A (Dot)
      particles.add(_DnaParticle(
        type: _ParticleType.dot,
        x: xA, y: yPos, z: zA,
        color: colorA,
        opacity: particleAlpha,
        // 飞出时稍微变大一点点，增加能量感
        scale: 1.0 + unravelFactor * 0.8, 
      ));

      // Strand B (Dot)
      particles.add(_DnaParticle(
        type: _ParticleType.dot,
        x: xB, y: yPos, z: zB,
        color: colorB,
        opacity: particleAlpha,
        scale: 1.0 + unravelFactor * 0.8,
      ));
    }

    // 排序：处理遮挡关系 (Painter's Algorithm)
    particles.sort((a, b) => a.z.compareTo(b.z));

    // 绘制循环
    for (var p in particles) {
      // 深度透视计算
      final double perspective = 0.8 + (p.z + 1) * 0.2; // 0.8 ~ 1.2
      
      // 最终透明度结合深度 (远处的暗一点)
      double finalAlpha = p.opacity * (0.6 + (p.z + 1) * 0.2);
      finalAlpha = finalAlpha.clamp(0.0, 1.0);

      if (p.type == _ParticleType.connection) {
        final Paint linePaint = Paint()
          ..color = p.color!.withOpacity(finalAlpha)
          ..strokeWidth = 1.5 * perspective
          ..strokeCap = StrokeCap.round;
        
        canvas.drawLine(Offset(p.x, p.y), Offset(p.x2!, p.y2!), linePaint);
      
      } else {
        final double radius = 3.5 * perspective * p.scale;
        final Paint dotPaint = Paint()
          ..color = p.color!.withOpacity(finalAlpha)
          ..style = PaintingStyle.fill;
        
        // 绘制光晕 (Bloom)
        // 只有比较亮的前排粒子才画光晕，性能更好且画面不脏
        if (finalAlpha > 0.3) {
          canvas.drawCircle(
            Offset(p.x, p.y), 
            radius * 1.8, 
            Paint()..color = p.color!.withOpacity(finalAlpha * 0.4)
                   ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0)
          );
        }

        // 绘制核心实体
        canvas.drawCircle(Offset(p.x, p.y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DnaHelixPainter oldDelegate) {
    return oldDelegate.unwindProgress != unwindProgress || 
           oldDelegate.rotationValue != rotationValue;
  }
}

// 辅助类
enum _ParticleType { dot, connection }

class _DnaParticle {
  final _ParticleType type;
  final double x;
  final double y;
  final double z; 
  final double? x2; 
  final double? y2; 
  final Color? color;
  final double opacity;
  final double scale;

  _DnaParticle({
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