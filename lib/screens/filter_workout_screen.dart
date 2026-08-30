import '../utils/shared_import.dart';
import '../components/filter_workout_bottomsheet.dart';

class FilterWorkoutScreen extends StatefulWidget {
  final int? id;

  const FilterWorkoutScreen({super.key, this.id});

  @override
  State<FilterWorkoutScreen> createState() => _FilterWorkoutScreenState();
}

class _FilterWorkoutScreenState extends State<FilterWorkoutScreen> {
  ScrollController scrollController = ScrollController();

  List<WorkoutFilterList> list = [];
  List<WorkoutDetailModel> mWorkoutList = [];
  List<LevelModel> mLevelList = [];
  List<WorkoutTypeModel> mWorkoutTypeList = [];
  List<int> mSelectedList = [];
  int saveIndex = 0;
  int pages = 1;
  int page = 1;
  int? numPage;

  int pageLevel = 1;
  int? numPageLevel;
  bool isLastPageLevel = false;

  bool isLastPage = false;

  int pageWorkoutType = 1;
  int? numPageWorkoutType;
  bool isLastPageWorkoutType = false;

  bool shouldShowAds = false;

  @override
  void initState() {
    super.initState();
    getList();
    getWorkoutData();
    getWorkoutTypeData();
    shouldShowAds =
        userStore.showAdsOnListView == 1 &&
        userStore.isSubscribe == 0 &&
        !getNativeAdUnitId().isEmptyOrNull;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          getWorkoutData(
            isFilter: true,
            ids: (list[1].select.validate() || list[2].select.validate())
                ? mSelectedList
                      .toString()
                      .removeAllWhiteSpace()
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .trim()
                : null,
            isTypes: list[1].select,
            isLevel: list[2].select,
          );
        }
      }
    });
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

  Future<void> setWorkout(int? id, int? isFavourite) async {
    pages = 1;
    appStore.setLoading(true);
    final Map<String, dynamic> req = {"workout_id": id};
    await setWorkoutFavApi(req)
        .then((value) async {
          toast(value.message);
          appStore.setLoading(false);
          if (isFavourite == 1) {
            isFavourite = 0;
          } else {
            isFavourite = 1;
          }
          appStore.setLoading(false);

          //  getWorkoutDataFavorites();
        })
        .catchError((e) {
          appStore.setLoading(false);
          setState(() {});
        });
  }

  Future<void> getWorkoutData({
    bool? isFilter,
    bool? isLevel = false,
    bool? isTypes = false,
    dynamic ids,
  }) async {
    appStore.setLoading(true);
    await getWorkoutFilterListApi(
          page: page,
          id: widget.id.validate(),
          isFilter: isFilter,
          isLevel: isLevel,
          isType: isTypes,
          ids: ids,
        )
        .then((value) {
          numPage = value.pagination!.totalPages;
          isLastPage = false;
          if (page == 1) {
            mWorkoutList.clear();
          }
          log(value.toString());
          final Iterable<dynamic> it = value.data!;
          it.map((e) => mWorkoutList.add(e)).toList();
          appStore.setLoading(false);
          setState(() {});
        })
        .catchError((e) {
          isLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  Future<void> getWorkoutTypeData() async {
    appStore.setLoading(true);
    await getWorkoutTypeListApi(mPerPage: pageWorkoutType)
        .then((value) {
          final Iterable<dynamic> it = value.data!;
          numPageWorkoutType = value.pagination!.totalPages;

          isLastPageWorkoutType = false;
          if (pageWorkoutType == 1) {
            mWorkoutTypeList.clear();
          }
          it.map((e) => mWorkoutTypeList.add(e)).toList();
          appStore.setLoading(false);
          setState(() {});
        })
        .catchError((e) {
          appStore.setLoading(false);
        })
        .whenComplete(() {
          if (pageWorkoutType < numPageWorkoutType!) {
            pageWorkoutType++;
            getWorkoutTypeData();
          } else {
            getLevelData();
          }
        });
  }

  Future<void> getLevelData() async {
    appStore.setLoading(true);
    await getLevelListApi(page: pageLevel)
        .then((value) {
          final Iterable<dynamic> it = value.data!;
          numPageLevel = value.pagination!.totalPages;

          isLastPageLevel = false;
          if (pageLevel == 1) {
            mLevelList.clear();
          }

          it.map((e) => mLevelList.add(e)).toList();
          appStore.setLoading(false);
          setState(() {});
        })
        .catchError((e) {
          isLastPageLevel = true;
          appStore.setLoading(false);
        })
        .whenComplete(() {
          if (pageLevel < numPageLevel!) {
            pageLevel++;
            getLevelData();
          }
        });
  }

  void getList() {
    list.add(WorkoutFilterList(0, languages.lblAll, true));
    list.add(
      WorkoutFilterList(
        1,
        '${languages.lblWorkoutLevel.split(' ').first} ${languages.lblTypes}',
        false,
      ),
    );
    list.add(WorkoutFilterList(2, languages.lblWorkoutLevel, false));
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width();
    const height = 185.0;

    return Scaffold(
      appBar: appBarWidget(
        languages.lblWorkouts,
        elevation: 0,
        context: context,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterSelectionComponent(
                  filterList: list,
                  mLevelList: mLevelList,
                  mWorkoutTypesList: mWorkoutTypeList,
                  onSelect: (index) async {
                    setState(() {
                      for (int i = 0; i < list.length; i++) {
                        list[i].select = i == index;
                      }
                    });
                    if (list[index].id == 0) {
                      page = 1;
                      for (int i = 0; i < mWorkoutTypeList.length; i++) {
                        mWorkoutTypeList[i].select = false;
                      }
                      isSelectedAll = false;
                      for (int i = 0; i < mLevelList.length; i++) {
                        mLevelList[i].select = false;
                      }
                      isSecondSelectedAll = false;
                      getWorkoutData(isFilter: true);
                    }
                  },
                  onFilterCall: (List<int> mList) {
                    page = 1;
                    final int index = list.indexWhere((element) => element.select == true);
                    getWorkoutData(
                      isFilter: true,
                      ids: mList.toString().removeAllWhiteSpace().replaceAll("[", "").replaceAll("]", "").trim(),
                      isTypes: list[index].id == 1,
                      isLevel: list[index].id == 2,
                    );
                    mSelectedList = mList;
                  },
                ),
                16.height,
                mWorkoutList.isNotEmpty
                    ? AnimatedListView(
                        shrinkWrap: true,
                        itemCount: shouldShowAds ? (mWorkoutList.isEmpty ? 0 : (6 * mWorkoutList.length - 1) ~/ 5) : mWorkoutList.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemBuilder: (context, int index) {
                          if (shouldShowAds && index != 0 && index % 6 == 0) {
                            final adIndex = (index / 6).floor() - 1;
                            adLoaded[adIndex] ??= ValueNotifier(false);
                            adLoading[adIndex] ??= ValueNotifier(false);
                            if (!ads.containsKey(adIndex) && adLoading[adIndex]?.value != true) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                loadAd(adIndex, shouldShowAds, false);
                              });
                            }
                            return ValueListenableBuilder<bool>(
                              valueListenable: adLoaded[adIndex]!,
                              builder: (context, loaded, _) {
                                if (!loaded) return buildAdPlaceholder();
                                return SizedBox(
                                  height: 250,
                                  child: AdWidget(ad: ads[adIndex]!),
                                );
                              },
                            );
                          }

                          final i = shouldShowAds ? index - (index ~/ 6) : index;
                          return WorkoutCardComponent(
                            workout: mWorkoutList[i],
                            width: width,
                            height: height,
                            onTap: () async {
                              saveIndex = i;
                              bool isPremium = userStore.subscription == "1" && mWorkoutList[i].isPremium == 1;
                              if (isPremium && userStore.isSubscribe == 0) {
                                await const SubscribeScreen().launch<void>(context);
                              } else {
                                await WorkoutDetailScreen(
                                  id: mWorkoutList[i].id,
                                  mWorkoutModel: mWorkoutList[i],
                                  onCall: (status) {
                                    page = 1;
                                    mWorkoutList.clear();
                                    int selIdx = list.indexWhere((element) => element.select == true);
                                    getWorkoutData(
                                      isFilter: true,
                                      ids: (list[1].select.validate() || list[2].select.validate())
                                          ? mSelectedList.toString().removeAllWhiteSpace().replaceAll("[", "").replaceAll("]", "").trim()
                                          : null,
                                      isTypes: list[selIdx].id == 1,
                                      isLevel: list[selIdx].id == 2,
                                    );
                                  },
                                ).launch<void>(context);
                              }
                            },
                            onFavTap: () {
                              if (mWorkoutList[i].isFavourite == 0 && (mWorkoutList[i].isFavouriteLocally == null || mWorkoutList[i].isFavouriteLocally == 0)) {
                                mWorkoutList[i].isFavouriteLocally = 1;
                                mWorkoutList[i].isFavourite = 1;
                              } else {
                                mWorkoutList[i].isFavouriteLocally = 0;
                                mWorkoutList[i].isFavourite = 0;
                              }
                              setState(() {});
                              setWorkout(mWorkoutList[i].id.validate(), mWorkoutList[i].isFavourite);
                            },
                          );
                        },
                      )
                    : SizedBox(
                        height: context.height() * 0.6,
                        child: NoDataScreen(mTitle: languages.lblWorkoutNoFound).center().visible(!appStore.isLoading),
                      ),
              ],
            ),
          ),
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
    );
  }
}

class WorkoutFilterList {
  int? id;
  String? title;
  bool? select;

  WorkoutFilterList(this.id, this.title, this.select);
}
