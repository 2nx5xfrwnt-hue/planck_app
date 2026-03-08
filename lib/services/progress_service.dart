import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class ProgressService extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  int _insightPoints = 0;
  int _currentStreak = 0;
  String? _lastActiveDate;
  bool _isInitialized = false;

  int get insightPoints => _insightPoints;
  int get currentStreak => _currentStreak;
  String? get lastActiveDate => _lastActiveDate;
  bool get isInitialized => _isInitialized;

  ProgressService() {
    _init();
  }

  Future<void> _init() async {
    final row = await _db.getUserProgress();
    _insightPoints = row['insight_points'] as int? ?? 0;
    _currentStreak = row['current_streak'] as int? ?? 0;
    _lastActiveDate = row['last_active_date'] as String?;
    _isInitialized = true;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Insight points
  // ---------------------------------------------------------------------------

  Future<void> addInsightPoints(int points) async {
    _insightPoints += points;
    await _db.updateInsightPoints(_insightPoints);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Streak tracking
  // ---------------------------------------------------------------------------

  /// Call once per session (e.g. on app launch) to update the streak.
  Future<void> updateStreak() async {
    final today = _todayString();
    if (_lastActiveDate == today) return; // Already counted today.

    if (_lastActiveDate != null) {
      final lastDate = DateTime.tryParse(_lastActiveDate!);
      final now = DateTime.now();
      if (lastDate != null) {
        final diff = DateTime(now.year, now.month, now.day)
            .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
            .inDays;
        if (diff == 1) {
          _currentStreak += 1;
        } else if (diff > 1) {
          _currentStreak = 1; // Streak broken.
        }
      } else {
        _currentStreak = 1;
      }
    } else {
      _currentStreak = 1; // First ever session.
    }

    _lastActiveDate = today;
    await _db.updateStreak(_currentStreak, _lastActiveDate!);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Module progress
  // ---------------------------------------------------------------------------

  bool isModuleUnlocked(int requiredPoints) {
    return _insightPoints >= requiredPoints;
  }

  Future<Map<String, dynamic>?> getModuleProgress(String moduleId) async {
    return _db.getModuleProgress(moduleId);
  }

  Future<void> markModuleCompleted(String moduleId) async {
    await _db.markModuleCompleted(moduleId);
    notifyListeners();
  }

  /// Marks a post as completed (unlocked) in the database.
  Future<void> markPostCompleted(String postId) async {
    await _db.markPostUnlocked(postId, _todayString());
    notifyListeners();
  }

  Future<void> updateCardsViewedCount(String moduleId, int count) async {
    await _db.updateCardsViewedCount(moduleId, count);
  }

  // ---------------------------------------------------------------------------
  // Development helpers
  // ---------------------------------------------------------------------------

  /// Resets insight points (for development / testing only).
  Future<void> clearProgress() async {
    _insightPoints = 0;
    await _db.updateInsightPoints(0);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
