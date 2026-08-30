import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../store/app_store.dart';
import '../store/NotificationStore/notification_store.dart';
import '../utils/shared_import.dart';
import 'app_theme.dart';
import 'service/user_service.dart';
import 'store/UserStore/user_store.dart';
import 'utils/registration_data.dart';
import 'dart:io' as io;
AppStore appStore = AppStore();
UserStore userStore = UserStore();
NotificationStore notificationStore = NotificationStore();
LanguageJsonData? selectedServerLanguageData;
List<LanguageJsonData>? defaultServerLanguageData = [];
late Size mq;
late SharedPreferences sharedPreferences;
final navigatorKey = GlobalKey<NavigatorState>();
late BaseLanguage languages;
UserService userService = UserService();
bool mIsEnterKey = false;
int? postId;
String appName = "Train7";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();
  // await initialize(aLocaleLanguageList: languageList());
  appStore.setLanguage(
    sharedPreferences.getString(SELECTED_LANGUAGE_CODE) ?? defaultLanguageCode,
  );

  await Firebase.initializeApp().then((FirebaseApp value) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  });
  initJsonFile();

  setLogInValue();
  defaultAppButtonShapeBorder = RoundedRectangleBorder(
    borderRadius: radius(defaultAppButtonRadius),
  );
  oneSignalData();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notifications',
      channelDescription: 'Basic Notification Channel',
      defaultColor: primaryColor,
      playSound: true,
      importance: NotificationImportance.High,
      locked: true,
      enableVibration: true,
    ),
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      channelDescription: 'Scheduled Notification Channel',
      defaultColor: primaryColor,
      locked: true,
      importance: NotificationImportance.High,
      playSound: true,
      enableVibration: true,
    ),
  ]);
  setTheme();
  if (!getStringAsync(PROGRESS_SETTINGS_DETAIL).isEmptyOrNull) {
    userStore.addAllProgressSettingsListItem(
      jsonDecode(
        getStringAsync(PROGRESS_SETTINGS_DETAIL),
      ).map<ProgressSettingModel>(ProgressSettingModel.fromJson).toList(),
    );
  } else {
    userStore.addAllProgressSettingsListItem(progressSettingList());
  }
  RegistrationData.fetchMacroNutrientData();
  runApp(const MyApp());
}

Future<void> updatePlayerId(String email) async {
  final Map<String, dynamic> req = {
    "player_id": getStringAsync(PLAYER_ID),
    "username": email, // getStringAsync(USERNAME),
    "email": email, // getStringAsync(EMAIL),
  };
  await updateProfileApi(req)
      .then((dynamic value) {
        //
      })
      .catchError((Object error) {
        //
      });
}

class MyApp extends StatefulWidget {
  static String tag = '/MyApp';

  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isCurrentlyOnNoInternet = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      e,
    ) {
      if (e.contains(ConnectivityResult.none)) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        push<void>(const NoInternetScreen());
      } else {
        if (isCurrentlyOnNoInternet) {
          pop();
          isCurrentlyOnNoInternet = false;
          toast(languages.lblInternetIsConnected);
        }
        log('connected');
      }
    });
  }

  @override
  void didChangeDependencies() {

    appStore.setDarkMode(true);
    super.didChangeDependencies();
  }

  @override
  void setState(void Function() fn) {
    if (mounted) {
      super.setState(fn);
    }
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (context) => MaterialApp(
      title: APP_NAME,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      scrollBehavior: SBehavior(),
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:  ThemeMode.dark ,
      localizationsDelegates: const [
        AppLocalizations(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        //AppLocalizations(),
      ],
      localeResolutionCallback: (locale, supportedLocales) => locale,
      supportedLocales: getSupportedLocales(),
      locale: Locale(
        appStore.selectedLanguageCode.validate(value: DEFAULT_LANGUAGE),
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? "");

        if (uri.pathSegments.length == 3 && uri.pathSegments[1] == "post") {
          postId = int.tryParse(uri.pathSegments[2]);

          if (postId != null) {
            return MaterialPageRoute<void>(
              builder: (_) => const SplashScreen(isFromLink: true),
            );
          }
        }
        return null;
      },
    ),
  );
}


class MyHttpOverrides extends io.HttpOverrides {
  @override
  io.HttpClient createHttpClient(io.SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (io.X509Certificate cert, String host, int port) => true;
    return client;
  }
}