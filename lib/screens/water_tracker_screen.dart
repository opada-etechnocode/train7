import '../utils/shared_import.dart';

enum WaterChartFilter { week, month, year, every }

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int logValue = 0;
  bool editingGoal = false;
  WaterController waterController = WaterController();

  @override
  void initState() {
    super.initState();
    waterController.init();
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
        languages.lblWtrTrack,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
    ),
    body: ValueListenableBuilder(
      valueListenable: waterController.updateUI,
      builder: (context, value, child) => Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Banner
                ValueListenableBuilder(
                  valueListenable: waterController.updateUI,
                  builder: (context, value, child) => Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: appStore.isDarkMode
                          ? Colors.white10
                          : primaryLightColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      waterController.dailyGoal == 0
                          ? languages.lblStpC3
                          : (waterController.dailyGoal -
                                    waterController.consumed) >
                                0
                          ? "${languages.lblOnly} ${waterController.dailyGoal - waterController.consumed} ${languages.lblGoalC1}"
                          : (waterController.dailyGoal -
                                    waterController.consumed) ==
                                0
                          ? languages.lblStpC2
                          : "${languages.lblStpC4} ${(waterController.dailyGoal - waterController.consumed).abs()} ${languages.lblGlasses}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Circular Progress
                      ValueListenableBuilder(
                        valueListenable: waterController.updateUI,
                        builder: (context, value, child) => SizedBox(
                          width: 240,
                          height: 240,
                          child: CircularProgressIndicator(
                            value:
                                (waterController.consumed /
                                        waterController.dailyGoal)
                                    .clamp(0.0, 1.0),
                            strokeWidth: 12,
                            valueColor: const AlwaysStoppedAnimation(
                              primaryColor,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),

                      // Inside content (icon + value + label)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            size: 60,
                            color: primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${waterController.consumed}",
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            languages.lblGlasses,
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

                // Counter With + / -
                ValueListenableBuilder(
                  valueListenable: waterController.updateUI,
                  builder: (context, value, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _roundBtn(Icons.remove, () {
                        if (logValue > 0) logValue--;
                        waterController.updateUI.value++;
                      }),
                      const SizedBox(width: 20),
                      Text(
                        "$logValue",
                        style: primaryTextStyle(
                          size: 20,
                          color: appStore.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 20),
                      _roundBtn(Icons.add, () {
                        logValue++;
                        waterController.updateUI.value++;
                      }),
                    ],
                  ).paddingOnly(top: 20),
                ),

                // Log Now button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 40,
                    ),
                  ),
                  onPressed: () async {
                    if (waterController.dailyGoal == 0) {
                      toast(languages.lblStpC3);
                    } else {
                      if (logValue > 0) {
                        final int total = waterController.consumed + logValue;
                        final currentDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateTime.now());
                        final currentTime = DateFormat(
                          'HH:mm:ss',
                        ).format(DateTime.now());
                        final Map<String, dynamic> req = {
                          "value": total,
                          "date": currentDate,
                          "time": currentTime,
                        };
                        await setUserDailyWaterGoalApi(req).whenComplete(() {
                          logValue = 0;
                          waterController.updateUI.value++;
                        });
                        await waterController.init();
                      } else {
                        toast(languages.valueGreaterZero);
                      }
                    }
                  },
                  child: Text(
                    languages.lblLogNw,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ).paddingOnly(bottom: 20, top: 10),

                // --- DAILY GOAL CARD ---
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
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
                              setState(() => editingGoal = !editingGoal);
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Either show text OR input field
                      editingGoal
                          ? Column(
                              children: [
                                const SizedBox(height: 8),
                                TextField(
                                  controller: waterController.goalCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.black,
                                    hintText: languages.lblEnrGls,
                                    contentPadding: const EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.orange,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      editingGoal = false;
                                    });
                                    await waterController.saveGoal();
                                  },
                                  child: Text(languages.lblSave),
                                ),
                              ],
                            )
                          : Text(
                              "${waterController.dailyGoal} ${languages.lblGlasses}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                waterController.logList.isNotEmpty &&
                        waterController.dailyGoal != 0
                    ? Container(
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
                            /* Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: WaterChartFilter.values.map((e) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: ChoiceChip(
                                          label: Text(
                                            e.name.capitalizeFirstLetter(),
                                            style: primaryTextStyle(
                                              color: waterController.currentFilter == e
                                                  ? white
                                                  : primaryColor,
                                            ),
                                          ),
                                          selected: waterController.currentFilter == e,
                                          selectedColor: primaryColor,
                                          onSelected: (_) {
                                            setState(() {
                                              waterController.applyFilter(e);
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  languages.lblWtrConsDaily,
                                  style: boldTextStyle(
                                    size: 17,
                                    color: primaryColor,
                                  ),
                                ),
                                DropdownButton<WaterChartFilter>(
                                  value: waterController.currentFilter,
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
                                      waterController.applyFilter(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                            CommonColumnChart(
                              yAxisTitle: languages.lblGlasses,
                              tooltipUnit: languages.lblGlasses,
                              data: waterController.logList,
                              achievedLabel: languages.lblConsumed,
                              goalLabel: languages.lblGoal,
                              yInterval: 2,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 30),
              ],
            ),
          ),
          if (waterController.isLoading)
            const Center(child: CircularProgressIndicator(color: primaryColor)),
        ],
      ),
    ),
  );

  // Reusable round button
  Widget _roundBtn(IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    ),
  );
}
