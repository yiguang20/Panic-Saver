import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../domain/providers/settings_provider.dart';

/// Animated breathing orb that guides breathing rhythm
class BreathingOrb extends StatefulWidget {
  const BreathingOrb({super.key});

  @override
  State<BreathingOrb> createState() => _BreathingOrbState();
}

class _BreathingOrbState extends State<BreathingOrb>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Delay initialization until after first frame to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _initializeAnimation();
        });
      }
    });
  }

  void _initializeAnimation() {
    final settings = Provider.of<SettingsProvider>(context, listen: false).breathingSettings;
    
    // Dispose old controller if exists
    _controller?.dispose();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (settings.totalDuration * 1000).round()),
    );

    // Calculate weights based on actual durations
    final totalWeight = 100.0;
    final inhaleWeight = (settings.inhaleWeight * totalWeight).round();
    final holdWeight = (settings.holdWeight * totalWeight).round();
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
    ]).animate(_controller!);

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
    ]).animate(_controller!);

    _controller!.repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const SizedBox.shrink();
    }
    
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: AppDimensions.breathingOrbSize,
              height: AppDimensions.breathingOrbSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.aqua.withOpacity(0.3),
                    AppColors.lilac.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aqua.withOpacity(0.2 * _opacityAnimation.value),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Consumer<SettingsProvider>(
                  builder: (context, settings, _) {
                    final breathing = settings.breathingSettings;
                    return Text(
                      '${breathing.inhaleDuration.toStringAsFixed(0)}-${breathing.holdDuration.toStringAsFixed(0)}-${breathing.exhaleDuration.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
