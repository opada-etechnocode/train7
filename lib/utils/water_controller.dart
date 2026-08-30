import 'shared_import.dart';

class WaterController {
  bool isLoading = false;
  int dailyGoal = 0;
  int consumed = 0;
  TextEditingController goalCtrl = TextEditingController();
  List<WaterGraphData> logList = [];
  ValueNotifier<int> updateUI = ValueNotifier(0);
  WaterChartFilter currentFilter = WaterChartFilter.week;

  Future<void> init() async {
    await syncGoal();
    await getGoal();
    await getLogs();
  }

  Future<void> applyFilter(WaterChartFilter filter) async {
    currentFilter = filter;
    setLoading(true);
    final WaterGraph res = await getUserDailyWaterGraph(
      filter: currentFilter.name.toString(),
    );
    logList = res.data ?? [];
    setLoading(false);
  }

  Future<void> getLogs() async {
    setLoading(true);
    final WaterGraph res = await getUserDailyWaterGraph();
    logList = res.data ?? [];
    logList.sort(
      (a, b) => DateTime.parse(
        a.date.validate(),
      ).compareTo(DateTime.parse(b.date.validate())),
    );
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    consumed = (logList.isNotEmpty)
        ? logList
              .firstWhere(
                (e) => e.date == today,
                orElse: () => WaterGraphData(date: today, value: 0),
              )
              .value
              .validate()
        : 0;
    setLoading(false);
  }

  Future<void> syncGoal() async {
    setLoading(true);
    try {
      final graph = await getUserGraphApi(WATER_TRACK);
      setLoading(false);
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (graph.data?.date != today && graph.data != null) {
        final req = {
          "value": graph.data!.value,
          "type": WATER_TRACK,
          "unit": WATER_UNIT,
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
    final GraphResponse graph = await getProgressApi(WATER_TRACK);
    if (graph.data!.isNotEmpty && graph.data != null) {
      final data = graph.data!.first;
      await setValue(WATER_TRACK_ID, data.id);
      dailyGoal = int.tryParse(data.value ?? '0') ?? 0;
      goalCtrl.text = dailyGoal.toString();
    } else {
      dailyGoal = 0;
      await setValue(WATER_TRACK_ID, 0);
    }
    setLoading(false);
  }

  Future<void> saveGoal() async {
    dailyGoal = int.tryParse(goalCtrl.text) ?? dailyGoal;

    final id = getIntAsync(WATER_TRACK_ID);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setLoading(true);

    await setProgressApi({
      if (id != 0) "id": id,
      "value": dailyGoal,
      "type": WATER_TRACK,
      "unit": WATER_UNIT,
      "date": today,
    });

    await getGoal();
    await getLogs();
    setLoading(false);
  }

  Future<void> setDefaultGoal() async {
    dailyGoal = 10;
    goalCtrl.text = dailyGoal.toString();

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setLoading(true);

    await setProgressApi({
      "value": dailyGoal,
      "type": WATER_TRACK,
      "unit": WATER_UNIT,
      "date": today,
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
