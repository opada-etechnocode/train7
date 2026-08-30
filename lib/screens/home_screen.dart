import '../components/health_permission_dialog.dart';
import '../service/health_service.dart';
import '../utils/shared_import.dart';

bool? isFirstTimeGraph = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController mScrollController = ScrollController();
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool shouldShowAds = false;
  StepController stepController = StepController();
  WaterController waterController = WaterController();
  late Future<DashboardResponse?> dashboardFuture;

  @override
  void initState() {
    shouldShowAds =
        userStore.showAdsOnBanner == 1 &&
        userStore.isSubscribe == 0 &&
        !getNativeAdUnitId().isEmptyOrNull;
    Future<void>.delayed(Duration.zero).then((val) {
      log("------------75>>>>${getBoolAsync(CRISP_CHAT_ENABLED)}");
      getUserDetailsApiCall();
      // if (isFirstTimeGraph == false) {
      //   graphGet();
      // }
    });
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: appStore.isDarkMode ? Colors.black : Colors.white,
        statusBarIconBrightness: appStore.isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
    );
    super.initState();
    if (userStore.isLoggedIn) {
      stepController.init();
      waterController.init();
      stepController.start();
    }
    dashboardFuture = getDashboardApi();
    if (Platform.isIOS) {
      Future.delayed(const Duration(seconds: 1), () {
        checkHealthPermission();
      });
    }
  }

  void checkHealthPermission() async {
    bool isAuthorized = await HealthService().hasStepPermission();
    if (!isAuthorized) {
      showHealthPermissionDialog();
    }
  }

  void showHealthPermissionDialog() {
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
  }
  Future<void> getUserDetailsApiCall() async {
    await getUSerDetail(context, userStore.userId).whenComplete(() {});
  }

  @override
  void dispose() {
    for (final ad in ads.values) {
      ad.dispose();
    }
    ads.clear();
    adLoaded.clear();
    adLoading.clear();
    super.dispose();
  }

  Future<void> init() async {
    final double weightInPounds = userStore.weight.toDouble();
    final double weightInKilograms = poundsToKilograms(weightInPounds);
    final saveWeightGraph = userStore.weightStoreGraph
        .replaceAll('user', '')
        .trim();

    log("------------175>>>>${weightInKilograms.toStringAsFixed(2)}");
    log("------------176>>>>$saveWeightGraph");
    log("------------177>>>>${userStore.weight}");

    //visible(getStringAsync(TERMS_SERVICE).isNotEmpty)
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget mHeading(String? title, {bool? isSeeAll = false, Function? onCall}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            8.width,
            Text(title ?? '', style: boldTextStyle(size: 15)).expand(),
            GestureDetector(
              onTap: () => onCall?.call(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    appStore.selectedLanguageCode == 'ar'
                        ? 'عرض الكل'
                        : 'View All',
                    style: const TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(

                        Icons.chevron_right,

                    color: primaryColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: appStore.isDarkMode
        ? context.scaffoldBackgroundColor
        : context.scaffoldBackgroundColor,
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(
        appStore.selectedLanguageCode == 'ar' ? 100 : 90,
      ),
      child: HomeAppBarHeader(
        onProfileTap: () {
          const EditProfileScreen().launch<void>(context);
        },
        onNotificationTap: () {
          if (userStore.isLoggedIn) {
            const NotificationScreen().launch<void>(context);
          } else {
            const SignInScreen().launch<void>(context);
          }
        },
        onPersonTap: () {
          const ProfileScreen().launch<void>(context);
        },
      ),
    ),
    body: RefreshIndicator(
      backgroundColor: context.scaffoldBackgroundColor,
      onRefresh: () async {
        setState(() {
          dashboardFuture = getDashboardApi();
        });
      },
      child: FutureBuilder<DashboardResponse?>(
        future: dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final DashboardResponse? mDashboardResponse = snapshot.data;
            userStore.setSubscription(mDashboardResponse?.subscription ?? '');

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeightReminder(),
                  16.height.visible(!userStore.weight.isEmptyOrNull),
                  _buildSearchBar(),
                  16.height,
                  HomeBannerSlider(
                    bannerSlider: mDashboardResponse!.bannerSlider,
                    pageController: _pageController,
                    currentIndex: _currentIndex,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    shouldShowAds: shouldShowAds,
                    ads: ads,
                    adLoaded: adLoaded,
                    adLoading: adLoading,
                    loadAd: loadAd,
                    buildAdPlaceholder: buildAdPlaceholder,
                  ),
                  16.height,
                  HomeDailyTracking(stepController: stepController, waterController: waterController),
                  FutureBuilder<bool>(
                      future: HealthService().hasStepPermission(),
                      builder: (context, snapshot) {
                        bool isAuthorized = snapshot.data ?? false;
                        if (!Platform.isIOS || !isAuthorized) return const SizedBox.shrink();

                        return _buildHealthIntegrationCard();
                      }
                  ),
                  if (userStore.isLoggedIn &&
                      mDashboardResponse.assignedWorkout!.isNotEmpty)
                    _buildAssignedWorkouts(mDashboardResponse),
                  16.height,
                  if (mDashboardResponse.bodypart!.isNotEmpty)
                    _buildBodyParts(mDashboardResponse),
                  if (mDashboardResponse.equipment!.isNotEmpty)
                    _buildEquipments(mDashboardResponse),
                  if (mDashboardResponse.workout!.isNotEmpty)
                    _buildWorkouts(mDashboardResponse),
                  if (mDashboardResponse.level!.isNotEmpty)
                    _buildLevels(mDashboardResponse),
                  24.height,
                ],
              ),
            );
          }
          return snapWidgetHelper(
            snapshot,
            loadingWidget: Container(
              height: mq.height,
              width: mq.width,
              color: Colors.transparent,
              child: const Loader(),
            ),
          );
        },
      ),
    ),
  );

  Widget _buildHealthIntegrationCard() {
    final bool isDark = appStore.isDarkMode;
        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF151A22) : context.cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFFE8504B), Color(0xFFFF7A2B)],
              ),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 24),
          ),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Health Integration', style: boldTextStyle(size: 14)),
              2.height,
              Text(
                'Apple Health Connected',
                style: primaryTextStyle(size: 12, color: const Color(0xFF2ECC71)),
              ),
              2.height,
              Text(
                'Step data is securely read from Apple Health using HealthKit.',
                style: secondaryTextStyle(size: 10),
                maxLines: 2,
              ),
            ],
          ).expand(),
          8.width,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 14),
                4.width,
                Text(
                  appStore.selectedLanguageCode == 'ar' ? 'متصل' : 'Connected',
                  style: boldTextStyle(size: 11, color: const Color(0xFF2ECC71)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightReminder() => Column(
      children: [
        5.height,
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Marquee(
            text: languages.lblHomeScreenTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: Colors.red,
            ),
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            pauseAfterRound: const Duration(seconds: 1),
          ),
        ).onTap(() {
          const EditProfileScreen().launch<void>(context);
        }),
      ],
    ).visible(userStore.weight.isEmptyOrNull && userStore.isLoggedIn);


  Widget _buildSearchBar() {
    final bool isDark = appStore.isDarkMode;
    final Color muted = isDark ? const Color(0xFF8B929A) : Colors.grey;
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        if (userStore.isLoggedIn) {
          const SearchScreen().launch<void>(context);
        } else {
          const SignInScreen().launch<void>(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A22) : context.cardColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: muted, size: 22),
            10.width,
            Text(
              languages.lblSearch,
              style: TextStyle(
                fontSize: 14,
                color: muted,
                fontFamily: 'Cairo',
              ),
            ).expand(),
            Icon(Icons.tune_rounded, color: muted, size: 20),
          ],
        ),
      ),
    );
  }





  Widget _buildAssignedWorkouts(DashboardResponse mDashboardResponse) => Column(
      children: [
        10.height,
        mHeading(
          languages.assignedWorkouts,
          onCall: () {
            const ViewWorkoutsScreen(isAssign: true).launch<void>(context);
          },
        ),
        HorizontalList(
          physics: const BouncingScrollPhysics(),
          itemCount: mDashboardResponse.assignedWorkout!.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          spacing: 16,
          itemBuilder: (context, index) => WorkoutComponent(
            mWorkoutModel: mDashboardResponse.assignedWorkout![index],
            onCall: () {
              appStore.setLoading(true);
              setState(() {});
              appStore.setLoading(false);
            },
          ),
        ),
      ],
    );


  Widget _buildBodyParts(DashboardResponse mDashboardResponse) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mHeading(
          languages.lblBodyPartExercise,
          onCall: () {
            if (userStore.isLoggedIn) {
              const ViewBodyPartScreen().launch<void>(context);
            } else {
              const SignInScreen().launch<void>(context);
            }
          },
        ),
        HorizontalList(
          physics: const BouncingScrollPhysics(),
          controller: mScrollController,
          itemCount: mDashboardResponse.bodypart!.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          spacing: 12,
          itemBuilder: (context, index) => BodyPartComponent(
            bodyPartModel: mDashboardResponse.bodypart![index],
          ),
        ),
      ],
    );


  Widget _buildEquipments(DashboardResponse mDashboardResponse) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,
        mHeading(
          languages.lblEquipmentsExercise,
          onCall: () {
            if (userStore.isLoggedIn) {
              const ViewEquipmentScreen().launch<void>(context);
            } else {
              const SignInScreen().launch<void>(context);
            }
          },
        ),
        HorizontalList(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: mDashboardResponse.equipment?.length ?? 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          spacing: 16,
          itemBuilder: (context, index) => EquipmentComponent(
            mEquipmentModel: mDashboardResponse.equipment![index],
          ),
        ),
      ],
    );


  Widget _buildWorkouts(DashboardResponse mDashboardResponse) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,
        mHeading(
          languages.lblWorkouts,
          onCall: () {
            if (userStore.isLoggedIn) {
              const FilterWorkoutScreen().launch<void>(context).then((value) {
                setState(() {});
              });
            } else {
              const SignInScreen().launch<void>(context);
            }
          },
        ),
        HorizontalList(
          physics: const BouncingScrollPhysics(),
          itemCount: mDashboardResponse.workout!.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          spacing: 16,
          itemBuilder: (context, index) => WorkoutComponent(
            mWorkoutModel: mDashboardResponse.workout![index],
            onCall: () {
              appStore.setLoading(true);
              setState(() {});
              appStore.setLoading(false);
            },
          ),
        ),
      ],
    );


  Widget _buildLevels(DashboardResponse mDashboardResponse) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,
        mHeading(
          languages.lblLevels,
          onCall: () {
            if (userStore.isLoggedIn) {
              const ViewLevelScreen().launch<void>(context);
            } else {
              const SignInScreen().launch<void>(context);
            }
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: mDashboardResponse.level!.length,
          itemBuilder: (context, index) => LevelComponent(
            mLevelModel: mDashboardResponse.level![index],
          ),
        ),
        16.height,
      ],
    );
}

