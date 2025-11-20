import 'package:flutter/foundation.dart';
import '../../data/repositories/preferences_repository.dart';

/// Provider for managing crisis mode state
class CrisisProvider extends ChangeNotifier {
  final PreferencesRepository _preferencesRepository;

  int _currentStep = 0;
  bool _isFlipped = false;

  CrisisProvider(this._preferencesRepository);

  /// Current step number (0-8)
  int get currentStep => _currentStep;

  /// Whether the card is flipped to show help letter
  bool get isFlipped => _isFlipped;

  /// Total number of steps in the crisis flow
  int get totalSteps => 9;

  /// Advance to the next step
  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      _saveCurrentStep();
      notifyListeners();
    }
  }

  /// Reset to the first step
  void resetSteps() {
    _currentStep = 0;
    _saveCurrentStep();
    notifyListeners();
  }

  /// Toggle the card flip state
  void flipCard() {
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  /// Restore state from saved step number
  Future<void> restoreState() async {
    final savedStep = await _preferencesRepository.loadCurrentStep();
    if (savedStep != null) {
      _currentStep = savedStep;
      notifyListeners();
    }
  }

  /// Save current step to persistent storage
  Future<void> _saveCurrentStep() async {
    await _preferencesRepository.saveCurrentStep(_currentStep);
  }

  /// Clear saved state
  Future<void> clearSavedState() async {
    await _preferencesRepository.clearState();
  }
}
