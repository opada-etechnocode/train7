import '../utils/shared_import.dart';

bool? isFirstTime = false;
AppVersion? appUpdateCheck;

class DashboardScreen extends StatefulWidget {
  final bool isFromLink;

  const DashboardScreen({super.key, this.isFromLink = false});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int mCurrentIndex = 0;
  int mCounter = 0;

  List<Widget> get tab => [
    const HomeScreen(),
    const DietScreen(),
    const ProductScreen(),
    userStore.isLoggedIn
        ? const CommunityScreen()
        : const SignInScreen(showBack: false),
    userStore.isLoggedIn
        ? const ScheduleScreen()
        : const SignInScreen(showBack: false),
    userStore.isLoggedIn ? const PlanScreen() : const SignInScreen(showBack: false),
  ];

  List<BottomBarItemModel> bottomItemList = [
    BottomBarItemModel(
      iconData: ic_home_outline,
      selectedIconData: ic_home_fill,
      labelText: languages.lblHome,
    ),
    BottomBarItemModel(
      iconData: ic_diet_outline,
      selectedIconData: ic_diet_fill,
      labelText: languages.lblDiet,
    ),
    BottomBarItemModel(
      iconData: ic_store_outline,
      selectedIconData: ic_store_fill,
      labelText: languages.lblShop,
    ),
    BottomBarItemModel(
      iconData: ic_community2,
      selectedIconData: ic_community_filled,
      labelText: languages.lblCommunity,
    ),
    BottomBarItemModel(
      iconData: ic_schedule,
      selectedIconData: ic_fill_schedule,
      labelText: languages.lblSchedule,
    ),
    BottomBarItemModel(
      iconData: ic_user,
      selectedIconData: ic_user_fill_icon,
      labelText: languages.lblProfile,
    ),
  ];

