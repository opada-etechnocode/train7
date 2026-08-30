import 'package:daily_pedometer2/daily_pedometer2.dart';

import '../service/health_service.dart';
import 'shared_import.dart';

class StepController {
  static final StepController _instance = StepController._internal();
  factory StepController() => _instance;
  StepController._internal();
  bool isLoading = false;

  WaterChartFilter currentFilter = WaterChartFilter.week;

  ValueNotifier<int> updateUI = ValueNotifier(0);

  /// TODAY steps only
  final ValueNotifier<int> steps = ValueNotifier<int>(0);
  final ValueNotifier<int> totalSteps = ValueNotifier<int>(0);

  List<WaterGraphData> logList = [];

  StreamSubscription<StepCount>? _dailyStepSubscription;
  StreamSubscription<StepCount>? _totalStepSubscription;
  DateTime? _lastApiCallTime;

  Timer? _healthSyncTimer;

  Timer? _inactivityTimer;
  int _lastStepsSent = 0;

  int? _pedometerBaseline;
  int _sessionBaselineValue = 0;

  static const int inactivitySeconds = 10; // tweak as needed

  int dailyGoal = 0;

  /// Start pedometer (daily steps only)
  void start() {
    if (_dailyStepSubscription != null) return;
    if (_totalStepSubscription != null) return;

    _dailyStepSubscription = DailyPedometer2.dailyStepCountStream.listen(
      onDailyStepCount,
      onError: (Object e) => debugPrint("Daily step error: $e"),
    );
    _totalStepSubscription = DailyPedometer2.stepCountStream.listen(
      totalStepsCount,
      onError: (Object e) => debugPrint("Total step error: $e"),
    );
    if (Platform.isIOS) {
      _startHealthSyncTimer();
    }
  }

