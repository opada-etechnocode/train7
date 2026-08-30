import '../utils/shared_import.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> with WidgetsBindingObserver {
  List<CategoryDietModel>? mDietCategoryList = [];
  List<DietModel>? mFeaturedDietList = [];
  List<DietModel>? mOtherDietList = [];
  List<DietModel>? mDietList = [];
  List<DietModel>? mAssignedDietList = [];

  ScrollController scrollController = ScrollController();

  TextEditingController mSearch = TextEditingController();
  String? mSearchValue = "";

  int page = 1;
  int? numPage;

  bool isLastPage = false;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    mSearch.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      log("App is in resumed state!");
    }
    if (state == AppLifecycleState.paused) {
      log("App is in push state!");
    }
  }

  Future<void> init() async {
    getDietData();
    mSearch.addListener(() {
      setState(() {
        _showClearButton = mSearch.text.isNotEmpty;
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (!mSearchValue.isEmptyOrNull) {
          if (numPage != null && page < numPage!) {
            page++;
            getDietDataAPI();
          }
        }
      }
    });
  }

  Future<void> getDietData() async {
    appStore.setLoading(true);
    await getDietDashboardApi().then((val) {
      mAssignedDietList = val.assignDiet;
      mDietCategoryList = val.categoryDiet;
      mFeaturedDietList = val.bestDiet;
      mOtherDietList = val.diet;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> getDietDataAPI() async {
    await getSearchDietApi(mSearch: mSearchValue, page: page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mDietList!.clear();
      }
      final Iterable<dynamic> it = value.data!;
      it.map((e) => mDietList!.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget mHeading(String? title, {bool? isSeeAll = false, Function? onCall}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            style: boldTextStyle(size: 18),
          ).paddingSymmetric(horizontal: 16),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              onCall?.call();
            },
            icon:  Icon(
                appStore.selectedLanguageCode=="en"?
                Feather.chevron_right:     Feather.chevron_left, color: primaryColor),
          ),
        ],
      );

  Widget mDietSearchList(List<DietModel>? mList) => ListView.builder(
        itemCount: mList!.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) =>
            FeaturedDietComponent(isList: true, mDietModel: mList[index]),
      );

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: appStore.isDarkMode ? Colors.black : Colors.white,
          statusBarIconBrightness:
              appStore.isDarkMode ? Brightness.light : Brightness.dark,
        ),
        child: SafeArea(
          child: Scaffold(
            appBar: appBarWidget(
              languages.lblDiet,
              context: context,
              showBack: false,
              titleSpacing: 16,
              actions: [
                Image.asset(ic_favorite,
                        height: 25, width: 25, color: primaryColor)
                    .onTap(() {
                      const FavouriteScreen(index: 1)
                          .launch<void>(context)
                          .then((value) {
                        getDietData();
                        setState(() {});
                      });
                    })
                    .visible(userStore.isLoggedIn)
                    .paddingSymmetric(horizontal: 16),
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: mSearch,
                        textFieldType: TextFieldType.OTHER,
                        isValidationRequired: false,
                        autoFocus: false,
                        suffix: getClearButton(),
                        decoration: defaultInputDecoration(
                          context,
                          isFocusTExtField: true,
                          label: languages.lblSearch,
                        ),
                        onChanged: (v) {
                          mSearchValue = v;
                          page = 1;
                          appStore.setLoading(true);
                          getDietDataAPI();
                          setState(() {});
                        },
                      ).paddingSymmetric(horizontal: 16),
                      mSearchValue.isEmptyOrNull
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const DisclaimerSection(),
                                    12.height,
                                    _calorieCalculatorSection(),
                                    if (userStore.isLoggedIn &&
                                        mAssignedDietList!.isNotEmpty) ...[
                                      8.height,
                                      mHeading(
                                        languages.assignedDiet,
                                        onCall: () {
                                          ViewAllDiet(
                                            isAssign: true,
                                            mTitle: languages.assignedDiet,
                                          ).launch<void>(context);
                                        },
                                      ),
                                      HorizontalList(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: mAssignedDietList!.length,
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 8,
                                        ),
                                        itemBuilder: (context, index) =>
                                            FeaturedDietComponent(
                                          mDietModel: mAssignedDietList![index],
                                        ),
                                      ),
                                    ],
                                    8.height,
                                    mHeading(
                                      languages.lblDietCategories,
                                      onCall: () {
                                        if (userStore.isLoggedIn) {
                                          const ViewDietCategoryScreen()
                                              .launch<void>(
                                            context,
                                          );
                                        } else {
                                          const SignInScreen()
                                              .launch<void>(context);
                                        }
                                      },
                                    ),
                                    HorizontalList(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: mDietCategoryList!.length,
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 8,
                                      ),
                                      itemBuilder: (context, index) =>
                                          DietCategoryComponent(
                                        mCategoryDietModel:
                                            mDietCategoryList![index],
                                      ),
                                    ),
                                  ],
                                ).visible(mDietCategoryList!.isNotEmpty),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    8.height,
                                    mHeading(
                                      languages.lblBestDietDiscoveries,
                                      onCall: () {
                                        if (userStore.isLoggedIn) {
                                          ViewAllDiet(
                                            isFeatured: true,
                                            mTitle: languages
                                                .lblBestDietDiscoveries,
                                          ).launch<void>(context).then((value) {
                                            getDietData();
                                            setState(() {});
                                          });
                                        } else {
                                          const SignInScreen()
                                              .launch<void>(context);
                                        }
                                      },
                                    ),
                                    HorizontalList(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: mFeaturedDietList!.length,
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 8,
                                        top: 4,
                                      ),
                                      itemBuilder: (context, index) =>
                                          FeaturedDietComponent(
                                        mDietModel: mFeaturedDietList![index],
                                      ),
                                    ),
                                  ],
                                ).visible(mFeaturedDietList!.isNotEmpty),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    mHeading(
                                      languages.lblDietaryOptions,
                                      onCall: () {
                                        if (userStore.isLoggedIn) {
                                          ViewAllDiet(
                                            mTitle: languages.lblDietaryOptions,
                                          ).launch<void>(context).then((value) {
                                            getDietData();
                                            setState(() {});
                                          });
                                        } else {
                                          const SignInScreen()
                                              .launch<void>(context);
                                        }
                                      },
                                    ),
                                    mDietSearchList(mOtherDietList),
                                  ],
                                ).visible(mOtherDietList!.isNotEmpty),
                              ],
                            )
                          : Stack(
                              children: [
                                mDietSearchList(mDietList!).paddingTop(16),
                                SizedBox(
                                  height: context.height() * 0.6,
                                  child: NoDataScreen(
                                    mTitle: languages.lblResultNoFound,
                                  )
                                      .visible(mDietList!.isEmpty)
                                      .center()
                                      .visible(!appStore.isLoading),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                const Loader().visible(appStore.isLoading),
              ],
            ),
          ),
        ),
      );

  Widget getClearButton() {
    if (!_showClearButton) {
      return mSuffixTextFieldIconWidget(ic_search);
    }

    return IconButton(
      onPressed: () {
        hideKeyboard(context);
        mSearch.clear();
        mSearchValue = "";
        setState(() {});
      },
      icon: const Icon(Icons.clear),
    );
  }

  Widget _calorieCalculatorSection() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: appStore.isDarkMode
            ? boxDecorationWithRoundedCorners(borderRadius: radius(16))
            : boxDecorationRoundedWithShadow(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                borderRadius: radius(12),
              ),
              child: const Icon(Icons.restaurant_menu, color: primaryColor),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languages.lblCalorieCalculator,
                    style: boldTextStyle(size: 15),
                  ),
                  4.height,
                  Text(
                    languages.lblCalorieCalculatorDesc,
                    style: secondaryTextStyle(size: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: primaryColor),
          ],
        ),
      ).onTap(() {
        if (userStore.isLoggedIn) {
          const CalorieCalculatorScreen().launch<void>(context);
        } else {
          const SignInScreen().launch<void>(context);
        }
      });
}
