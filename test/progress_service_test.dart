import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:planck/services/progress_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ProgressService Tests', () {
    test('Initializes with 0 IP', () async {
      final service = ProgressService();
      // Wait for initialization to complete
      await Future.delayed(Duration.zero);
      expect(service.insightPoints, 0);
      expect(service.isInitialized, true);
    });

    test('addInsightPoints increases IP and saves to SharedPreferences', () async {
      final service = ProgressService();
      await Future.delayed(Duration.zero);
      
      await service.addInsightPoints(10);
      
      expect(service.insightPoints, 10);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('insight_points'), 10);
    });

    test('isModuleUnlocked returns true if IP >= requiredPoints', () async {
      final service = ProgressService();
      await Future.delayed(Duration.zero);
      
      await service.addInsightPoints(20);
      
      expect(service.isModuleUnlocked(10), true);
      expect(service.isModuleUnlocked(20), true);
      expect(service.isModuleUnlocked(30), false);
    });
  });
}
