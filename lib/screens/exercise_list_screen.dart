import '../utils/shared_import.dart';

class ExerciseListScreen extends StatefulWidget {
  final bool? isBodyPart;
  final bool? isLevel;
  final bool? isEquipment;

  final String? mTitle;

  final int? id;

  const ExerciseListScreen({
    super.key,
    this.mTitle,
    this.isBodyPart = false,
    this.isLevel = false,
    this.isEquipment = false,
    this.id,
  });

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController exerciseScrollController;
  late ScrollController workoutScrollController;

  late TextEditingController searchCont;

  List<ExerciseModel> mExerciseList = [];
  List<WorkoutDetailModel> mWorkoutList = [];

  int exercisePage = 1;
  int? exerciseNumPage;
  bool isExerciseLastPage = false;

  int workoutPage = 1;
  int? workoutNumPage;
  bool isWorkoutLastPage = false;

  bool isSearch = false;
  String? mSearchValue = "";

  late VoidCallback _exerciseScrollListener;
  late VoidCallback _workoutScrollListener;
  late TabController _tabController;

  List<String> tabs = ['Exercises', 'Workouts'];

  @override
  void initState() {
    super.initState();

    exerciseScrollController = ScrollController();
    workoutScrollController = ScrollController();
    searchCont = TextEditingController();
    _tabController = TabController(length: (widget.isBodyPart! || widget.isEquipment!) ? 1 : 2, vsync: this);

    _exerciseScrollListener = () {
      if (!mounted) {
        return;
      }
      if (exerciseScrollController.position.pixels >=
          exerciseScrollController.position.maxScrollExtent - 200) {
        if (!appStore.isLoading &&
            !isExerciseLastPage &&
            exercisePage < (exerciseNumPage ?? 1)) {
          exercisePage++;
          getExerciseData();
        }
      }
    };

    _workoutScrollListener = () {
      if (!mounted) {
        return;
      }
      if (workoutScrollController.position.pixels >=
          workoutScrollController.position.maxScrollExtent - 200) {
        if (!appStore.isLoading &&
            !isWorkoutLastPage &&
            workoutPage < (workoutNumPage ?? 1)) {
          workoutPage++;
          getLevelWorkoutData();
        }
      }
    };

    exerciseScrollController.addListener(_exerciseScrollListener);
    workoutScrollController.addListener(_workoutScrollListener);

    init();
  }

  Future<void> init() async {
    getExerciseData();
    if (!widget.isBodyPart! && !widget.isEquipment!) {
      getLevelWorkoutData();
    }
  }

