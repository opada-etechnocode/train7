import '../utils/shared_import.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  static String tag = '/WorkoutHistoryScreen';

  const WorkoutHistoryScreen({super.key});

  @override
  WorkoutHistoryScreenState createState() => WorkoutHistoryScreenState();
}

class WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  List<WorkoutHistoryData> workoutHistoryList = [];
  ScrollController scrollController = ScrollController();

  int page = 1;
  int? numPage;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
    //     if (page < numPage!) {
    //       page++;
    //       init();
    //     }
    //   }
    // });
  }

  Future<void> init() async {
    getUserWorkoutExercise();
  }

  Future<void> getUserWorkoutExercise() async {
    appStore.setLoading(true);
    await getUserWorkoutExerciseApi()
        .then((value) {
          appStore.setLoading(false);
          final Iterable<WorkoutHistoryData> it = value.data;
          it.map((e) => workoutHistoryList.add(e)).toList();
          setState(() {});
        })
        .catchError((Object e) {
          appStore.setLoading(false);
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(languages.lblWOHtr, context: context),
    body: Stack(
      children: [
        workoutHistoryList.isNotEmpty
            ? AnimatedListView(
                controller: scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                itemCount: workoutHistoryList.length,
                itemBuilder: (context, index) {
                  final data = workoutHistoryList[index];
                  return Container(
                    decoration: appStore.isDarkMode
                        ? boxDecorationWithRoundedCorners(
                            borderRadius: radius(12),
                          )
                        : boxDecorationRoundedWithShadow(12),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                    margin: const EdgeInsets.only(bottom: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cachedImage(
                              data.exerciseImage.validate(),
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(10),
                            12.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                6.height,
                                Text(
                                  data.exerciseTitle.validate(),
                                  style: boldTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                6.height,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            "Workout:",
                                            style: secondaryTextStyle(),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              data.workoutTitle.validate(),
                                              style: boldTextStyle(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (userStore.subscription == "1")
                                      if (data.exerciseIsPremium == 1) mPro(),
                                  ],
                                ),
                              ],
                            ).expand(),
                          ],
                        ).expand(),
                      ],
                    ),
                  ).onTap(() async {
                    dynamic result;
                    if (userStore.subscription == "1") {
                      if (data.exerciseIsPremium == 1) {
                        if (userStore.isSubscribe == 0) {
                          result = await const SubscribeScreen().launch<Map<String, dynamic>>(context);
                        } else {
                          result = await ExerciseDetailScreen(
                            mExerciseName: data.exerciseTitle.validate(),
                            mExerciseId: data.exerciseId.validate(),
                            workOutId: data.workoutId.toString(),
                            workoutDayId: data.workoutDayId,
                            isCompleted: true,
                            isFrom: 'workoutHistory',
                          ).launch<dynamic>(context);
                        }
                      } else {
                        result = await ExerciseDetailScreen(
                          mExerciseName: data.exerciseTitle.validate(),
                          mExerciseId: data.exerciseId.validate(),
                          workOutId: data.workoutId.toString(),
                          workoutDayId: data.workoutDayId,
                          isCompleted: true,
                          isFrom: 'workoutHistory',
                        ).launch<dynamic>(context);
                      }
                    } else {
                      result = await ExerciseDetailScreen(
                        mExerciseName: data.exerciseTitle.validate(),
                        mExerciseId: data.exerciseId.validate(),
                        workOutId: data.workoutId.toString(),
                        workoutDayId: data.workoutDayId,
                        isCompleted: true,
                        isFrom: 'workoutHistory',
                      ).launch<dynamic>(context);
                    }

                    if (!mounted) return;
                    if (result == 'removeWorkout') {
                      setState(() {
                        workoutHistoryList.removeAt(index);
                      });
                    }
                  });
                },
              )
            : NoDataScreen(
                mTitle: languages.lblWorkoutNoFound,
              ).visible(!appStore.isLoading),
        const Loader().center().visible(appStore.isLoading),
      ],
    ),
  );
}
