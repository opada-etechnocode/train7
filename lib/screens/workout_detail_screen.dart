import '../utils/shared_import.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final int? id;
  final void Function(int status)? onCall;

  final WorkoutDetailModel? mWorkoutModel;

  const WorkoutDetailScreen({
    super.key,
    this.id,
    this.mWorkoutModel,
    this.onCall,
  });

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  ScrollController scrollController = ScrollController();
  int page = 1;
  int? numPage;
  int currentTabIndex = 0;
  int? mWorkoutId;

  bool isLastPage = false;
  bool isLoading = false;

  List<DayExerciseModel> mDayExerciseList = [];
  List<Workoutday> mWorkoutDayList = [];
  List<Widget> tabs = [];

  WorkoutDetailModel? mWorkoutDetailModel;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (userStore.adsBannerDetailShowAdsOnWorkoutDetail == 1) {
      loadInterstitialAds();
    }
    appStore.setLoading(true);
    await getWorkoutDetailApi(widget.id.validate())
        .then((value) {
          mWorkoutDetailModel = value.data;
          tabs.clear();
          value.workoutday!.forEachIndexed((element, index) {
            tabs.add(Text("${languages.lblDay} ${index + 1}"));
          });
          mWorkoutDayList = value.workoutday!;
          getDayExerciseData(value.workoutday!.first.id.validate());
          setState(() {});
        })
        .catchError((Object e) {
          appStore.setLoading(false);
          setState(() {});
        });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          getDayExerciseData(mWorkoutId);
        }
      }
    });
  }



  @override
  void dispose() {
    if (userStore.adsBannerDetailShowAdsOnWorkoutDetail == 1) {
      showInterstitialAds();
    }
    super.dispose();
  }

  Future<void> getDayExerciseData(int? id) async {
    await getDayExerciseApi(id)
        .then((value) {
          numPage = value.pagination!.totalPages;
          isLastPage = false;
          if (page == 1) {
            mDayExerciseList.clear();
          }
          final Iterable<DayExerciseModel> it = value.data;
          it.map((e) => mDayExerciseList.add(e)).toList();
          appStore.setLoading(false);
          isLoading = false;
          setState(() {});
        })
        .catchError((Object e) {
          isLastPage = true;
          isLoading = false;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  Widget mData(String? img, String? mTitle, String? mValue) => Column(
    children: [
      Image.asset(img.toString(), width: 24, height: 24, color: primaryColor),
      4.height,
      Text(mTitle.validate(), style: boldTextStyle()),
      4.height,
      Text(mValue.validate(), style: secondaryTextStyle()),
    ],
  );

  Future<void> setWorkout(int? id) async {
    appStore.setLoading(true);
    final Map<String, dynamic> req = {"workout_id": id};
    await setWorkoutFavApi(req)
        .then((value) {
          toast(value.message);
          appStore.setLoading(false);
          if (mWorkoutDetailModel!.isFavourite == 1) {
            mWorkoutDetailModel!.isFavourite = 0;
          } else {
            mWorkoutDetailModel!.isFavourite = 1;
          }
          appStore.setLoading(false);
          widget.onCall?.call(mWorkoutDetailModel?.isFavourite ?? 0);
          setState(() {});
        })
        .catchError((Object e) {
          appStore.setLoading(false);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
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
      body: Stack(
        children: [
          if (mWorkoutDetailModel != null)
            DefaultTabController(
              length: mWorkoutDayList.isEmpty ? 0 : mWorkoutDayList.length,
              initialIndex: currentTabIndex,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            cachedImage(
                              mWorkoutDetailModel!.workoutImage.validate(),
                              width: context.width(),
                              height: context.height() * 0.39,
                              fit: BoxFit.cover,
                            ),
                            mBlackEffect(
                              context.width(),
                              context.height() * 0.39,
                              radiusValue: 0,
                            ),
                          ],
                        ),
                        Positioned(
                          top: context.statusBarHeight,
                          left: appStore.selectedLanguageCode == 'ar' ? 8 : 0,
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  finish(context);
                                },
                                icon: Icon(
                                  appStore.selectedLanguageCode == 'ar'
                                      ? MaterialIcons.arrow_forward_ios
                                      : Octicons.chevron_left,
                                  color: whiteColor,
                                ),
                              ),
                              if (userStore.subscription == "1")
                                if (mWorkoutDetailModel!.isPremium == 1)
                                  mPro().paddingOnly(left: 16, top: 8),
                            ],
                          ),
                        ),
                        if (mWorkoutDetailModel != null)
                          Positioned(
                            right: 16,
                            top: context.statusBarHeight + 8,
                            child: InkWell(
                              onTap: () {
                                setWorkout(mWorkoutDetailModel?.id.validate());
                              },
                              child: Container(
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: favBackground,
                                  boxShape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Image.asset(
                                  mWorkoutDetailModel!.isFavourite == 1
                                      ? ic_favorite_fill
                                      : ic_favorite,
                                  color: mWorkoutDetailModel!.isFavourite == 1
                                      ? primaryColor
                                      : white,
                                  width: 20,
                                  height: 20,
                                ).center(),
                              ),
                            ),
                          ),
                        Positioned(
                          left: 16,
                          bottom: 42,
                          child: Text(
                            mWorkoutDetailModel!.title
                                .capitalizeFirstLetter()
                                .toString(),
                            style: boldTextStyle(size: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.65,
                    minChildSize: 0.65,
                    maxChildSize: 0.9,
                    builder: (context, controller) => Container(
                      width: context.width(),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radiusOnly(topLeft: 20.0, topRight: 20.0),
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: SingleChildScrollView(
                        controller: controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                mData(
                                  ic_dumbbell,
                                  mWorkoutDetailModel!.workoutTypeTitle
                                      .validate(),
                                  languages.lblWorkoutType,
                                ),
                                mData(
                                  ic_level,
                                  mWorkoutDetailModel!.levelTitle.validate(),
                                  languages.lblLevel,
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 32),
                            10.height,
                            const Divider(indent: 16, endIndent: 16),
                            10.height,
                            if (!appStore.isLoading)
                              Column(
                                children: [
                                  HtmlWidget(
                                        postContent: mWorkoutDetailModel
                                            ?.description
                                            .validate(),
                                      )
                                      .paddingSymmetric(horizontal: 8)
                                      .visible(
                                        !(mWorkoutDetailModel
                                                ?.description
                                                .isEmptyOrNull ??
                                            false),
                                      ),
                                  20.height,
                                  TabBar(
                                    indicatorColor: primaryColor,
                                    unselectedLabelStyle: primaryTextStyle(),
                                    labelStyle: boldTextStyle(),
                                    labelColor: primaryColor,
                                    labelPadding: const EdgeInsets.only(
                                      bottom: 8,
                                      left: 16,
                                      right: 16,
                                    ),
                                    unselectedLabelColor: appStore.isDarkMode
                                        ? Colors.white
                                        : textSecondaryColorGlobal,
                                    isScrollable: true,
                                    tabs: tabs,
                                    onTap: (index) {
                                      currentTabIndex = index;
                                      mWorkoutId = mWorkoutDetailModel!.id;
                                      isLoading = true;
                                      getDayExerciseData(
                                        mWorkoutDayList[index].id,
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  const Divider(height: 0, indent: 16),
                                  Stack(
                                    children: [
                                      mDayExerciseList.isNotEmpty
                                          ? AnimatedListView(
                                              controller: scrollController,
                                              itemCount:
                                                  mDayExerciseList.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 16,
                                                  ),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                final List<String> mSets = [];
                                                if (mDayExerciseList[index]
                                                        .exercise
                                                        ?.type ==
                                                    "sets") {
                                                  if (mDayExerciseList[index]
                                                          .exercise
                                                          ?.sets
                                                          ?.isNotEmpty ==
                                                      true) {
                                                    mDayExerciseList[index]
                                                        .exercise
                                                        ?.sets
                                                        ?.forEach((element) {
                                                          if (mDayExerciseList[index]
                                                                  .exercise
                                                                  ?.based
                                                                  .toString() ==
                                                              "time") {
                                                            mSets.add(
                                                              "${element.time}s",
                                                            );
                                                          } else {
                                                            mSets.add(
                                                              "${element.reps}x",
                                                            );
                                                          }
                                                        });
                                                  }
                                                }
                                                return ExerciseDayComponent(
                                                  mDayExerciseModel:
                                                      mDayExerciseList[index],
                                                  mSets: mSets,
                                                  workOutId: widget.id
                                                      .toString(),
                                                  workoutDayId:
                                                      mDayExerciseList[index]
                                                          .workoutDayId,
                                                  onRefreshWorkout: (workoutDayId) {
                                                    getDayExerciseData(
                                                      workoutDayId,
                                                    );
                                                    log(
                                                      "back day id $workoutDayId",
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : Text(
                                                  mWorkoutDayList.isEmpty ||
                                                          currentTabIndex < 0 ||
                                                          currentTabIndex >=
                                                              mWorkoutDayList
                                                                  .length
                                                      ? languages.lblNoFoundData
                                                      : mWorkoutDayList[currentTabIndex]
                                                                .isRest ==
                                                            1
                                                      ? languages.lblBreak
                                                      : languages
                                                            .lblNoFoundData,
                                                  style: secondaryTextStyle(),
                                                )
                                                .center()
                                                .paddingOnly(top: 50)
                                                .visible(!isLoading == true),
                                      const Loader()
                                          .center()
                                          .paddingOnly(top: 50)
                                          .visible(isLoading == true)
                                          .center(),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ).paddingOnly(bottom: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Loader().center().visible(appStore.isLoading),
        ],
      ),
    ),
  );
}
