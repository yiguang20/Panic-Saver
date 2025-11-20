import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/durations.dart';

/// 3D card flip animation widget
class CardFlipAnimation extends StatefulWidget {
  final Widget frontCard;
  final Widget backCard;
  final bool isFlipped;
  final VoidCallback? onFlipComplete;

  const CardFlipAnimation({
    super.key,
    required this.frontCard,
    required this.backCard,
    required this.isFlipped,
    this.onFlipComplete,
  });

  @override
  State<CardFlipAnimation> createState() => _CardFlipAnimationState();
}

class _CardFlipAnimationState extends State<CardFlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.cardFlip,
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CardFlipAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFlipped != widget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward().then((_) {
          if (widget.onFlipComplete != null) {
            widget.onFlipComplete!();
          }
        });
      } else {
        _controller.reverse().then((_) {
          if (widget.onFlipComplete != null) {
            widget.onFlipComplete!();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final isShowingFront = _flipAnimation.value < 0.5;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(_flipAnimation.value * math.pi), // π radians = 180 degrees
          child: isShowingFront
              ? widget.frontCard
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi), // flip back card
                  child: widget.backCard,
                ),
        );
      },
    );
  }
}
