import '../utils/shared_import.dart';
import 'ai_workout_screen.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final int? mExerciseId;
  final String? mExerciseName;
  final String? workOutId;
  final int? workoutDayId;
  final bool? isCompleted;
  final String? isFrom;

  const ExerciseDetailScreen({
    super.key,
    this.mExerciseId,
    this.mExerciseName,
    this.workOutId,
    this.workoutDayId,
    this.isCompleted,
    this.isFrom,
  });

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  ExerciseDetailResponse? mExerciseModel;
  ScrollController mScrollController = ScrollController();
  var mode = "portrait";
  int? mWeight = 1;
  bool isKGClicked = false;
  bool isLBSClicked = false;
  bool isCompleted = false;
  late Future<ExerciseDetailResponse> exerciseDetailFuture;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isCompleted ?? false;
    exerciseDetailFuture = geExerciseDetailApi(widget.mExerciseId);
    init();
  }

  Future<void> init() async {
    if (userStore.adsBannerDetailShowAdsOnExerciseDetail == 1) {
      loadInterstitialAds();
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget logSetWidget(String text, String subText) => RichText(
    text: TextSpan(
      text: text,
      style: boldTextStyle(size: 20),
      children: [
        WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(subText, style: secondaryTextStyle()),
          ),
        ),
      ],
    ),
  );

  Widget getHeading(String title) => Row(
    children: [
      Image.asset(ic_level, color: primaryColor, height: 18, width: 18),
      10.width,
      Text(title, style: primaryTextStyle()),
    ],
  ).paddingSymmetric(horizontal: 16);

  Widget dividerHorizontalLine({bool? isSmall = false}) => Container(
    height: isSmall == true ? 40 : 65,
    width: 4,
    color: context.scaffoldBackgroundColor,
  );

  Widget mSetText(String value, {String? value2}) {
    if (isLBSClicked == true && isKGClicked == false) {
      final double kgValue = double.tryParse(value2 ?? " ") ?? 0;
      final double lbsValue = kgValue * 2.20462;
      value2 = lbsValue.toStringAsFixed(2);
      //log("-----BBB>>>${lbsValue.toStringAsFixed(2)} lbs");
    }
    log("-----BBB>>>$value2");

    return value2.isEmptyOrNull || value2 == '0.00'
        ? Text(value, style: boldTextStyle()).center()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: boldTextStyle()),
              2.height,
              Text(
                "- ${value2?.validate() ?? '0'} ${isLBSClicked ? languages.lblLbs : languages.lblKg}",
                style: primaryTextStyle(size: 14),
              ),
              // Text("- " + value2.validate() + (isLBSClicked == true && isKGClicked == false)?languages.lblLbs:languages.lblKg, style: primaryTextStyle(size: 14)),
            ],
          );
  }

  Widget mSets1() {
    if (mExerciseModel?.data?.sets?.length == 1) {
      return mSetText(
        mExerciseModel?.data?.based == "reps"
            ? mExerciseModel?.data?.sets?.first.reps ??
                  ''
                      "x"
            : mExerciseModel?.data?.sets?.first.time ??
                  ''
                      "s",
        value2: mExerciseModel?.data?.sets?.first.weight.validate(),
      );
    } else if (mExerciseModel?.data?.sets?.length == 2) {
      return Row(
        children: [
          mSetText(
            mExerciseModel?.data?.based == "reps"
                ? mExerciseModel?.data?.sets?.first.reps ??
                      ""
                          "x"
                : mExerciseModel?.data?.sets?.first.time ??
                      ''
                          "s",
            value2: mExerciseModel?.data?.sets?.first.weight.validate(),
          ).expand(),
          dividerHorizontalLine(),
          mSetText(
            mExerciseModel?.data?.based == "reps"
                ? "${mExerciseModel!.data!.sets![1].reps.validate()}x"
                : mExerciseModel?.data?.sets![1].time ??
                      ''
                          "s",
            value2: mExerciseModel?.data?.sets?[1].weight.validate(),
          ).expand(),
        ],
      );
    } else if (mExerciseModel?.data?.sets?.length == 3) {
      return Row(
        children: [
          mSetText(
            mExerciseModel?.data?.based == "reps"
                ? mExerciseModel?.data?.sets![0].reps ??
                      ''
                          "x"
                : mExerciseModel?.data?.sets![0].time ??
                      ''
                          "s",
            value2: mExerciseModel?.data?.sets![0].weight.validate(),
          ).expand(),
          dividerHorizontalLine(),
          mSetText(
            mExerciseModel?.data?.based == "reps"
                ? mExerciseModel?.data?.sets![1].reps ??
                      ""
                          "x"
                : mExerciseModel?.data?.sets![1].time ??
                      ''
                          "s",
            value2: mExerciseModel?.data?.sets![1].weight.validate(),
          ).expand(),
          dividerHorizontalLine(),
          mSetText(
            mExerciseModel?.data?.based == "reps"
                ? mExerciseModel?.data?.sets![2].reps ??
                      ''
                          "x"
                : mExerciseModel?.data?.sets![2].time ??
                      ''
                          "s",
            value2: mExerciseModel?.data?.sets![2].weight.validate(),
          ).expand(),
        ],
      );
    } else if (mExerciseModel!.data!.sets != null) {
      return HorizontalList(
        itemCount: mExerciseModel!.data!.sets!.length,
        itemBuilder: (context, index) => Row(
          children: [
            16.width,
            mSetText(
              mExerciseModel!.data!.based == "reps"
                  ? "${mExerciseModel!.data!.sets![index].reps.validate()}x"
                  : "${mExerciseModel!.data!.sets![index].time}s",
              value2: mExerciseModel!.data!.sets![index].weight.validate(),
            ),
            16.width,
            dividerHorizontalLine(),
            16.width,
          ],
        ),
      );
    } else {
      return SizedBox(child: Text(languages.lblNoSetsMsg).center());
    }
  }

  Widget mSets2() {
    if (mExerciseModel?.data?.sets != null &&
        mExerciseModel?.data?.sets?.length == 1) {
      return mSetText(
        mExerciseModel?.data?.sets?.first.rest ??
            ''
                "s",
      );
    } else if (mExerciseModel?.data?.sets != null &&
        mExerciseModel?.data?.sets?.length == 2) {
      return Row(
        children: [
          mSetText(
            mExerciseModel?.data?.sets?[0].rest ??
                ''
                    "s",
          ).expand(),
          dividerHorizontalLine(isSmall: true),
          mSetText(
            mExerciseModel?.data?.sets?[1].rest ??
                ''
                    "s",
          ).expand(),
        ],
      );
    } else if (mExerciseModel?.data?.sets != null &&
        mExerciseModel?.data?.sets?.length == 3) {
      return Row(
        children: [
          mSetText(
            mExerciseModel?.data?.sets![0].rest ??
                ''
                    "s",
          ).expand(),
          dividerHorizontalLine(isSmall: true),
          mSetText(
            mExerciseModel?.data?.sets![1].rest ??
                ''
                    "s",
          ).expand(),
          dividerHorizontalLine(isSmall: true),
          mSetText(
            mExerciseModel?.data?.sets?[2].rest ??
                ''
                    "s",
          ).expand(),
        ],
      );
    } else if (mExerciseModel?.data?.sets != null) {
      return HorizontalList(
        itemCount: mExerciseModel?.data?.sets?.length ?? 0,
        itemBuilder: (context, index) => Row(
          children: [
            16.width,
            mSetText(
              mExerciseModel?.data?.sets?[index].rest ??
                  ''
                      "s",
            ),
            16.width,
            dividerHorizontalLine(isSmall: true),
            16.width,
          ],
        ),
      );
    } else {
      return SizedBox(child: Text(languages.lblNoSetsMsg).center());
    }
  }

  @override
  void dispose() {
    if (userStore.adsBannerDetailShowAdsOnExerciseDetail == 1) {
      showInterstitialAds();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      mode = "landScape";
    } else {
      mode = "portrait";
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 56),
        child: Visibility(
          visible: mode == 'portrait' ? true : false,
          child: appBarWidget(
            widget.mExerciseName.validate(),
            backWidget:
                Icon(
                  appStore.selectedLanguageCode == 'ar'
                      ? MaterialIcons.arrow_forward_ios
                      : Octicons.chevron_left,
                  color: primaryColor,
                  size: 28,
                ).onTap(() {
                  Future.microtask(() {
                    if (context.mounted) {
                      Navigator.pop(context, {
                        'action': 'refreshWorkout',
                        'workoutDayId': widget.workoutDayId,
                      });
                    }
                  });
                }),
            context: context,
            actions: [
              Image.asset(
                ic_menu,
                height: 24,
                width: 24,
                color: primaryColor,
              ).paddingSymmetric(horizontal: 16).onTap(() {
                TipsScreen(
                  mExerciseVideo: mExerciseModel!.data!.videoUrl.validate(),
                  mTips: mExerciseModel!.data!.tips.validate(),
                  mExerciseImage: mExerciseModel!.data!.exerciseImage
                      .validate(),
                  mExerciseInstruction: mExerciseModel!.data!.instruction,
                ).launch<void>(context);
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FutureBuilder<ExerciseDetailResponse>(
          future: exerciseDetailFuture,
          builder: (context, snapshot) {
            final hasData = snapshot.hasData && snapshot.data != null;
            final String exerciseTitle =
                (mExerciseModel?.data?.title ??
                        snapshot.data?.data?.title ??
                        widget.mExerciseName)
                    .validate();
            final String? aiKey = mapExerciseToAiKey(exerciseTitle);
            return Visibility(
              visible: (mode == 'portrait' && hasData),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (aiKey != null)
                    AppButton(
                      color: const Color(0xFF1B5E20),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      width: context.width(),
                      height: 44,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.smart_toy_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          8.width,
                          Text(
                            '${languages.lblAiStart} · $exerciseTitle',
                            style: boldTextStyle(color: Colors.white, size: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      onTap: () {
                        if (!userStore.isLoggedIn) {
                          const SignInScreen().launch<void>(context);
                          return;
                        }
                        AiWorkoutScreen(
                          exerciseKey: aiKey,
                          exerciseTitle: exerciseTitle,
                        ).launch<void>(context);
                      },
                    ),
                  AppButton(
                color: primaryColor,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                width: context.width(),
                onTap: () async {
                  if (isCompleted) {
                    final Map<String, dynamic> req = {
                      "exercise_id": widget.mExerciseId,
                      "workout_id": widget.workOutId,
                      "workout_day_id": widget.workoutDayId,
                      "status": "incomplete",
                    };
                    appStore.setLoading(true);
                        await storeUserWorkoutExercise(req)
                            .then((value) {
                              if (!context.mounted) return;
                              appStore.setLoading(false);
                              if (widget.isFrom == "workoutHistory") {
                                Future.microtask(() {
                                  if (context.mounted) Navigator.pop(context, "removeWorkout");
                                });
                              } else {
                                Future.microtask(() {
                                  if (context.mounted) {
                                    Navigator.pop(context, {
                                      'action': 'refreshWorkout',
                                      'workoutDayId': widget.workoutDayId,
                                    });
                                  }
                                });
                                isCompleted = false;
                                setState(() {});
                              }
                            })
                        .catchError((e) {
                          appStore.setLoading(false);
                        });
                  } else {
                    if (mExerciseModel?.data?.type == "duration") {
                      final result = await ExerciseDurationScreen(
                        mExerciseModel,
                        widget.workOutId,
                        widget.workoutDayId,
                      ).launch<Map<String, dynamic>?>(context);
                      if (result != null &&
                          result['action'] == 'refreshWorkout') {
                        Future.microtask(() {
                          if (context.mounted) Navigator.pop(context, result); // forward same map
                        });
                      }
                    } else {
                      final result = await ExerciseDurationScreencast(
                        mExerciseModel: mExerciseModel,
                        workOutId: widget.workOutId,
                        workoutDayId: widget.workoutDayId,
                      ).launch<Map<String, dynamic>?>(context);
        
                      if (result != null &&
                          result['action'] == 'refreshWorkout') {
                        Future.microtask(() {
                          if (context.mounted) Navigator.pop(context, result); // forward same map
                        });
                      }
                      // ExerciseDurationScreen2(mExerciseModel,widget.workOutId).launch(context);
                    }
                  }
                },
                text: isCompleted
                    ? languages.resetExercise
                    : languages.lblStartExercise,
              ),
                ],
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<ExerciseDetailResponse>(
        future: exerciseDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            mExerciseModel = snapshot.data;
            log("exi 2 ${mExerciseModel!.data!.id}");
            return SingleChildScrollView(
              physics: mode == 'portrait'
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExerciseDetailHeader(mExerciseModel: mExerciseModel, mode: mode),
                  16.height,
                  Row(
                    children: [
                      getHeading(
                        mExerciseModel!.data!.levelTitle.validate(),
                      ).visible(
                        !mExerciseModel!.data!.levelTitle.isEmptyOrNull,
                      ),
                      mExerciseModel?.data?.sets?.isNotEmpty ?? false
                          ? Container(
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: radius(4),
                                backgroundColor: appStore.isDarkMode
                                    ? context.cardColor
                                    : GreyLightColor,
                              ),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  mWeightOption(languages.lblLbs, 0),
                                  4.width,
                                  mWeightOption(languages.lblKg, 1),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  12.height,
                  ExerciseDetailSetsComponent(
                    mExerciseModel: mExerciseModel,
                    isLBSClicked: isLBSClicked,
                    isKGClicked: isKGClicked,
                    mSetText: mSetText,
                    mSets1: mSets1,
                    mSets2: mSets2,
                  ),
                  if (mExerciseModel!.data!.type == DURATION)
                    Container(
                      width: context.width(),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(),
                        backgroundColor: appStore.isDarkMode
                            ? cardDarkColor
                            : GreyLightColor.withValues(alpha: 0.3),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mExerciseModel!.data!.duration.validate(),
                            style: boldTextStyle(),
                          ),
                          2.height,
                          Text(
                            languages.lblDuration,
                            style: primaryTextStyle(),
                          ),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 16),
                  16.height,
                  const Divider(endIndent: 16, indent: 16),
                  if (mExerciseModel!.data!.bodypartName != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Text(
                          languages.lblBodyParts,
                          style: secondaryTextStyle(),
                        ).paddingSymmetric(horizontal: 16),
                        8.height,
                        HorizontalList(
                          physics: const BouncingScrollPhysics(),
                          controller: mScrollController,
                          itemCount: mExerciseModel!.data!.bodypartName!.length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          spacing: 16,
                          itemBuilder: (context, index) => SizedBox(
                            width: context.width() * 0.18,
                            child: Column(
                              children: [
                                cachedImage(
                                  mExerciseModel!
                                      .data!
                                      .bodypartName![index]
                                      .bodypartImage
                                      .validate(),
                                  fit: BoxFit.fill,
                                  height: 65,
                                  width: context.width() * 0.17,
                                ).cornerRadiusWithClipRRect(150),
                                6.height,
                                Text(
                                  mExerciseModel!
                                      .data!
                                      .bodypartName![index]
                                      .title
                                      .validate(),
                                  style: primaryTextStyle(size: 14),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(endIndent: 16, indent: 16),
                      ],
                    ).visible(mExerciseModel!.data!.bodypartName!.isNotEmpty),
                  ExerciseDetailEquipmentComponent(mExerciseModel: mExerciseModel),
                ],
              ),
            );
          }
          return snapWidgetHelper(snapshot);
        },
      ),
    );
  }

  Widget mWeightOption(String? value, int? index) =>
      Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(4),
          backgroundColor: mWeight == index
              ? primaryColor
              : appStore.isDarkMode
              ? context.cardColor
              : GreyLightColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Text(
          value ?? '',
          style: secondaryTextStyle(
            size: 12,
            color: mWeight == index ? Colors.white : textSecondaryColorGlobal,
          ),
        ),
      ).onTap(() {
        mWeight = index;
        if (index == 0) {
          if (!isLBSClicked) {
            isLBSClicked = true;
            isKGClicked = false;
          }
        } else {
          if (!isKGClicked) {
            isKGClicked = true;
            isLBSClicked = false;
          }
        }
        setState(() {});
      });
}

