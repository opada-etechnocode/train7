import '../utils/shared_import.dart';

class StepsCountScreen extends StatefulWidget {
  const StepsCountScreen({super.key});

  @override
  State<StepsCountScreen> createState() => _StepsCountScreenState();
}

class _StepsCountScreenState extends State<StepsCountScreen> {
  bool editingGoal = false;
  bool isLoading = true;
  StepController stepController = StepController();

  @override
  void initState() {
    super.initState();
    stepController.init().whenComplete(() async {
      isLoading = false;
      stepController.updateUI.value++;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: appStore.isDarkMode ? Colors.black : primaryOpacity,
    appBar: AppBar(
      backgroundColor: appStore.isDarkMode ? cardDarkColor : primaryOpacity,
      elevation: 0,
      leading: const IconButton(
        icon: Icon(Icons.arrow_back, color: primaryColor),
        onPressed: pop,
      ),
      title: Text(
        languages.lblStpTrack,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
    ),

    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder(
        valueListenable: stepController.updateUI,
        builder: (context, value, child) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(top: 10, bottom: 25),
              decoration: BoxDecoration(
                color: appStore.isDarkMode
                    ? Colors.white10
                    : primaryLightColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                stepController.dailyGoal == 0
                    ? languages.lblStpC3
                    : (stepController.dailyGoal - stepController.steps.value) >
                          0
                    ? "${languages.lblOnly} ${(stepController.dailyGoal - stepController.steps.value)} ${languages.lblStpC1}"
                    : (stepController.dailyGoal - stepController.steps.value) ==
                          0
                    ? languages.lblStpC2
                    : "${languages.lblStpC4} ${(stepController.dailyGoal - stepController.steps.value).abs()} ${languages.lblSteps}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: stepController.steps,
              builder: (context, value, child) => SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value:
                            (stepController.steps.value /
                                    stepController.dailyGoal)
                                .clamp(0.0, 1.0),
                        strokeWidth: 12,
                        valueColor: const AlwaysStoppedAnimation(primaryColor),
                        backgroundColor: Colors.white,
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.directions_run_sharp,
                          size: 60,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${stepController.steps.value}",
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          //"Steps",
                          languages.lblSteps,
                          style: TextStyle(
                            fontSize: 16,
                            color: appStore.isDarkMode
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
 20.height,
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryLightColor, primaryColor],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.water_drop, color: Colors.black),
                          const SizedBox(width: 8),
                          Text(
                            languages.lblDG,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          log("✏ Editing daily goal");
                          editingGoal = !editingGoal;
                          stepController.updateUI.value++;
                        },
                        child: Icon(
                          stepController.dailyGoal == 0
                              ? Icons.add
                              : Icons.edit,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  editingGoal
                      ? Column(
                          children: [
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 150,
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: stepController.dailyGoal == 0
                                      ? 0
                                      : (stepController.dailyGoal ~/ 1000) - 1,
                                ),
                                itemExtent: 40,
                                onSelectedItemChanged: (index) {
                                  stepController.dailyGoal = (index + 1) * 1000;
                                  stepController.updateUI.value++;
                                },
                                children: List.generate(
                                  100, // gives 1000 → 100000
                                  (i) => Center(
                                    child: Text(
                                      "${(i + 1) * 1000}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.orange,
                              ),
                              onPressed: () async {
                                editingGoal = false;
                                stepController.updateUI.value++;
                                final now = DateTime.now();
                                final today =
                                    "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                                final int id = getIntAsync(STEP_TRACK_ID);
                                stepController.setLoading(true);
                                final req = {
                                  "id": id,
                                  "value": stepController.dailyGoal != 0
                                      ? stepController.dailyGoal
                                      : 1000,
                                  "type": STEP_TRACK,
                                  "unit": STEP_UNIT,
                                  "date": today,
                                };
                                await setProgressApi(req).whenComplete(
                                  () async {
                                    stepController.setLoading(false);
                                    await stepController.init();
                                  },
                                );
                              },
                              child: Text(
                                languages.lblSave,
                                style: boldTextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          stepController.dailyGoal == 0
                              ? ""
                              : "${stepController.dailyGoal} ${languages.lblSteps}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            stepController.logList.isNotEmpty && stepController.dailyGoal != 0
                ? ValueListenableBuilder(
                    valueListenable: stepController.updateUI,
                    builder: (context, value, child) => Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appStore.isDarkMode
                            ? Colors.black
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languages.lblSteps,
                                style: boldTextStyle(
                                  size: 17,
                                  color: primaryColor,
                                ),
                              ),
                              DropdownButton<WaterChartFilter>(
                                value: stepController.currentFilter,
                                underline: Container(),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: primaryColor,
                                ),
                                items: WaterChartFilter.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.name.capitalizeFirstLetter(),
                                          style: primaryTextStyle(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() {
                                    stepController.applyFilter(value);
                                  });
                                },
                              ),
                            ],
                          ),
                          CommonColumnChart(
                            yAxisTitle: languages.lblSteps,
                            tooltipUnit: languages.lblSteps,
                            data: stepController.logList,
                            achievedLabel: languages.lblAchived,
                            goalLabel: languages.lblGoal,
                            yInterval: 1000,
                          ),
                        ],
                      ),
                    ),
                  )
                : isLoading
                ? const CircularProgressIndicator(color: primaryColor)
                : const SizedBox(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}
