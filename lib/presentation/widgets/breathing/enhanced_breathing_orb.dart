import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Enhanced breathing orb for main breathing guidance
/// Features gradient colors, glow effects, and rhythm display
class EnhancedBreathingOrb extends StatefulWidget {
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final bool showRhythm;

  const EnhancedBreathingOrb({
    super.key,
    this.inhaleSeconds = 4,
    this.holdSeconds = 7,
    this.exhaleSeconds = 8,
    this.showRhythm = true,
  });

  @override
  State<EnhancedBreathingOrb> createState() => _EnhancedBreathingOrbState();
}

class _EnhancedBreathingOrbState extends State<EnhancedBreathingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    final totalDuration = widget.inhaleSeconds + 
                         widget.holdSeconds + 
                         widget.exhaleSeconds;
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalDuration),
    );

    // Calculate weights based on actual durations
    final totalWeight = 100.0;
    final inhaleWeight = (widget.inhaleSeconds / totalDuration * totalWeight).round();
    final holdWeight = (widget.holdSeconds / totalDuration * totalWeight).round();
    final exhaleWeight = totalWeight - inhaleWeight - holdWeight;

    _scaleAnimation = TweenSequence<double>([
      // Inhale: expand
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: inhaleWeight.toDouble(),
      ),
      // Hold: stay expanded
      TweenSequenceItem(
        tween: ConstantTween<double>(1.15),
        weight: holdWeight.toDouble(),
      ),
      // Exhale: contract
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: exhaleWeight.toDouble(),
      ),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      // Inhale: brighten
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.7, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: inhaleWeight.toDouble(),
      ),
      // Hold: stay bright
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: holdWeight.toDouble(),
      ),
      // Exhale: dim
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.7)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: exhaleWeight.toDouble(),
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate orb size based on available space
        final maxSize = constraints.maxHeight < constraints.maxWidth 
            ? constraints.maxHeight 
            : constraints.maxWidth;
        final orbSize = (maxSize * 0.8).clamp(150.0, 250.0);
        
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: orbSize,
                    height: orbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.aqua.withValues(alpha: 0.3),
                          AppColors.lilac.withValues(alpha: 0.3),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.aqua.withValues(
                            alpha: 0.2 * _opacityAnimation.value,
                          ),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${widget.inhaleSeconds}-${widget.holdSeconds}-${widget.exhaleSeconds}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
