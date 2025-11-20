import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/durations.dart';

/// Bubble effect that expands from tap location
class BubbleEffect extends StatefulWidget {
  final Offset position;
  final VoidCallback? onComplete;

  const BubbleEffect({
    super.key,
    required this.position,
    this.onComplete,
  });

  @override
  State<BubbleEffect> createState() => _BubbleEffectState();
}

class _BubbleEffectState extends State<BubbleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.bubbleExpand,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 30.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.6),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 0.8),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 0.0),
        weight: 60,
      ),
    ]).animate(_controller);

    _controller.forward().then((_) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 10,
      top: widget.position.dy - 10,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.lilac,
                      AppColors.aqua,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
