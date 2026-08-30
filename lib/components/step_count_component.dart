import 'package:daily_pedometer2/daily_pedometer2.dart';

import '../service/health_service.dart';
import '../utils/shared_import.dart';
import 'health_permission_dialog.dart';

class StepCountComponent extends StatefulWidget {
  static String tag = '/StepCountComponent';

  const StepCountComponent({super.key});

  @override
  StepCountComponentState createState() => StepCountComponentState();
}

class StepCountComponentState extends State<StepCountComponent> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  StepController stepController = StepController();

  String _status = '?';

  bool? isError = false;

  @override
  void initState() {
    super.initState();
    //init();
  }

  Future<void> init() async {
    if (Platform.isAndroid) {
      initPlatformState();
    } else {
      await getTodayHealthSteps();
    }
  }

  Future<void> getTodayHealthSteps() async {
    // Request necessary permissions (for Android)
    await Permission.activityRecognition.request();
    await Permission.location.request();
    // Create and configure health instance
    final health = Health();
    await health.configure();
    // Define the data types to request
    final types = [HealthDataType.STEPS];
    // Request read permissions
    final bool requested = await health.requestAuthorization(types);
    if (!requested) {
      log("Authorization failed");
      return;
    }
    // Get today's midnight time
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    // Fetch today's step count using getTotalStepsInInterval
    final int? totalSteps = await health.getTotalStepsInInterval(midnight, now);
    log("TODAY'S STEPS: $totalSteps");
    setState(() {
      log("------------50>>>${getStringAsync(ISSTEP)}");
      if (getStringAsync(ISSTEP) == 'newUser') {
        initialSteps = totalSteps ?? 0;
        userStore.setIsSTEP('oldUser');
      }
      /* if (initialSteps == 0) {
          initialSteps = event.steps;
        }*/

      // _steps = event.steps.toString();
    });
    // You can update UI or state here with totalSteps
  }

  void onStepCount(StepCount event) {
    if (mounted) {
      setState(() {
        log("------------50>>>${getStringAsync(ISSTEP)}");
        if (getStringAsync(ISSTEP) == 'newUser') {
          initialSteps = event.steps;
          userStore.setIsSTEP('oldUser');
        }
        /* if (initialSteps == 0) {
          initialSteps = event.steps;
        }*/

        // _steps = event.steps.toString();
      });
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    log(event.toString());
    if (mounted) {
      setState(() {
        _status = event.status;
      });
    }
  }

  void onPedestrianStatusError(Object error) {
    log('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    log(_status);
  }

  void onStepCountError(Object error) {
    log('onStepCountError: $error');
    setState(() {
      isError = true;
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = DailyPedometer2.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = DailyPedometer2.dailyStepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    decoration: appStore.isDarkMode
        ? boxDecorationWithRoundedCorners(
            borderRadius: radius(16),
            backgroundColor: context.cardColor,
          )
        : boxDecorationRoundedWithShadow(
            16,
            backgroundColor: context.cardColor,
          ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(8),
                backgroundColor: appStore.isDarkMode
                    ? Colors.black
                    : Colors.white,
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                ic_step,
                width: 22,
                height: 22,
                color: primaryColor,
              ),
            ),
            Text(
              languages.lblSteps,
              style: boldTextStyle(
                color: appStore.isDarkMode ? primaryColor : black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
        10.height,
        Image.asset(ic_running, width: 50, height: 50, color: primaryColor),
        8.height,
        FutureBuilder(
            future: HealthService().hasStepPermission(),
            builder: (context, snapshot) {
              bool isAuthorized = snapshot.data ?? true;
              if (Platform.isAndroid) isAuthorized = true;
            return ValueListenableBuilder(
              valueListenable: stepController.steps,
              builder: (context, value, child) {
                if (!isAuthorized && Platform.isIOS) {
                  return AppButton(
                    text: "Connect Apple Health",
                    color: primaryColor,
                    textStyle: boldTextStyle(color: white),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => HealthPermissionDialog(
                          onConnect: () async {
                            bool granted = await HealthService().requestHealthPermission();
                            if (granted) {
                              stepController.syncHealthSteps();
                              setState(() {});
                            }
                          },
                        ),
                      );
                    },
                  ).paddingSymmetric(vertical: 8);
                }
                return Text("$value", style: boldTextStyle(size: 22)).center();
              },
            );
          }
        ),
        //isError == true ? Text(_steps, style: secondaryTextStyle()).paddingSymmetric(vertical: 8).center() : Text(_steps, style: boldTextStyle(size: 22)).center(),
        FutureBuilder<bool>(
            future: HealthService().hasStepPermission(),
            builder: (context, snapshot) {
              bool isAuthorized = snapshot.data ?? true;
              if (Platform.isAndroid) isAuthorized = true;
              return Text(languages.lblSteps, style: secondaryTextStyle()).center().visible(isError != true && isAuthorized);
            }
        ),
        if (Platform.isIOS)
          Text(languages.lblDatafromapplehealth, style: secondaryTextStyle(size: 10)).paddingTop(4).center(),
      ],
    ),
  );
}
