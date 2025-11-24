import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Countdown number display with fade animation
class CountdownDisplay extends StatefulWidget {
  final int currentNumber;
  final bool isCompleted;

  const CountdownDisplay({
    super.key,
    required this.currentNumber,
    required this.isCompleted,
  });

  @override
  State<CountdownDisplay> createState() => _CountdownDisplayState();
}

class _CountdownDisplayState extends State<CountdownDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _displayNumber = 100;

  @override
  void initState() {
    super.initState();
    _displayNumber = widget.currentNumber;
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeController.forward();
  }

  @override
  void didUpdateWidget(CountdownDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.currentNumber != widget.currentNumber) {
      // Fade out, change number, fade in
      _fadeController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _displayNumber = widget.currentNumber;
          });
          _fadeController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCompleted) {
      return _buildCompletionIcon();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        _displayNumber.toString(),
        style: TextStyle(
          fontSize: _getFontSize(),
          fontWeight: FontWeight.w300,
          color: _getNumberColor(),
          height: 1.0,
          shadows: [
            Shadow(
              color: _getNumberColor().withValues(alpha: 0.5),
              blurRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionIcon() {
    return Icon(
      Icons.check_circle,
      size: 80,
      color: AppColors.success,
      shadows: [
        Shadow(
          color: AppColors.success.withValues(alpha: 0.5),
          blurRadius: 20,
        ),
      ],
    );
  }

  Color _getNumberColor() {
    // Color changes as countdown progresses
    if (_displayNumber > 66) {
      return AppColors.aqua;
    } else if (_displayNumber > 33) {
      return AppColors.lilac;
    } else {
      return AppColors.mintGreen;
    }
  }

  double _getFontSize() {
    // Font size based on number of digits
    if (_displayNumber >= 100) {
      return 56;
    } else if (_displayNumber >= 10) {
      return 64;
    } else {
      return 72;
    }
  }
}
