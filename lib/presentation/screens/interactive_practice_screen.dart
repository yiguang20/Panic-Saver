import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/practice_exercise.dart';
import '../../data/models/session_record.dart';
import '../../data/repositories/session_repository.dart';
import '../widgets/common/animated_background.dart';
import '../widgets/practice/practice_animation_player.dart';
import '../widgets/buttons/hold_to_confirm_button.dart';

/// Interactive practice screen with step-by-step guidance and animations
/// Implements Requirements 12.1-12.10
class InteractivePracticeScreen extends StatefulWidget {
  final PracticeExercise exercise;

  const InteractivePracticeScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<InteractivePracticeScreen> createState() => _InteractivePracticeScreenState();
}

class _InteractivePracticeScreenState extends State<InteractivePracticeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentStep = 0;
  bool _isCompleted = false;
  bool _showAnimation = true;
  
  // Session tracking
  late DateTime _sessionStartTime;
  final List<int> _completedSteps = [];
  final SessionRepository _sessionRepository = SessionRepository();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
    
    // Start session tracking
    _sessionStartTime = DateTime.now();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }


  void _nextStep() async {
    await HapticUtils.light();
    
    if (_currentStep < widget.exercise.steps.length - 1) {
      // Animate out
      await _slideController.reverse();
      
      // Record completed step
      _completedSteps.add(_currentStep);
      
      setState(() {
        _currentStep++;
      });
      
      // Animate in
      _slideController.forward();
    } else {
      _completeSession();
    }
  }

  void _previousStep() async {
    if (_currentStep > 0) {
      await HapticUtils.light();
      await _slideController.reverse();
      
      setState(() {
        _currentStep--;
      });
      
      _slideController.forward();
    }
  }

  void _completeSession() async {
    await HapticUtils.heavy();
    
    // Record final step
    _completedSteps.add(_currentStep);
    
    setState(() {
      _isCompleted = true;
    });
    
    // Save session record
    await _saveSessionRecord();
    
    // Show completion for 2 seconds then return
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.pop(context, true); // Return true to indicate completion
    }
  }
  
  Future<void> _saveSessionRecord() async {
    try {
      final endTime = DateTime.now();
      final session = SessionRecord(
        id: 'practice_${_sessionStartTime.millisecondsSinceEpoch}',
        startTime: _sessionStartTime,
        endTime: endTime,
        duration: endTime.difference(_sessionStartTime),
        stepsCompleted: _completedSteps.length,
        completedSteps: _completedSteps,
        metadata: {
          'sessionType': 'practice',
          'exerciseId': widget.exercise.id,
          'exerciseTitle': widget.exercise.title,
          'totalSteps': widget.exercise.steps.length,
        },
      );
      await _sessionRepository.saveSession(session);
    } catch (e) {
      // Silently fail - don't interrupt user experience
      debugPrint('Failed to save practice session: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(context),
                _buildProgressIndicator(),
                Expanded(
                  child: _isCompleted
                      ? _buildCompletionView()
                      : _buildStepContent(),
                ),
                if (!_isCompleted) _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteWithOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: IconButton(
              onPressed: () async {
                await HapticUtils.light();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.exercise.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _getStepIndicatorText(),
                      style: TextStyle(
                        color: AppColors.lilac.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                    // Handbook reference badge
                    if (widget.exercise.handbookChapter != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.deepPurple.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.exercise.handbookChapter!,
                          style: TextStyle(
                            color: AppColors.lilac.withValues(alpha: 0.9),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Toggle animation visibility
          IconButton(
            onPressed: () {
              setState(() {
                _showAnimation = !_showAnimation;
              });
            },
            icon: Icon(
              _showAnimation ? Icons.visibility : Icons.visibility_off,
              color: AppColors.whiteWithOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = ((_currentStep + 1) / widget.exercise.steps.length);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
      child: Column(
        children: [
          // Step dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.exercise.steps.length, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isCurrent ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isCompleted
                      ? AppColors.aqua
                      : isCurrent
                          ? AppColors.aqua.withValues(alpha: 0.7)
                          : AppColors.cardBorder.withValues(alpha: 0.3),
                ),
              );
            }),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.cardBorder.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.aqua),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStepContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            // Animation player
            if (_showAnimation)
              Expanded(
                flex: 2,
                child: PracticeAnimationPlayer(
                  practiceType: _getPracticeType(),
                  currentStep: _currentStep,
                ),
              ),
            
            // Step content card
            Expanded(
              flex: _showAnimation ? 2 : 3,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: _showAnimation ? AppDimensions.spacingL : 0,
                ),
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                  border: Border.all(
                    color: AppColors.cardBorder.withValues(alpha: 0.3),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Step number badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.aqua.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_getStepLabel()} ${_currentStep + 1}',
                          style: const TextStyle(
                            color: AppColors.aqua,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingM),
                      // Step instruction
                      Text(
                        widget.exercise.steps[_currentStep],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      // Tip if available
                      if (_currentStep < widget.exercise.tips.length) ...[
                        const SizedBox(height: AppDimensions.spacingM),
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.spacingS),
                          decoration: BoxDecoration(
                            color: AppColors.lilac.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            border: Border.all(
                              color: AppColors.lilac.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                color: AppColors.lilac,
                                size: 16,
                              ),
                              const SizedBox(width: AppDimensions.spacingS),
                              Expanded(
                                child: Text(
                                  widget.exercise.tips[_currentStep],
                                  style: TextStyle(
                                    color: AppColors.whiteWithOpacity(0.8),
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionView() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppDimensions.spacingL),
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withValues(alpha: 0.2),
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              _getCompletionTitle(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              _getCompletionSubtitle(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteWithOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Row(
        children: [
          // Previous button
          if (_currentStep > 0)
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteWithOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: IconButton(
                onPressed: _previousStep,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: AppDimensions.spacingM),
          // Next/Complete button
          Expanded(
            child: HoldToConfirmButton(
              label: _currentStep == widget.exercise.steps.length - 1
                  ? _getCompleteLabel()
                  : _getNextLabel(),
              onConfirm: _nextStep,
              showSkipButton: true,
              icon: _currentStep == widget.exercise.steps.length - 1
                  ? Icons.check
                  : Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }


  // Helper methods
  String _getPracticeType() {
    // Map exercise ID to practice type for animation
    final id = widget.exercise.id.toLowerCase();
    if (id.contains('breath')) return 'breathing';
    if (id.contains('ground')) return 'grounding';
    if (id.contains('muscle') || id.contains('relax')) return 'muscle_relaxation';
    if (id.contains('mindful')) return 'mindfulness';
    if (id.contains('positive') || id.contains('talk')) return 'positive_self_talk';
    if (id.contains('listen')) return 'listening';
    return 'default';
  }

  String _getStepIndicatorText() {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'zh') {
      return '步骤 ${_currentStep + 1} / ${widget.exercise.steps.length}';
    }
    return 'Step ${_currentStep + 1} of ${widget.exercise.steps.length}';
  }

  String _getStepLabel() {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '步骤' : 'Step';
  }

  String _getNextLabel() {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '下一步' : 'NEXT';
  }

  String _getCompleteLabel() {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '完成' : 'COMPLETE';
  }

  String _getCompletionTitle() {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '练习完成！' : 'Practice Complete!';
  }

  String _getCompletionSubtitle() {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' 
        ? '做得很好！坚持练习会让你更加从容。' 
        : 'Well done! Regular practice builds resilience.';
  }
}
