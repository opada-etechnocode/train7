import '../utils/shared_import.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';
  final bool isFromLink;
  const SplashScreen({super.key, this.isFromLink = false});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, _bootstrap);
  }

  Future<void> _bootstrap() async {
    // Cap total wait so splash never hangs on network / permissions
    await Future.any<void>([
      _warmup(),
      Future<void>.delayed(const Duration(seconds: 2)),
    ]);
    await _goNext();
  }

  Future<void> _warmup() async {
    try {
      final AppSettingResponse value = await getAppSettingApi().timeout(
        const Duration(seconds: 2),
      );
      await userStore.setLoginRequired(value.loginEnable?.validate() == '1');
    } catch (e) {
      log('getAppSettingApi: $e');
    }

    defaultServerLanguageData = localLanguages;
    performLanguageOperation(defaultServerLanguageData);
    appStore.setLoading(false);

    // Never block splash on the notification dialog
    unawaited(() async {
      try {
        if (!await Permission.notification.isGranted) {
          await Permission.notification.request();
        }
      } catch (e) {
        log('notification permission: $e');
      }
    }());
  }

  Future<void> _goNext() async {
    if (_navigated || !mounted) return;
    _navigated = true;

    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    if (!getBoolAsync(IS_FIRST_TIME)) {
      const WalkThroughScreen().launch<void>(context, isNewTask: true);
    } else if (userStore.isLoggedIn || !userStore.loginRequired) {
      DashboardScreen(
        isFromLink: widget.isFromLink,
      ).launch<void>(context, isNewTask: true);
    } else {
      const SignInScreen().launch<void>(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
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
              ],
            ).center(),
          ],
        ).paddingBottom(10),
      ),
    );
  }
}
