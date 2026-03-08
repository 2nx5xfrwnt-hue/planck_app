import 'package:flutter/material.dart';
import '../data/planck_database.dart';

class ProgressService extends ChangeNotifier {
  final PlanckDatabase _db;
  
  int _insightPoints = 0;
  bool _isInitialized = false;

  int get insightPoints => _insightPoints;
  bool get isInitialized => _isInitialized;

  ProgressService(this._db) {
    _init();
  }

  Future<void> _init() async {
    _insightPoints = await _db.getInsightPoints();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> addInsightPoints(int points) async {
    await _db.addInsightPoints(points);
    _insightPoints += points; // Update local state for immediate UI feedback
    notifyListeners();
  }

  // Helper method for resetting progress during development
  Future<void> clearProgress() async {
    await _db.setMeta('insight_points', '0');
    _insightPoints = 0;
    notifyListeners();
  }

  bool isModuleUnlocked(int requiredPoints) {
    return _insightPoints >= requiredPoints;
  }
}
