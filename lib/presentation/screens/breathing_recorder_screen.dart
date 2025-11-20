import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/breathing_settings.dart';
import '../../presentation/l10n/app_localizations.dart';

/// Screen for creating custom breathing rhythm
class BreathingRecorderScreen extends StatefulWidget {
  const BreathingRecorderScreen({super.key});

  @override
  State<BreathingRecorderScreen> createState() => _BreathingRecorderScreenState();
}

class _BreathingRecorderScreenState extends State<BreathingRecorderScreen>
    with SingleTickerProviderStateMixin {
  final _inhaleController = TextEditingController(text: '4.0');
  final _holdController = TextEditingController(text: '7.0');
  final _exhaleController = TextEditingController(text: '8.0');
  
  bool _isRecording = false;
  BreathingPhase _currentPhase = BreathingPhase.waiting;
  DateTime? _phaseStartTime;
  double? _recordedInhale;
  double? _recordedHold;
  double? _recordedExhale;
  
  // Animation
  AnimationController? _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _startPreviewAnimation();
  }

  @override
  void dispose() {
    _inhaleController.dispose();
    _holdController.dispose();
    _exhaleController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _startPreviewAnimation() {
    final inhale = double.tryParse(_inhaleController.text) ?? 4.0;
    final hold = double.tryParse(_holdController.text) ?? 7.0;
    final exhale = double.tryParse(_exhaleController.text) ?? 8.0;
    final total = inhale + hold + exhale;

    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (total * 1000).round()),
    );

    final inhaleWeight = (inhale / total * 100).round();
    final holdWeight = (hold / total * 100).round();
    final exhaleWeight = 100 - inhaleWeight - holdWeight;

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: inhaleWeight.toDouble(),
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: holdWeight.toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.6)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: exhaleWeight.toDouble(),
      ),
    ]).animate(_animationController!);

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: AppColors.aqua.withValues(alpha: 0.6), end: AppColors.aqua),
        weight: inhaleWeight.toDouble(),
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: AppColors.lilac, end: AppColors.lilac),
        weight: holdWeight.toDouble(),
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: AppColors.aqua, end: AppColors.aqua.withValues(alpha: 0.6)),
        weight: exhaleWeight.toDouble(),
      ),
    ]).animate(_animationController!);

    _animationController!.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.breathingRecorderTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isRecording ? _buildRecordingView(l10n) : _buildPreviewView(l10n),
      ),
    );
  }

  Widget _buildPreviewView(AppLocalizations l10n) {
    return Column(
      children: [
        // Input section at top
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
          child: Column(
            children: [
              Text(
                l10n.enterCustomRhythm,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Row(
                children: [
                  Expanded(child: _buildCompactInputField(l10n.inhale, _inhaleController, AppColors.aqua)),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(child: _buildCompactInputField(l10n.hold, _holdController, AppColors.lilac)),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(child: _buildCompactInputField(l10n.exhale, _exhaleController, AppColors.aqua.withValues(alpha: 0.6))),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingS),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _startPreviewAnimation();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lilac.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingL,
                    vertical: AppDimensions.spacingS,
                  ),
                ),
                child: Text(l10n.startPractice, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),

        // Large breathing orb in center
        Expanded(
          child: Center(
            child: _animationController != null
                ? AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _colorAnimation.value,
                            boxShadow: [
                              BoxShadow(
                                color: (_colorAnimation.value ?? AppColors.aqua).withValues(alpha: 0.5),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getPhaseTextForAnimation(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${_inhaleController.text}-${_holdController.text}-${_exhaleController.text}',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const CircularProgressIndicator(),
          ),
        ),

        // Bottom buttons
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCurrentSettings,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spacingM,
                    ),
                  ),
                  child: Text(l10n.saveAsCustom),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _startRecording,
                  icon: const Icon(Icons.fiber_manual_record, size: 16),
                  label: Text(l10n.recordYourRhythm),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spacingM,
                    ),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactInputField(String label, TextEditingController controller, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingView(AppLocalizations l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            children: [
              Text(
                l10n.recordYourRhythm,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                _getRecordingInstruction(l10n),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.lilac.withValues(alpha: 0.8),
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Recorded values display
        if (_recordedInhale != null || _recordedHold != null || _recordedExhale != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingS),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRecordedValue(l10n.inhale, _recordedInhale, AppColors.aqua),
                  _buildRecordedValue(l10n.hold, _recordedHold, AppColors.lilac),
                  _buildRecordedValue(l10n.exhale, _recordedExhale, AppColors.aqua.withValues(alpha: 0.6)),
                ],
              ),
            ),
          ),

        const SizedBox(height: AppDimensions.spacingL),

        // Large interactive circle
        Expanded(
          child: Center(
            child: GestureDetector(
              onTapDown: (_) => _handleRecordTapDown(),
              onTapUp: (_) => _handleRecordTapUp(),
              onTapCancel: () => _handleRecordTapUp(),
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getRecordingCircleColor(),
                  boxShadow: [
                    BoxShadow(
                      color: _getRecordingCircleColor().withValues(alpha: 0.5),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _getRecordingPhaseText(l10n),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Bottom buttons
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            children: [
              if (_recordedInhale != null && _recordedHold != null && _recordedExhale != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveRecordedRhythm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingM,
                      ),
                    ),
                    child: Text(l10n.saveAsCustom),
                  ),
                ),
              const SizedBox(height: AppDimensions.spacingS),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isRecording = false;
                    _currentPhase = BreathingPhase.waiting;
                    _phaseStartTime = null;
                    _recordedInhale = null;
                    _recordedHold = null;
                    _recordedExhale = null;
                    _startPreviewAnimation();
                  });
                },
                child: Text(
                  l10n.cancel,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordedValue(String label, double? value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value != null ? '${value.toStringAsFixed(1)}s' : '--',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getPhaseTextForAnimation() {
    if (_animationController == null) return '';
    
    final progress = _animationController!.value;
    final inhale = double.tryParse(_inhaleController.text) ?? 4.0;
    final hold = double.tryParse(_holdController.text) ?? 7.0;
    final exhale = double.tryParse(_exhaleController.text) ?? 8.0;
    final total = inhale + hold + exhale;
    
    final inhaleEnd = inhale / total;
    final holdEnd = (inhale + hold) / total;
    
    final l10n = AppLocalizations.of(context)!;
    
    if (progress < inhaleEnd) {
      return l10n.phaseInhale;
    } else if (progress < holdEnd) {
      return l10n.hold;
    } else {
      return l10n.phaseExhale;
    }
  }

  String _getRecordingInstruction(AppLocalizations l10n) {
    switch (_currentPhase) {
      case BreathingPhase.waiting:
        return l10n.instructionWaiting;
      case BreathingPhase.inhaling:
        return l10n.instructionInhaling;
      case BreathingPhase.holdingAfterInhale:
        return l10n.instructionHoldingAfterInhale;
      case BreathingPhase.exhaling:
        return l10n.instructionExhaling;
      case BreathingPhase.holdingAfterExhale:
        return l10n.instructionHoldingAfterExhale;
    }
  }

  String _getRecordingPhaseText(AppLocalizations l10n) {
    switch (_currentPhase) {
      case BreathingPhase.waiting:
        return l10n.phaseHold;
      case BreathingPhase.inhaling:
        return l10n.phaseInhale;
      case BreathingPhase.holdingAfterInhale:
        return l10n.hold;
      case BreathingPhase.exhaling:
        return l10n.phaseExhale;
      case BreathingPhase.holdingAfterExhale:
        return l10n.hold;
    }
  }

  Color _getRecordingCircleColor() {
    switch (_currentPhase) {
      case BreathingPhase.waiting:
        return Colors.white.withValues(alpha: 0.2);
      case BreathingPhase.inhaling:
        return AppColors.aqua;
      case BreathingPhase.holdingAfterInhale:
        return AppColors.lilac;
      case BreathingPhase.exhaling:
        return AppColors.aqua.withValues(alpha: 0.6);
      case BreathingPhase.holdingAfterExhale:
        return AppColors.lilac.withValues(alpha: 0.6);
    }
  }

  void _startRecording() async {
    await HapticUtils.light();
    _animationController?.stop();
    setState(() {
      _isRecording = true;
      _currentPhase = BreathingPhase.waiting;
      _recordedInhale = null;
      _recordedHold = null;
      _recordedExhale = null;
    });
  }

  void _handleRecordTapDown() async {
    await HapticUtils.light();
    final now = DateTime.now();

    setState(() {
      if (_currentPhase == BreathingPhase.waiting) {
        _currentPhase = BreathingPhase.inhaling;
        _phaseStartTime = now;
      } else if (_currentPhase == BreathingPhase.holdingAfterInhale) {
        final holdDuration = now.difference(_phaseStartTime!).inMilliseconds / 1000.0;
        _recordedHold = holdDuration;
        _currentPhase = BreathingPhase.exhaling;
        _phaseStartTime = now;
      }
    });
  }

  void _handleRecordTapUp() async {
    await HapticUtils.light();
    final now = DateTime.now();

    setState(() {
      if (_currentPhase == BreathingPhase.inhaling) {
        final inhaleDuration = now.difference(_phaseStartTime!).inMilliseconds / 1000.0;
        _recordedInhale = inhaleDuration;
        _currentPhase = BreathingPhase.holdingAfterInhale;
        _phaseStartTime = now;
      } else if (_currentPhase == BreathingPhase.exhaling) {
        final exhaleDuration = now.difference(_phaseStartTime!).inMilliseconds / 1000.0;
        _recordedExhale = exhaleDuration;
        _currentPhase = BreathingPhase.waiting;
        _phaseStartTime = null;
      }
    });
  }

  void _saveCurrentSettings() async {
    final inhale = double.tryParse(_inhaleController.text);
    final hold = double.tryParse(_holdController.text);
    final exhale = double.tryParse(_exhaleController.text);

    if (inhale == null || hold == null || exhale == null ||
        inhale <= 0 || hold <= 0 || exhale <= 0) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.invalidInput)),
      );
      return;
    }

    await HapticUtils.medium();

    final settings = BreathingSettings(
      inhaleDuration: inhale,
      holdDuration: hold,
      exhaleDuration: exhale,
    );

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.rhythmSaved)),
      );
      Navigator.pop(context, settings);
    }
  }

  void _saveRecordedRhythm() async {
    if (_recordedInhale == null || _recordedHold == null || _recordedExhale == null) {
      return;
    }

    await HapticUtils.medium();

    final settings = BreathingSettings(
      inhaleDuration: _recordedInhale!,
      holdDuration: _recordedHold!,
      exhaleDuration: _recordedExhale!,
    );

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.rhythmSaved)),
      );
      Navigator.pop(context, settings);
    }
  }
}

enum BreathingPhase {
  waiting,
  inhaling,
  holdingAfterInhale,
  exhaling,
  holdingAfterExhale,
}
