import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/durations.dart';

/// Animated background with gradient, floating orbs, and twinkling stars
class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _orb1Controller;
  late AnimationController _orb2Controller;
  final List<Star> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Initialize orb animations
    _orb1Controller = AnimationController(
      vsync: this,
      duration: AppDurations.orbFloat,
    )..repeat(reverse: true);

    _orb2Controller = AnimationController(
      vsync: this,
      duration: AppDurations.orbFloat,
    )..repeat(reverse: true);

    // Generate stars
    _generateStars();
  }

  void _generateStars() {
    for (int i = 0; i < 50; i++) {
      _stars.add(Star(
        left: _random.nextDouble(),
        top: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 1,
        delay: _random.nextInt(5),
      ));
    }
  }

  @override
  void dispose() {
    _orb1Controller.dispose();
    _orb2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.gradientStart,
                AppColors.gradientMid,
                AppColors.gradientEnd,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Floating orb 1
        AnimatedBuilder(
          animation: _orb1Controller,
          builder: (context, child) {
            return Positioned(
              left: -150 + (_orb1Controller.value * 30),
              top: -150 + (_orb1Controller.value * 50),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.aqua.withOpacity(0.4),
                      AppColors.aqua.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Floating orb 2
        AnimatedBuilder(
          animation: _orb2Controller,
          builder: (context, child) {
            return Positioned(
              right: -200 + (_orb2Controller.value * 30),
              bottom: -200 + (_orb2Controller.value * 50),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.lilac.withOpacity(0.4),
                      AppColors.lilac.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Stars
        ..._stars.map((star) => _buildStar(star)),

        // Child content
        widget.child,
      ],
    );
  }

  Widget _buildStar(Star star) {
    return Positioned(
      left: MediaQuery.of(context).size.width * star.left,
      top: MediaQuery.of(context).size.height * star.top,
      child: TwinklingStar(
        size: star.size,
        delay: star.delay,
      ),
    );
  }
}

class Star {
  final double left;
  final double top;
  final double size;
  final int delay;

  Star({
    required this.left,
    required this.top,
    required this.size,
    required this.delay,
  });
}

class TwinklingStar extends StatefulWidget {
  final double size;
  final int delay;

  const TwinklingStar({
    Key? key,
    required this.size,
    required this.delay,
  }) : super(key: key);

  @override
  State<TwinklingStar> createState() => _TwinklingStarState();
}

class _TwinklingStarState extends State<TwinklingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.starTwinkle,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 0.6)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 0.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    Future.delayed(Duration(seconds: widget.delay), () {
      if (mounted) {
        _controller.repeat();
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