  @override
  void initState() {
    super.initState();

    init();
    LiveStream().on("LANGUAGE", (dynamic s) {
      setState(() {});
    });
    handleColdStartNotification();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppRuntime.isUiReady = true;
    });
  }

  Future<void> init() async {
    if (widget.isFromLink) {
      debugPrint('----isFromLink----${widget.isFromLink}---');
      mCurrentIndex = 3;
      final PostDetailModel postDetailModel = await getPostDetailApi(
        postId: postId ?? 0,
      );
      if (!mounted) return;
      PostDetailsScreen(postData: postDetailModel.data).launch<void>(context);
      debugPrint('----mCurrentIndex----$mCurrentIndex---');
    }
    _getAppName();
    //
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(
          MediaQuery.of(context).platformBrightness == Brightness.light,
        );
      }
    };
    await getSettingList();
    if (userStore.isLoggedIn) {
      getFitBotListApiCall();
    }
    Permissions.activityPermissionsGranted();

    LiveStream().on(CHANGE_LANGUAGE, (dynamic p0) {
      setState(() {});
    });
  }

  Future<void> _getAppName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
    });
  }

  Future<void> getSettingList() async {
    await getSettingApi().then((value) {
      log(
        '------------------------111-------${value.currencySetting?.code.validate()}',
      );
      userStore.setCurrencyCodeID(
        value.currencySetting?.symbol.validate() ?? '',
      );
      userStore.setCurrencyPositionID(
        value.currencySetting?.position.validate() ?? '',
      );
      userStore.setCurrencyCode(value.currencySetting?.code.validate() ?? '');

      /// Config crispChat

      for (int i = 0; i < value.data!.length; i++) {
        switch (value.data![i].key) {
          case "terms_condition":
            {
              userStore.setTermsCondition(value.data![i].value.validate());
            }
          case "privacy_policy":
            {
              userStore.setPrivacyPolicy(value.data![i].value.validate());
            }
          case "ONESIGNAL_APP_ID":
            {
              userStore.setOneSignalAppID(value.data![i].value.validate());
            }
          case "ONESIGNAL_REST_API_KEY":
            {
              userStore.setOnesignalRestApiKey(value.data![i].value.validate());
            }
          case "ADMOB_BannerId":
            {
              userStore.setAdmobBannerId(value.data![i].value.validate());
            }
          case "ADMOB_InterstitialId":
            {
              userStore.setAdmobInterstitialId(value.data![i].value.validate());
            }
          case "ADMOB_BannerIdIos":
            {
              userStore.setAdmobBannerIdIos(value.data![i].value.validate());
            }
          case "ADMOB_InterstitialIdIos":
            {
              userStore.setAdmobInterstitialIdIos(
                value.data![i].value.validate(),
              );
            }
          case "ADMOB_NativeAdId":
            {
              userStore.setNativeAdId(value.data![i].value.validate());
            }
          case "ADMOB_NativeAdIdIos":
            {
              userStore.setNativeAdIdIos(value.data![i].value.validate());
            }
          case "CHATGPT_API_KEY":
            {
              userStore.setChatGptApiKey(value.data?[i].value.validate() ?? "");
            }
          case "AdsBannerDetail_Show_Ads_On_Diet_Detail":
            {
              userStore.setAdsBannerDetailShowAdsOnDietDetail(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Banner_Ads_OnDiet":
            {
              userStore.setAdsBannerDetailShowBannerAdsOnDiet(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Ads_On_Workout_Detail":
            {
              userStore.setAdsBannerDetailShowAdsOnWorkoutDetail(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Banner_On_Workouts":
            {
              userStore.setAdsBannerDetailShowBannerOnWorkouts(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Ads_On_Exercise_Detail":
            {
              userStore.setAdsBannerDetailShowAdsOnExerciseDetail(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Banner_On_Equipment":
            {
              userStore.setAdsBannerDetailShowBannerOnEquipment(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Ads_On_Product_Detail":
            {
              userStore.setAdsBannerDetailShowAdsOnProductDetail(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Banner_On_Product":
            {
              userStore.setAdsBannerDetailShowBannerOnProduct(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Ads_On_Progress_Detail":
            {
              userStore.setAdsBannerDetailShowAdsOnProgressDetail(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Banner_On_BodyPart":
            {
              userStore.setAdsBannerDetailShowBannerOnBodyPart(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Ads_On_Blog_Detail":
            {
              userStore.setAdsBannerDetailShowAdsOnBlogDetail(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Banner_On_Level":
            {
              userStore.setAdsBannerDetailShowBannerOnLevel(
                value.data![i].value.toInt(),
              );
            }
          case "AdsBannerDetail_Show_Ads_On_Chatbot":
            {
              userStore.setshowAdsOnChatbot(value.data![i].value.toInt());
            }
          case "AdsBannerDetail_Show_Ads_On_Game":
            {
              userStore.setshowAdsOnGame(value.data![i].value.toInt());
            }
          case "AdsBannerDetail_Show_Ads_On_Slider_Banner":
            {
              userStore.setshowAdsOnBanner(value.data![i].value.toInt());
            }
          case "AdsBannerDetail_Show_Ads_On_List_View":
            {
              userStore.setshowAdsOnListView(value.data![i].value.toInt());
            }
          case "subscription_system":
            {
              log("--------204>>>${value.data![i].value.toString()}");
              userStore.setSubscription(value.data![i].value.toString());
            }
        }
      }

      getSettingData().whenComplete(() {
        if (getStringAsync(CRISP_CHAT_WEB_SITE_ID).isNotEmpty) {
          final User user = User(
            email: userStore.email,
            nickName: userStore.displayName,
            avatar: userStore.profileImage,
          );
          log("-----------211>>>${getBoolAsync(CRISP_CHAT_ENABLED)}");
          log("-----------212>>>${userStore.userId.toString()}");
          FlutterCrispChat.resetCrispChatSession();
          CrispConfig(
            user: user,
            tokenId: userStore.userId.toString(),
            websiteID: getStringAsync(CRISP_CHAT_WEB_SITE_ID),
          );
        }
        if (appUpdateCheck != null) {
          if (!mounted) return;
          VersionService().getVersionData(context, appUpdateCheck);
        }
      });
    });
  }

  Future<void> getFitBotListApiCall() async {
    await getFitBotList().then((value) {
      value.data?.reversed.forEach((data) {
        myMessages.add({"role": "user", "content": "${data.question}"});
        questionAnswers.insert(
          0,
          QuestionImageAnswerModel(
            question: data.question,
            imageUri: "",
            answer: data.answer != null
                ? StringBuffer(data.answer ?? '')
                : null,
            isLoading: false,
            smartCompose: '',
          ),
        );
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
      appStore.setDarkMode(
        MediaQuery.of(context).platformBrightness == Brightness.dark,
      );
    }
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DoubleBackToCloseApp(
      snackBar: SnackBar(
        elevation: 4,
        backgroundColor: appStore.isDarkMode
            ? cardDarkColor
            : primaryOpacity,
        content: Text(
          languages.lblTapBackAgainToLeave,
          style: primaryTextStyle(),
        ),
      ),
      child: AnimatedContainer(
        color: context.scaffoldBackgroundColor,
        duration: const Duration(milliseconds: 250),
        child: tab[mCurrentIndex],
      ),
    ),
    bottomNavigationBar: DashboardBottomNavBar(
      currentIndex: mCurrentIndex,
      onTap: (index) {
        setState(() {
          mCurrentIndex = index;
        });
      },
      onFabTap: () {
        if (userStore.isLoggedIn) {
          const SubscriptionDetailScreen().launch<void>(context);
        } else {
          const SignInScreen().launch<void>(context);
        }
      },
    ),
  );
}

Future<void> configureCrispChat() async {
  /*FlutterCrispChat.setSessionString(
    key: userStore.userId.toString(),
    value: userStore.userId.toString(),
  );*/

  try {
    FlutterCrispChat.setSessionString(
      key: getIntAsync(USER_ID).toString(),
      value: getIntAsync(USER_ID).toString(),
    );

    /// Checking session ID After 5 sec
    await Future.delayed(const Duration(seconds: 5), () async {
      final String? sessionId = await FlutterCrispChat.getSessionIdentifier();
      if (sessionId != null) {
        if (kDebugMode) {
          log("Session ID::: $sessionId");
        }
      } else {
        log("Session ID not  found::: ");
      }
    });
  } on Exception catch (e, stack) {
    log("error in crispchat${e.toString()}-----------$stack");
    toast(e.toString());
  }
}
