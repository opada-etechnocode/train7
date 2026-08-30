import '../utils/shared_import.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';
  final bool isFromLink;
  const SplashScreen({super.key, this.isFromLink = false});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // init();
    Future<void>.delayed(Duration.zero).then((val) {
      _checkNotifyPermission();
    });
  }

  Future<void> init() async {
    await 1.seconds.delay;
    if (!mounted) return;
    if (!getBoolAsync(IS_FIRST_TIME)) {
      const WalkThroughScreen().launch<void>(context, isNewTask: true);
    } else {
      if (userStore.isLoggedIn || !userStore.loginRequired) {
        DashboardScreen(
          isFromLink: widget.isFromLink,
        ).launch<void>(context, isNewTask: true);
      } else {
        const SignInScreen().launch<void>(context, isNewTask: true);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _checkNotifyPermission() async {
    final String versionNo = getStringAsync(
      CURRENT_LAN_VERSION,
      defaultValue: LanguageVersion,
    );
    log("---------59>>>$versionNo");
    await getAppSettingApi().then((value) {
      userStore.setLoginRequired(value.loginEnable?.validate() == "1");
    });
      await getLanguageList(versionNo)
        .then((value) {
          log("---------61>>>${value.data?.length}");
          appStore.setLoading(false);
          if (value.status == true) {
            setValue(CURRENT_LAN_VERSION, value.currentVersionNo.validate().toString());
            if (value.data.validate().isNotEmpty) {
              defaultServerLanguageData = value.data;
              performLanguageOperation(defaultServerLanguageData);
              setValue(LanguageJsonDataRes, value.toJson());
              final bool isSetLanguage =
                  sharedPreferences.getBool(IS_SELECTED_LANGUAGE_CHANGE) ??
                  false;
              if (!isSetLanguage) {
                for (int i = 0; i < value.data.validate().length; i++) {
                  if (value.data![i].isDefaultLanguage == 1) {
                    setValue(
                      SELECTED_LANGUAGE_CODE,
                      value.data![i].languageCode,
                    );
                    setValue(
                      SELECTED_LANGUAGE_COUNTRY_CODE,
                      value.data![i].countryCode,
                    );
                    if (!mounted) return;
                    appStore.setLanguage(
                      value.data![i].languageCode!,
                      context: context,
                    );
                    break;
                  }
                }
              }
            } else {
              defaultServerLanguageData = [];
              selectedServerLanguageData = null;
              setValue(LanguageJsonDataRes, "");
            }
          } else {
            final String getJsonData = getStringAsync(LanguageJsonDataRes);

            if (getJsonData.isNotEmpty) {
              final ServerLanguageResponse languageSettings =
                  ServerLanguageResponse.fromJson(
                    json.decode(getJsonData.trim()),
                  );
              if (languageSettings.data.validate().isNotEmpty) {
                defaultServerLanguageData = languageSettings.data;
                performLanguageOperation(defaultServerLanguageData);
              }
            }
          }
        })
        .catchError((error) {
          appStore.setLoading(false);
          // log(error);
        });
    if (await Permission.notification.isGranted) {
      init();
    } else {
      await Permission.notification.request();
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarIconBrightness: appStore.isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: appStore.isDarkMode
            ? context.scaffoldBackgroundColor
            : whiteColor,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                45.height,
                // Image.asset(ic_splash_logo2, fit: BoxFit.fill),
                //  Image.asset(ic_splash_logo, width: 220, height: 140, fit: BoxFit.fill),
                Image.asset(
                  ic_splash_logo,
                  width: 150,
                  height: 150,
                  fit: BoxFit.fill,
                ),
                20.height,
                Image.asset(
                  name,
                  width: 150,
                  fit: BoxFit.fill,
                ),
                // 16.height,
                // Text(APP_NAME, style: boldTextStyle(size: 26, letterSpacing: 1)),
              ],
            ).center(),
          ],
        ).paddingBottom(10),
      ),
    );
  }
}
