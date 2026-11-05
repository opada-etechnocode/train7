import '../utils/shared_import.dart';

const String ACTIVE_UGC_PROGRAM_ID = 'ACTIVE_UGC_PROGRAM_ID';
const String ACTIVE_UGC_PROGRAM_NAME = 'ACTIVE_UGC_PROGRAM_NAME';

/// Syncs active UGC plan day goals (water / steps) and exposes days for schedule.
class UgcPlanSyncService {
  static const int mlPerGlass = 250;

  static int? get activeProgramId {
    final int id = getIntAsync(ACTIVE_UGC_PROGRAM_ID);
    return id == 0 ? null : id;
  }

  static String get activeProgramName =>
      getStringAsync(ACTIVE_UGC_PROGRAM_NAME);

  static Future<void> activateProgram(UgcProgramModel program) async {
    if (program.id == null) return;
    await setValue(ACTIVE_UGC_PROGRAM_ID, program.id);
    await setValue(ACTIVE_UGC_PROGRAM_NAME, program.name.validate());
    await syncTodayGoals();
  }

  static Future<void> clearActiveProgram() async {
    await setValue(ACTIVE_UGC_PROGRAM_ID, 0);
    await setValue(ACTIVE_UGC_PROGRAM_NAME, '');
  }

  static Future<UgcProgramModel?> loadActiveProgram() async {
    final int? id = activeProgramId;
    if (id == null) return null;
    try {
      final UgcProgramDetailResponse res = await getUgcProgramDetail(id);
      return res.data;
    } on Exception catch (e) {
      log('UgcPlanSync loadActiveProgram: $e');
      return null;
    }
  }

  /// Monday=1 … Sunday=7 (same as DateTime.weekday).
  static UgcProgramDay? dayForDate(UgcProgramModel program, DateTime date) {
    final List<UgcProgramDay> days = program.days ?? [];
    if (days.isEmpty) return null;

    final String dateStr = DateFormat('yyyy-MM-dd').format(date);
    final bool recurring = program.isRecurring != false;

    if (recurring) {
      final int weekday = date.weekday; // 1..7
      for (final UgcProgramDay d in days) {
        if (d.dayOfWeek == weekday) return d;
      }
      return null;
    }

    for (final UgcProgramDay d in days) {
      if (d.specificDate == dateStr) return d;
    }
    return null;
  }

  static List<UgcProgramDay> daysForDates(
    UgcProgramModel program,
    List<DateTime> dates,
  ) {
    final List<UgcProgramDay> out = [];
    for (final DateTime d in dates) {
      final UgcProgramDay? day = dayForDate(program, d);
      if (day != null) out.add(day);
    }
    return out;
  }

  static int glassesFromMl(int? ml) {
    if (ml == null || ml <= 0) return 0;
    return (ml / mlPerGlass).round().clamp(1, 50);
  }

  /// Apply today's plan water/steps goals into progress trackers.
  static Future<void> syncTodayGoals() async {
    if (!userStore.isLoggedIn) return;
    final UgcProgramModel? program = await loadActiveProgram();
    if (program == null) return;

    final UgcProgramDay? today = dayForDate(program, DateTime.now());
    if (today == null) return;

    final String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (today.waterGoalMl != null && today.waterGoalMl! > 0) {
      final int glasses = glassesFromMl(today.waterGoalMl);
      final int waterId = getIntAsync(WATER_TRACK_ID);
      try {
        await setProgressApi({
          if (waterId != 0) 'id': waterId,
          'value': glasses,
          'type': WATER_TRACK,
          'unit': WATER_UNIT,
          'date': date,
        });
      } on Exception catch (e) {
        log('UgcPlanSync water: $e');
      }
    }

    if (today.stepsGoal != null && today.stepsGoal! > 0) {
      final int stepId = getIntAsync(STEP_TRACK_ID);
      final String time = DateFormat('HH:mm:ss').format(DateTime.now());
      try {
        await setProgressApi({
          if (stepId != 0) 'id': stepId,
          'value': today.stepsGoal,
          'type': STEP_TRACK,
          'unit': STEP_UNIT,
          'date': date,
          'time': time,
        });
      } on Exception catch (e) {
        log('UgcPlanSync steps: $e');
      }
    }
  }
}
