import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService extends ChangeNotifier {
  static const String _insightPointsKey = 'insight_points';
  
  int _insightPoints = 0;
  bool _isInitialized = false;

  int get insightPoints => _insightPoints;
  bool get isInitialized => _isInitialized;

  ProgressService() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _insightPoints = prefs.getInt(_insightPointsKey) ?? 0;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> addInsightPoints(int points) async {
    _insightPoints += points;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_insightPointsKey, _insightPoints);
    notifyListeners();
  }

  // Helper method for resetting progress during development
  Future<void> clearProgress() async {
    _insightPoints = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_insightPointsKey);
    notifyListeners();
  }

  bool isModuleUnlocked(int requiredPoints) {
    return _insightPoints >= requiredPoints;
  }
}