  void _startHealthSyncTimer() {
    _healthSyncTimer?.cancel();
    _healthSyncTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      syncHealthSteps();
    });
    syncHealthSteps(); // Initial sync
  }

  Future<void> syncHealthSteps() async {
    if (Platform.isIOS) {
      bool isAuthorized = await HealthService().hasStepPermission();
      if (isAuthorized) {
        int healthSteps = await HealthService().getTodaySteps();
        if (healthSteps > 0) {
          steps.value = healthSteps;
          _tryPeriodicApiCall(healthSteps);
        }
      }
    }
  }
  Future<void> totalStepsCount(StepCount event) async {
    debugPrint('----Total Steps---${event.steps}-----');
    totalSteps.value = event.steps;
  }

  Future<void> applyFilter(WaterChartFilter filter) async {
    currentFilter = filter;
    setLoading(true);
    final WaterGraph res = await getUserDailyStepGraph(
      filter: currentFilter.name.toString(),
    );
    logList = res.data ?? [];
    setLoading(false);
  }

  /// DAILY steps callback
  void onDailyStepCount(StepCount event) {
    if (dailyGoal == 0) return;

    if (event.steps <= 0) return;

    if (_pedometerBaseline == null) {
      _pedometerBaseline = event.steps;
      _sessionBaselineValue = steps.value;
      debugPrint(
        '🆕 Pedometer baseline set: $_pedometerBaseline, current steps: $_sessionBaselineValue',
      );
    }

    int delta = event.steps - _pedometerBaseline!;
    if (delta < 0) {
      // Pedometer might have reset (reboot?) - adjust baseline
      _pedometerBaseline = event.steps;
      _sessionBaselineValue = steps.value;
      setValue(PEDOMETER_BASELINE, _pedometerBaseline);
      setValue(SESSION_STEPS_BASELINE, _sessionBaselineValue);
      delta = 0;
    }

    steps.value = _sessionBaselineValue + delta;

    /// Update persistence for session continuity
    setValue(PEDOMETER_BASELINE, _pedometerBaseline);
    setValue(SESSION_STEPS_BASELINE, _sessionBaselineValue);

    /// Reset inactivity timer
    _resetInactivityTimer();

    /// Optional: still keep periodic API call (2 min)
    _tryPeriodicApiCall(steps.value);
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    if (dailyGoal == 0) return;

    _inactivityTimer = Timer(
      const Duration(seconds: inactivitySeconds),
      () async {
        debugPrint('🛑 User stopped walking');

        /// Avoid duplicate API calls
        if (steps.value == _lastStepsSent) return;

        _lastStepsSent = steps.value;

        final now = DateTime.now();

        await setDailyStepsGoalApi({
          "value": steps.value,
          "date": DateFormat('yyyy-MM-dd').format(now),
          "time": DateFormat('HH:mm:ss').format(now),
        });

        await getLogs();
      },
    );
  }

  Future<void> _tryPeriodicApiCall(int stepValue) async {
    if (dailyGoal == 0) return;

    final now = DateTime.now();

    if (_lastApiCallTime == null ||
        now.difference(_lastApiCallTime!).inMinutes >= 1) {
      _lastApiCallTime = now;
      _lastStepsSent = stepValue;

      await setDailyStepsGoalApi({
        "value": stepValue,
        "date": DateFormat('yyyy-MM-dd').format(now),
        "time": DateFormat('HH:mm:ss').format(now),
      });
      await getLogs();
    }
  }

  Future<void> getLogs() async {
    setLoading(true);
    final WaterGraph res = await getUserDailyStepGraph();
    logList = res.data ?? [];
    logList.sort(
      (a, b) => DateTime.parse(
        a.date.validate(),
      ).compareTo(DateTime.parse(b.date.validate())),
    );
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final int serverSteps = (logList.isNotEmpty)
        ? logList
              .firstWhere(
                (e) => e.date == today,
                orElse: () => WaterGraphData(date: today, value: 0),
              )
              .value
              .validate()
        : 0;

    // Only update if server has more steps (ensures no "jumping back" to stale data)
    if (serverSteps > steps.value) {
      debugPrint('⬆️ Server has more steps ($serverSteps) than local (${steps.value}). Syncing...');
      steps.value = serverSteps;

      // Only update offsets if we don't have a local baseline context yet.
      // If we DO have a baseline, the daily delta is already being calculated 
      // relative to it, and overriding it would cause double-counting or data loss.
      if (_pedometerBaseline == null) {
        _sessionBaselineValue = serverSteps;
        setValue(PEDOMETER_BASELINE, -1);
        setValue(SESSION_STEPS_BASELINE, _sessionBaselineValue);
        debugPrint('🔄 Local baseline was null. Set session baseline to $serverSteps');
      } else {
        debugPrint('ℹ️ Local baseline exists ($_pedometerBaseline). Trusting sensor delta over server sync.');
      }
    }
    setLoading(false);
  }

  Future<void> syncGoal() async {
    setLoading(true);
    try {
      final graph = await getUserGraphApi(STEP_TRACK);
      setLoading(false);
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (graph.data?.date != today && graph.data != null) {
        final req = {
          "value": graph.data!.value,
          "type": STEP_TRACK,
          "unit": STEP_UNIT,
          "date": today,
        };
        await setProgressApi(req);
      }
    } on Exception catch (_) {
      setLoading(false);
    }
  }

  Future<void> getGoal() async {
    setLoading(true);
    final GraphResponse graph = await getProgressApi(STEP_TRACK);
    if (graph.data != null && graph.data!.isNotEmpty) {
      final data = graph.data!.first;
      await setValue(STEP_TRACK_ID, data.id);
      dailyGoal = int.tryParse(data.value ?? '0') ?? 0;
    } else {
      // Protect existing goal from being reset to 0 by transient API failures
      if (dailyGoal == 0) {
        await setValue(STEP_TRACK_ID, 0);
      }
    }
    setLoading(false);
  }

  Future<void> init() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastSyncDate = getStringAsync(LAST_STEP_SYNC_DATE);

    if (lastSyncDate == today) {
      _pedometerBaseline = getIntAsync(PEDOMETER_BASELINE, defaultValue: -1);
      if (_pedometerBaseline == -1) _pedometerBaseline = null;
      _sessionBaselineValue = getIntAsync(SESSION_STEPS_BASELINE, defaultValue: 0);
      debugPrint('🔄 Loaded persisted baseline: $_pedometerBaseline, session: $_sessionBaselineValue');
    } else {
      debugPrint('🆕 New day detected, resetting persistent baselines');
      setValue(LAST_STEP_SYNC_DATE, today);
      setValue(PEDOMETER_BASELINE, -1);
      setValue(SESSION_STEPS_BASELINE, 0);
    }

    await syncGoal();
    await getGoal();
    await getLogs();
  }

  void clear() {
    steps.value = 0;
    totalSteps.value = 0;
    dailyGoal = 0;
    logList = [];
    _lastStepsSent = 0;
    _lastApiCallTime = null;
    _pedometerBaseline = null;
    _sessionBaselineValue = 0;

    setValue(PEDOMETER_BASELINE, -1);
    setValue(SESSION_STEPS_BASELINE, 0);

    updateUI.value++;
  }

  void dispose() {
    _dailyStepSubscription?.cancel();
    _dailyStepSubscription = null;
  }

  Future<void> setDefaultGoal() async {
    dailyGoal = 1000;
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm:ss').format(now);

    setLoading(true);

    await setProgressApi({
      "value": dailyGoal,
      "type": STEP_TRACK,
      "unit": STEP_UNIT,
      "date": today,
      "time": time,
    });

    await getGoal();
    await getLogs();
    setLoading(false);
  }

  void setLoading(bool value) {
    isLoading = value;
    updateUI.value++;
  }
}
