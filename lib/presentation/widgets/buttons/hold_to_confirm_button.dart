import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/haptic_utils.dart';

/// Button that requires holding for 2 seconds to confirm action
class HoldToConfirmButton extends StatefulWidget {
  final String label;
  final VoidCallback onConfirm;
  final Duration holdDuration;
  final bool showSkipButton;
  final IconData? icon;

  const HoldToConfirmButton({
    super.key,
    required this.label,
    required this.onConfirm,
    this.holdDuration = const Duration(milliseconds: 2000),
    this.showSkipButton = true,
    this.icon,
  });

  @override
  State<HoldToConfirmButton> createState() => _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<HoldToConfirmButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _isHolding = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isHolding) {
        _handleComplete();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _handleComplete() async {
    if (_isCompleted) return;
    
    setState(() {
      _isCompleted = true;
    });

    // Heavy haptic feedback for completion
    await HapticUtils.heavy();

    // Brief delay to show completion animation
    await Future.delayed(const Duration(milliseconds: 200));

    if (mounted) {
      widget.onConfirm();
      
      // Reset state after callback
      setState(() {
        _isCompleted = false;
        _isHolding = false;
      });
      _progressController.reset();
    }
  }

  void _handleTapDown(TapDownDetails details) async {
    if (_isCompleted) return;

    await HapticUtils.light();
    
    setState(() {
      _isHolding = true;
    });
    
    _progressController.forward();
  }

  void _handleTapUp() {
    if (_isCompleted) return;

    setState(() {
      _isHolding = false;
    });
    
    _progressController.reverse();
  }

  void _handleSkip() async {
    if (_isCompleted) return;

    await HapticUtils.medium();
    widget.onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main hold-to-confirm button
        Expanded(
          child: Semantics(
            label: widget.label,
            hint: 'Hold for 2 seconds to confirm, or tap skip button',
            button: true,
            enabled: !_isCompleted,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: (_) => _handleTapUp(),
              onTapCancel: _handleTapUp,
              child: AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Progress ring
                    CustomPaint(
                      size: Size(
                        MediaQuery.of(context).size.width - (AppDimensions.spacingXl * 2),
                        AppDimensions.holdButtonSize,
                      ),
                      painter: ProgressRingPainter(
                        progress: _progressController.value,
                        color: _isCompleted ? AppColors.success : AppColors.aqua,
                        strokeWidth: AppDimensions.holdButtonProgressRingWidth,
                      ),
                    ),
                    
                    // Button content
                    Container(
                      height: AppDimensions.holdButtonSize,
                      decoration: BoxDecoration(
                        color: _isCompleted
                            ? AppColors.success.withValues(alpha: 0.2)
                            : _isHolding
                                ? AppColors.aqua.withValues(alpha: 0.2)
                                : AppColors.whiteWithOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        border: Border.all(
                          color: _isCompleted
                              ? AppColors.success
                              : _isHolding
                                  ? AppColors.aqua
                                  : AppColors.whiteWithOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                _isCompleted ? Icons.check_circle : widget.icon,
                                color: _isCompleted
                                    ? AppColors.success
                                    : Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: AppDimensions.spacingS),
                            ],
                            Text(
                              _isCompleted ? 'COMPLETED' : widget.label.toUpperCase(),
                              style: TextStyle(
                                color: _isCompleted
                                    ? AppColors.success
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Completion burst effect
                    if (_isCompleted)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          ),
        ),
        
        // Skip button
        if (widget.showSkipButton) ...[
          const SizedBox(width: AppDimensions.spacingM),
          Semantics(
            label: 'Skip',
            hint: 'Tap to skip the hold confirmation',
            button: true,
            child: InkWell(
              onTap: _handleSkip,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: Container(
              width: AppDimensions.skipButtonSize,
              height: AppDimensions.skipButtonSize,
              decoration: BoxDecoration(
                color: AppColors.whiteWithOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.whiteWithOpacity(0.2),
                ),
              ),
              child: Icon(
                Icons.skip_next,
                color: AppColors.whiteWithOpacity(0.6),
                size: 18,
              ),
            ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Custom painter for progress ring
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.height / 2) - strokeWidth;

    // Background ring (subtle)
    final backgroundPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress ring with glow
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw glow effect
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final sweepAngle = 2 * 3.14159 * progress;
    const startAngle = -3.14159 / 2; // Start from top

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
