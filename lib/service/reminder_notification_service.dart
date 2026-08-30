import '../utils/shared_import.dart';

/// Notification ID ranges: Water 1000-1999, Meal breakfast 2001-2007, lunch 2011-2017, snacks 2021-2027, dinner 2031-2037.
class ReminderNotificationService {
  static const String _channelKey = 'scheduled_channel';
  static const int _waterIdStart = 1000;
  static const int _waterIdEnd = 1999;
  static const int _mealBreakfastBase = 2001;
  static const int _mealLunchBase = 2011;
  static const int _mealSnacksBase = 2021;
  static const int _mealDinnerBase = 2031;

  /// Sync water and meal reminders from user profile (e.g. after login).
  static Future<void> syncRemindersFromProfile(UserProfile? profile) async {
    if (profile == null) return;
    await scheduleWaterReminders(profile.waterReminderSettings);
    await scheduleMealReminders(profile.mealReminderSettings);
  }

  /// Cancel all water reminder notifications.
  static Future<void> _cancelWaterReminders() async {
    for (int id = _waterIdStart; id <= _waterIdEnd; id++) {
      await AwesomeNotifications().cancel(id);
    }
  }

  /// Cancel all meal reminder notifications (breakfast, lunch, snacks, dinner).
  static Future<void> _cancelMealReminders() async {
    for (int base in [
      _mealBreakfastBase,
      _mealLunchBase,
      _mealSnacksBase,
      _mealDinnerBase,
    ]) {
      // Cancel the daily repeated ID for each meal
      await AwesomeNotifications().cancel(base);
    }
  }

  /// Parse "HH:mm" to (hour, minute).
  static (int, int) _parseTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return (8, 0);
    final parts = timeStr.split(':');
    if (parts.length < 2) return (8, 0);
    return (int.tryParse(parts[0]) ?? 8, int.tryParse(parts[1]) ?? 0);
  }

  /// Schedule water reminders. When disabled, only cancels; time is already saved via API.
  static Future<void> scheduleWaterReminders(
    WaterReminderSettings? settings,
  ) async {
    await _cancelWaterReminders();
    if (settings == null || settings.enabled != true) return;

    final intervalMinutes = settings.interval ?? 60;
    final start = _parseTime(settings.start);
    final end = _parseTime(settings.end);

    if (intervalMinutes >= 24 * 60) {
      // Once per day at at_time or start
      final (
        hour,
        minute,
      ) = settings.atTime != null && settings.atTime!.isNotEmpty
          ? _parseTime(settings.atTime)
          : start;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: _waterIdStart,
          channelKey: _channelKey,
          title: languages.lblWaterreminder,
          body: 'Time to drink water! Stay hydrated.',
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          second: 0,
          allowWhileIdle: true,
          repeats: true,
        ),
      );
      return;
    }

    // From start to end every intervalMinutes
    final int startM = start.$1 * 60 + start.$2;
    int endM = end.$1 * 60 + end.$2;
    if (endM <= startM) endM += 24 * 60;

    int id = _waterIdStart;
    for (int m = startM; m <= endM; m += intervalMinutes) {
      final int h = (m % (24 * 60)) ~/ 60;
      final int min = m % 60;

      if (id > _waterIdEnd) return;
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: _channelKey,
          title: languages.lblWaterreminder,
          body: 'Time to drink water! Stay hydrated.',
        ),
        schedule: NotificationCalendar(
          hour: h,
          minute: min,
          second: 0,
          allowWhileIdle: true,
          repeats: true,
        ),
      );
      id++;
    }
  }

  /// Schedule one meal type (Daily repeat).
  static Future<void> _scheduleMealAt(
    int baseId,
    String timeStr,
    String title,
    String body,
  ) async {
    final (hour, minute) = _parseTime(timeStr);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: baseId,
        channelKey: _channelKey,
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        allowWhileIdle: true,
        repeats: true,
      ),
    );
  }

  /// Schedule meal reminders. When a meal is disabled, its schedules are cancelled by re-scheduling all and only enabled ones.
  static Future<void> scheduleMealReminders(
    MealReminderSettings? settings,
  ) async {
    await _cancelMealReminders();
    if (settings == null) return;

    if (settings.breakfast?.enabled == true &&
        settings.breakfast?.time != null) {
      await _scheduleMealAt(
        _mealBreakfastBase,
        settings.breakfast!.time!,
        'Meal Reminder',
        'Time for breakfast!',
      );
    }
    if (settings.lunch?.enabled == true && settings.lunch?.time != null) {
      await _scheduleMealAt(
        _mealLunchBase,
        settings.lunch!.time!,
        'Meal Reminder',
        'Time for lunch!',
      );
    }
    if (settings.snacks?.enabled == true && settings.snacks?.time != null) {
      await _scheduleMealAt(
        _mealSnacksBase,
        settings.snacks!.time!,
        'Meal Reminder',
        'Time for snacks!',
      );
    }
    if (settings.dinner?.enabled == true && settings.dinner?.time != null) {
      await _scheduleMealAt(
        _mealDinnerBase,
        settings.dinner!.time!,
        'Meal Reminder',
        'Time for dinner!',
      );
    }
  }
}
