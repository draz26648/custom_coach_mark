import 'package:flutter/material.dart';
import 'coach_mark_target.dart';

/// Controller for managing the coach mark tutorial
class CoachMarkController extends ChangeNotifier {
  /// List of targets to be highlighted
  final List<CoachMarkTarget> targets;
  
  /// Current index of the target being shown
  int _currentIndex = 0;
  
  /// Whether the coach mark is currently showing
  bool _isShowing = false;
  
  /// Callback when the tutorial is completed
  final VoidCallback? onFinish;
  
  /// Callback when the tutorial is skipped
  final VoidCallback? onSkip;
  
  /// Constructor for creating a coach mark controller
  CoachMarkController({
    required this.targets,
    this.onFinish,
    this.onSkip,
  });
  
  /// Get the current target
  CoachMarkTarget get currentTarget => targets[_currentIndex];
  
  /// Get the current index
  int get currentIndex => _currentIndex;
  
  /// Get the total number of targets
  int get targetCount => targets.length;
  
  /// Check if there is a next target
  bool get hasNext => _currentIndex < targets.length - 1;
  
  /// Check if there is a previous target
  bool get hasPrevious => _currentIndex > 0;
  
  /// Check if the coach mark is currently showing
  bool get isShowing => _isShowing;
  
  /// Show the coach mark
  void show(BuildContext context) {
    _isShowing = true;
    _currentIndex = 0;
    notifyListeners();
  }
  
  /// Hide the coach mark
  void hide() {
    _isShowing = false;
    notifyListeners();
    
    // Call onFinish if we're at the last target
    if (_currentIndex >= targets.length - 1) {
      onFinish?.call();
    }
  }
  
  /// Skip the tutorial
  void skip() {
    _isShowing = false;
    notifyListeners();
    onSkip?.call();
  }
  
  /// Move to the next target
  void next() {
    if (hasNext) {
      _currentIndex++;
      notifyListeners();
    } else {
      hide();
    }
  }
  
  /// Move to the previous target
  void previous() {
    if (hasPrevious) {
      _currentIndex--;
      notifyListeners();
    }
  }
  
  /// Jump to a specific target
  void jumpTo(int index) {
    if (index >= 0 && index < targets.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
