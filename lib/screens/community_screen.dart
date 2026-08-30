import 'package:mobx/mobx.dart';
import '../utils/shared_import.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  final Post post = Post();
  final LikeComment likeComment = LikeComment();
  ObservableList<PostData> mPostList = ObservableList<PostData>();
  ObservableList<PostData> mPinList = ObservableList<PostData>();

  ScrollController scrollController = ScrollController();

  ValueNotifier<int> likeChange = ValueNotifier(0);
  ValueNotifier<int> bookMarkChange = ValueNotifier(0);
  ValueNotifier<int> pageChange = ValueNotifier(0);
  late List<ValueNotifier<bool>> heartVisibleList;

  int page = 1;
  int? numPage;

  late AnimationController _controller;
  bool isBottomSheetOpen = false;
  final Map<int, PageController> _pageControllers = {};

  bool shouldShowAds = false;

  Future<void> _onRefresh() async {
    page = 1;
    mPostList.clear();
    await getPostList();
  }

  @override
  void initState() {
    super.initState();

    init();
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
          init();
        }
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();
    likeComment.scrollControllerComment.dispose();
    likeComment.scrollControllerLikes.dispose();
    _pageControllers.forEach((_, controller) => controller.dispose());
    for (final ad in ads.values) {
      ad.dispose();
    }
    ads.clear();
    adLoaded.clear();
    adLoading.clear();
    super.dispose();
  }

  Future<void> init() async {
    getPostList();
  }

  Future<void> getPostList() async {
    appStore.setLoading(true);
    await getPostsApi(page: page)
        .then((value) {
          numPage = value.pagination!.totalPages;
          likeComment.isLastPage = false;
          if (page == 1) {
            log("-------93>>>fddfdfdfdf");
            mPostList.clear();
          }
          final Iterable<dynamic> it = value.data ?? [];
          it.map((e) => mPostList.add(e)).toList();
          heartVisibleList = List.generate(
            mPostList.length,
            (_) => ValueNotifier(false),
          );
          appStore.setLoading(false);
        })
        .catchError((dynamic e, StackTrace s) {
          likeComment.isLastPage = true;
          appStore.setLoading(false);
        });
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
    value: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.light,
      systemNavigationBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.light,
    ),
    child: Scaffold(
      appBar: appBarWidget(
        languages.lblCommunity,
        showBack: false,
        color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
        context: context,
        titleSpacing: 16,
        actions: [
          Padding(
            padding: const EdgeInsetsGeometry.directional(end: 16.0),
            child: Center(
              child: InkWell(
                onTap: () async {
                  final data = await Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (context) => const AddPostScreen(),
                    ),
                  );
                  if (data == "refresh") {
                    mPostList.clear();
                    page = 1;
                    getPostList();
                  }
                },
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: Colors.black,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        languages.lblPost,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) => Material(
          color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                child: mPostList.isNotEmpty
                    ? ListView.builder(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: shouldShowAds ? (mPostList.isEmpty ? 0 : (4 * mPostList.length - 1) ~/ 3) : mPostList.length,
                        itemBuilder: (context, index) {
                          _pageControllers[index] ??= PageController();
                          if (shouldShowAds && index != 0 && index % 4 == 0) {
                            final adIndex = (index ~/ 4) - 1;
                            adLoaded[adIndex] ??= ValueNotifier(false);
                            adLoading[adIndex] ??= ValueNotifier(false);
                            if (!ads.containsKey(adIndex) &&
                                adLoading[adIndex]!.value != true) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                loadAd(adIndex, shouldShowAds, false);
                              });
                            }
                            return ValueListenableBuilder<bool>(
                              valueListenable: adLoaded[adIndex]!,
                              builder: (context, loaded, _) {
                                if (!loaded) {
                                  return buildAdPlaceholder();
                                }
                                return SizedBox(
                                  height: 250,
                                  child: AdWidget(ad: ads[adIndex]!),
                                );
                              },
                            );
                          }
                          final realIndex = shouldShowAds
                              ? index - (index ~/ 4)
                              : index;
                          return PostCardWidget(
                            postData: mPostList[realIndex],
                            apiPostId: mPostList[realIndex].id,
                            apiUserId: mPostList[realIndex].users?.id ?? 0,
                            canEdit: mPostList[realIndex].canEdit.validate(),
                            showPopupMenu: true,
                            fromBookmark: false,
                            index: realIndex,
                            onRefresh: () {
                              mPostList.clear();
                              page = 1;
                              getPostList();
                            },
                            post: post,
                            likeComment: likeComment,
                            likeChange: likeChange,
                            bookMarkChange: bookMarkChange,
                            pageChange: pageChange,
                            heartVisible: heartVisibleList[realIndex],
                            pageController: _pageControllers[realIndex]!,
                            isBottomSheetOpen: isBottomSheetOpen,
                            onBottomSheetOpenChanged: (v) =>
                                setState(() => isBottomSheetOpen = v),
                            mPostList: mPostList,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          );
                        },
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: context.height(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                no_data_found,
                                height: context.height() * 0.2,
                                width: context.width() * 0.4,
                              ),
                              16.height,
                              Text(languages.lblNoPost, style: boldTextStyle()),
                            ],
                          ),
                        ),
                      ).visible(!appStore.isLoading),
              ),
              const SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Loader(),
              ).visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    ),
  );
}
