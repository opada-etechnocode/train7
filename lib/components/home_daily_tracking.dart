import '../service/health_service.dart';
import '../components/health_permission_dialog.dart';
import '../utils/shared_import.dart';
import '../widget/tracking_card.dart';

class HomeDailyTracking extends StatelessWidget {
  final StepController stepController;
  final WaterController waterController;

  const HomeDailyTracking({
    super.key,
    required this.stepController,
    required this.waterController,
  });

  void _showHealthPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => HealthPermissionDialog(
        onConnect: () async {
          bool granted = await HealthService().requestHealthPermission();
          if (granted) {
            stepController.syncHealthSteps();
            stepController.updateUI.value++;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: stepController.updateUI,
      builder: (context, value, child) {
        final bool isDark = appStore.isDarkMode;
        final Color cardBg =
            isDark ? const Color(0xFF151A22) : context.cardColor;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 18,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  8.width,
                  Text(
                    languages.lblDailyTracking,
                    style: boldTextStyle(size: 16),
                  ),
                ],
              ),
            ),
            12.height,
            ValueListenableBuilder(
              valueListenable: waterController.updateUI,
              builder: (context, value, child) =>
                  ((stepController.dailyGoal == 0 ||
                          waterController.dailyGoal == 0) &&
                      userStore.isLoggedIn &&
                      !stepController.isLoading &&
                      !waterController.isLoading)
                  ? GestureDetector(
                      onTap: () => _showGoalSettingsDialog(context),
                      child: Container(
                        width: context.width(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                languages.lblSetGoalInsights,
                                style: boldTextStyle(
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 16)
                  : const SizedBox.shrink(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: waterController.updateUI,
                  builder: (context, value, child) => GestureDetector(
                    onTap: () {
                      if (userStore.isLoggedIn) {
                        const WaterTrackerScreen()
                            .launch<void>(context)
                            .then((value) {
                          waterController.init();
                        });
                      } else {
                        const SignInScreen().launch<void>(context);
                      }
                    },
                    child: trackingCard(
                      background: cardBg,
                      progressColor: const Color(0xFF18A6FF),
                      subtitle: languages.lblWtrInt,
                      value: '${waterController.consumed}',
                      label: languages.lblGlass,
                      progress: waterController.dailyGoal > 0
                          ? (waterController.consumed /
                                  waterController.dailyGoal)
                              .clamp(0.0, 1.0)
                          : 0.0,
                      icon: Icons.water_drop,
                      sparklineValues: buildSparklinePoints(
                        logList: waterController.logList,
                        currentValue: waterController.consumed,
                        dailyGoal: waterController.dailyGoal,
                      ),
                      sparklineStartLabel: '00:00',
                      sparklineEndLabel: '24:00',
                    ),
                  ),
                ).expand(),
                const SizedBox(width: 12),
                FutureBuilder<bool>(
                  future: HealthService().hasStepPermission(),
                  builder: (context, permissionSnapshot) =>
                      ValueListenableBuilder<int>(
                    valueListenable: stepController.steps,
                    builder: (context, steps, _) {
                      bool isAuthorized = permissionSnapshot.data ?? true;
                      if (Platform.isAndroid) isAuthorized = true;
                      final double dailyGoal = double.parse(
                        stepController.dailyGoal.toString(),
                      );
                      final double progress = dailyGoal > 0
                          ? (steps / dailyGoal).clamp(0.0, 1.0)
                          : 0.0;

                      return GestureDetector(
                        onTap: () {
                          if (!isAuthorized && Platform.isIOS) {
                            _showHealthPermissionDialog(context);
                          } else {
                            if (userStore.isLoggedIn) {
                              const StepsCountScreen()
                                  .launch<void>(context)
                                  .then((value) {
                                stepController.updateUI.value++;
                              });
                            } else {
                              const SignInScreen().launch<void>(context);
                            }
                          }
                        },
                        child: trackingCard(
                          background: cardBg,
                          progressColor: const Color(0xFFFF7A2B),
                          subtitle: languages.lblStpCnt,
                          value: isAuthorized
                              ? '$steps'
                              : languages.lblConnectAppleHealth,
                          label: isAuthorized ? languages.lblSteps : '',
                          progress: isAuthorized ? progress : 0.0,
                          icon: Icons.directions_walk,
                          footerHint: Platform.isIOS
                              ? languages.lblStepDataFromAppleHealth
                              : null,
                          sparklineValues: buildSparklinePoints(
                            logList: stepController.logList,
                            currentValue: steps,
                            dailyGoal: stepController.dailyGoal,
                          ),
                          sparklineStartLabel: '00:00',
                          sparklineEndLabel: '24:00',
                        ),
                      );
                    },
                  ),
                ).expand(),
              ],
            ).paddingSymmetric(horizontal: 16),
          ],
        );
      },
    );

  void _showGoalSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languages.lblSetGoalInsights),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (waterController.dailyGoal == 0)
              ListTile(
                leading: const Icon(Icons.water_drop, color: Color(0xFF18A6FF)),
                title: Text(languages.lblSetWaterGoal),
                onTap: () {
                  finish(context);
                  const WaterTrackerScreen().launch<void>(context).then((value) {
                    waterController.init();
                  });
                },
              ),
            if (stepController.dailyGoal == 0)
              ListTile(
                leading: const Icon(Icons.directions_walk, color: Color(0xFFFF7A2B)),
                title: Text(languages.lblSetStepGoal),
                onTap: () {
                  finish(context);
                  const StepsCountScreen().launch<void>(context).then((value) {
                    stepController.updateUI.value++;
                  });
                },
              ),
            16.height,
            Text(
              "If you skip, we’ll set a default goal for you. You can change it anytime.", // todo
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              finish(context);
              if (waterController.dailyGoal == 0) {
                await waterController.setDefaultGoal();
              }
              if (stepController.dailyGoal == 0) {
                await stepController.setDefaultGoal();
              }
            },
            child: Text(languages.lblSkip),
          ),
        ],
      ),
    );
  }
}