  Future<void> getExerciseData() async {
    appStore.setLoading(true);
    await getExerciseApi(
          page: exercisePage,
          mSearchValue: mSearchValue,
          id: widget.id.validate(),
          isBodyPart: widget.isBodyPart,
          isEquipment: widget.isEquipment,
          isLevel: widget.isLevel,
        )
        .then((value) {
          if (!mounted) {
            return;
          }
          appStore.setLoading(false);
          exerciseNumPage = value.pagination!.totalPages;
          isExerciseLastPage = false;
          if (exercisePage == 1) {
            mExerciseList.clear();
          }
          final Iterable<ExerciseModel> it = value.data!;
          it.map((e) => mExerciseList.add(e)).toList();
          setState(() {});
        })
        .catchError((Object e) {
          if (!mounted) {
            return;
          }
          isExerciseLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  Future<void> getLevelWorkoutData() async {
    appStore.setLoading(true);
    await getLevelWorkoutApi(
          page: workoutPage,
          mSearchValue: mSearchValue,
          id: widget.id.validate(),
        )
        .then((value) {
          if (!mounted) {
            return;
          }
          appStore.setLoading(false);
          workoutNumPage = value.pagination!.totalPages;
          isWorkoutLastPage = false;
          if (workoutPage == 1) {
            mWorkoutList.clear();
          }
          final Iterable<WorkoutDetailModel> it = value.data!;
          it.map((e) => mWorkoutList.add(e)).toList();
          setState(() {});
        })
        .catchError((Object e) {
          if (!mounted) {
            return;
          }
          isWorkoutLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  @override
  void dispose() {
    exerciseScrollController.removeListener(_exerciseScrollListener);
    exerciseScrollController.dispose();
    workoutScrollController.removeListener(_workoutScrollListener);
    workoutScrollController.dispose();
    searchCont.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width();
    const height = 185.0;

    return Scaffold(
        appBar: appBarWidget(
          isSearch ? "" : widget.mTitle.validate().capitalizeFirstLetter(),
          context: context,
          actions: [
            AnimatedContainer(
              margin: const EdgeInsets.only(left: 8, top: 4),
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              width: isSearch ? context.width() - 80 : 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSearch)
                    TextField(
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: primaryColor,
                      controller: searchCont,
                      onChanged: (v) {
                        mSearchValue = v;
                        mExerciseList.clear();
                        if (_tabController.index == 0) {
                          exercisePage = 1;
                          getExerciseData();
                        } else {
                          workoutPage = 1;
                          getLevelWorkoutData();
                        }
                      },
                      onSubmitted: (v) {
                        setState(() {
                          mSearchValue = v;
                          mExerciseList.clear();
                          if (_tabController.index == 0) {
                            exercisePage = 1;
                            getExerciseData();
                          } else {
                            workoutPage = 1;
                            getLevelWorkoutData();
                          }
                        });
                      },
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: languages.lblSearch,
                        hintStyle: primaryTextStyle(),
                      ),
                    ).paddingBottom(10).expand(),
                  IconButton(
                    icon: isSearch
                        ? const Icon(Icons.close)
                        : Image.asset(
                            ic_search,
                            height: 20,
                            width: 20,
                            color: primaryColor,
                          ),
                    onPressed: () async {
                      isSearch = !isSearch;
                      mSearchValue = "";
                      if (!searchCont.text.isEmptyOrNull) {
                        exercisePage = 1;
                        if (_tabController.index == 0) {
                          exercisePage = 1;
                          getExerciseData();
                        } else {
                          if (!widget.isBodyPart! && !widget.isEquipment!) {
                            workoutPage = 1;
                            getLevelWorkoutData();
                          }
                        }
                      }
                      searchCont.clear();
                      setState(() {});
                    },
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (!widget.isBodyPart! && !widget.isEquipment!)
              TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                tabs: const [
                  Tab(text: 'Exercises'),
                  Tab(text: 'Workouts'),
                ],
              ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  /// ---------------- EXERCISES TAB ----------------
                  Stack(
                    children: [
                      mExerciseList.isNotEmpty
                          ? AnimatedListView(
                              controller: exerciseScrollController,
                              disposeScrollController: false,
                              itemCount: mExerciseList.length,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  ExerciseComponent(
                                    mExerciseModel: mExerciseList[index],
                                  ),
                            )
                          : NoDataScreen(
                              mTitle: languages.lblExerciseNoFound,
                            ).visible(!appStore.isLoading),
                      Observer(
                        builder: (context) => Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: double.infinity,
                          child: const Loader().center(),
                        ).visible(appStore.isLoading),
                      ),
                    ],
                  ),

                  /// ---------------- WORKOUT TAB ----------------
                  if (!widget.isBodyPart! && !widget.isEquipment!)
                    Stack(
                      children: [
                        mWorkoutList.isNotEmpty
                            ? AnimatedListView(
                                controller: workoutScrollController,
                                disposeScrollController: false,
                                itemCount: mWorkoutList.length,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                shrinkWrap: true,
                                itemBuilder: (context, i) =>
                                    WorkoutListItemCard(
                                      workout: mWorkoutList[i],
                                      width: width,
                                      height: height,
                                      onTap: () async {
                                        final workout = mWorkoutList[i];
                                        final bool isSubscriptionEnabled =
                                            userStore.subscription == "1";
                                        final bool isPremiumWorkout =
                                            workout.isPremium == 1;
                                        final bool isUserSubscribed =
                                            userStore.isSubscribe == 1;

                                        if (isSubscriptionEnabled &&
                                            isPremiumWorkout &&
                                            !isUserSubscribed) {
                                          await const SubscribeScreen()
                                              .launch<void>(context);
                                          return;
                                        }
                                        await WorkoutDetailScreen(
                                          id: workout.id,
                                          mWorkoutModel: workout,
                                          onCall: (int status) {
                                            log("Workout callback status: $status");
                                            mWorkoutList.clear();
                                          },
                                        ).launch<void>(context);
                                      },
                                      onFavoriteToggle: () {
                                        if (mWorkoutList[i].isFavourite == 0 &&
                                            (mWorkoutList[i].isFavouriteLocally ==
                                                    null ||
                                                mWorkoutList[i]
                                                        .isFavouriteLocally ==
                                                    0)) {
                                          mWorkoutList[i].isFavouriteLocally = 1;
                                          mWorkoutList[i].isFavourite = 1;
                                        } else {
                                          mWorkoutList[i].isFavouriteLocally = 0;
                                          mWorkoutList[i].isFavourite = 0;
                                        }
                                        log(
                                          "-------358>>${mWorkoutList[i].isFavouriteLocally}",
                                        );
                                        setState(() {});
                                      },
                                    ),
                              )
                            : NoDataScreen(
                                mTitle: languages.lblWorkoutNoFound,
                              ).visible(!appStore.isLoading),
                        Observer(
                          builder: (context) => Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            height: double.infinity,
                            child: const Loader().center(),
                          ).visible(appStore.isLoading),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
