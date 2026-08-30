import '../utils/shared_import.dart';

class ProgressSettingScreen extends StatefulWidget {
  static String tag = '/ProgressSetting';

  const ProgressSettingScreen({super.key});

  @override
  ProgressSettingScreenState createState() => ProgressSettingScreenState();
}

class ProgressSettingScreenState extends State<ProgressSettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(languages.lblMetricsSettings, context: context),
    body: Observer(
      builder: (context) => AnimatedListView(
        itemCount: userStore.mProgressList.length,
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          userStore.mProgressList.sort((a, b) => a.id!.compareTo(b.id!));
          final ProgressSettingModel data = userStore.mProgressList[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: data.isEnable == true
                  ? primaryColor
                  : appStore.isDarkMode
                  ? context.scaffoldBackgroundColor
                  : cardLightColor,
              border: Border.all(
                color: data.isEnable == true
                    ? primaryColor.withValues(alpha: 0.80)
                    : GreyLightColor,
              ),
            ),
            child:
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.name.validate(),
                          style: boldTextStyle(
                            color: data.isEnable == true
                                ? Colors.white
                                : appStore.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        data.isEnable == true
                            ? Image.asset(
                                ic_radio_fill,
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              )
                            : Image.asset(
                                ic_radio,
                                color: primaryColor,
                                height: 20,
                                width: 20,
                              ),
                      ],
                    ),
                    4.height,
                    // Divider(),
                  ],
                ).paddingSymmetric(vertical: 4).onTap(() async {
                  final ProgressSettingModel mSetting = ProgressSettingModel();
                  mSetting.id = data.id;
                  mSetting.name = data.name;
                  mSetting.isEnable =
                      userStore.mProgressList[index].isEnable == true
                      ? false
                      : true;
                  userStore.updateProgress(mSetting);
                  LiveStream().emit(PROGRESS_SETTING);
                  setState(() {});
                }),
          );
        },
      ),
    ),
  );
}
