import '../utils/shared_import.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();

  factory HealthService() => _instance;

  HealthService._internal();

  final Health health = Health();

  static const String HEALTH_PERMISSION_GRANTED = 'HEALTH_PERMISSION_GRANTED';

  Future<bool> hasStepPermission() async {
    if (Platform.isAndroid) return true; // Handled by daily_pedometer2 or permission_handler
    
    // For iOS HealthKit, we generally check if we've requested it before or just request it again
    // HealthKit doesn't have a direct "hasPermission" that is reliable without requesting
    // But we can track if the user has successfully connected at least once
    return getBoolAsync(HEALTH_PERMISSION_GRANTED);
  }

  Future<bool> requestHealthPermission() async {
    if (!Platform.isIOS) return true;

    try {
      var types = [HealthDataType.STEPS];
      var permissions = [HealthDataAccess.READ];
      
      await health.configure();
      bool requested = await health.requestAuthorization(types, permissions: permissions);
      
      if (requested) {
        setValue(HEALTH_PERMISSION_GRANTED, true);
      }
      return requested;
    } catch (e) {
      debugPrint("Health Permission Error: $e");
      return false;
    }
  }

  Future<int> getTodaySteps() async {
    if (!Platform.isIOS) return 0;

    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      
      await health.configure();
      int? steps = await health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (e) {
      debugPrint("Error fetching steps: $e");
      return 0;
    }
  }
}
