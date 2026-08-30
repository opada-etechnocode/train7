import 'package:mobx/mobx.dart';
import '../utils/shared_import.dart';

class OtherUserProfileScreen extends StatefulWidget {
  const OtherUserProfileScreen({super.key, required this.userDetails});
  final Users userDetails;

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen>
    with SingleTickerProviderStateMixin {
  String mFNameCont = "";
  String mLNameCont = "";
  String? profileImg = '';
  LikeComment likeComment = LikeComment();
  ScrollController scrollController = ScrollController();

  bool isBottomSheetOpen = false;

  late AnimationController _controller;
  final Map<int, PageController> _pageControllers = {};

  int page = 1;
  int? numPage;
  bool isLastPage = false;
  ObservableList<PostData> mPostList = ObservableList<PostData>();
  late List<ValueNotifier<bool>> heartVisibleList;
  bool shouldShowAds = false;
  final Post post = Post();
  ValueNotifier<int> likeChange = ValueNotifier(0);
  ValueNotifier<int> pageChange = ValueNotifier(0);
  ValueNotifier<int> bookMarkChange = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    shouldShowAds =
        userStore.showAdsOnListView == 1 &&
        userStore.isSubscribe == 0 &&
        !getNativeAdUnitId().isEmptyOrNull;
    mFNameCont = widget.userDetails.firstName ?? '';
    mLNameCont = widget.userDetails.lastName ?? '';
    profileImg = widget.userDetails.profileImage ?? '';
    getPostList();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          getPostList();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();
    _pageControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }



  Future<void> getPostList() async {
    appStore.setLoading(true);
    await getPostsApi(page: page, userId: widget.userDetails.id)
        .then((value) {
          numPage = value.pagination!.totalPages;
          isLastPage = false;
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
          setState(() {});
        })
        .catchError((e, s) {
          isLastPage = true;
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
          : Brightness.light,
      systemNavigationBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.light,
    ),
    child: Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Stack(
          children: [
            Container(height: context.height() * 0.4, color: primaryColor),
            OtherUserProfileAppbar(title: languages.lblProfile),
            Container(
              margin: EdgeInsets.only(top: context.height() * 0.2),
              height: context.height() * 0.4,
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radiusOnly(topRight: 16, topLeft: 16),
                backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : Colors.white,
              ),
            ),
            Column(
              children: [
                OtherUserProfileHeader(
                  profileImage: profileImg,
                  firstName: mFNameCont,
                  lastName: mLNameCont,
                ),
                if (mPostList.isNotEmpty) ...[
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: shouldShowAds ? (mPostList.isEmpty ? 0 : (4 * mPostList.length - 1) ~/ 3) : mPostList.length,
                    itemBuilder: (context, index) {
                      _pageControllers[index] ??= PageController();
                      if (shouldShowAds && index != 0 && index % 4 == 0) {
                        final adIndex = (index ~/ 4) - 1;
                        adLoaded[adIndex] ??= ValueNotifier(false);
                        adLoading[adIndex] ??= ValueNotifier(false);
                        if (!ads.containsKey(adIndex) && adLoading[adIndex]!.value != true) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            loadAd(adIndex, shouldShowAds, false);
                          });
                        }
                        return ValueListenableBuilder<bool>(
                          valueListenable: adLoaded[adIndex]!,
                          builder: (context, loaded, _) {
                            if (!loaded) return buildAdPlaceholder();
                            return SizedBox(height: 250, child: AdWidget(ad: ads[adIndex]!));
                          },
                        );
                      }
                      final realIndex = shouldShowAds ? index - (index ~/ 4) : index;
                      return OtherUserProfilePostItem(
                        postData: mPostList[realIndex],
                        post: post,
                        mPostList: mPostList,
                        onRefresh: () {
                          mPostList.clear();
                          page = 1;
                          getPostList();
                        },
                        likeChange: likeChange,
                        bookMarkChange: bookMarkChange,
                        pageChange: pageChange,
                        pageController: _pageControllers[index]!,
                        heartVisible: heartVisibleList[realIndex],
                        animationController: _controller,
                        isBottomSheetOpen: () => isBottomSheetOpen,
                        setBottomSheetOpen: (val) => isBottomSheetOpen = val,
                        likeComment: likeComment,
                      );
                    },
                  ),
                  8.height,
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      26.height,
                      Image.asset(no_data_found, height: context.height() * 0.2, width: context.width() * 0.4),
                      16.height,
                      Text(languages.lblNoPost, style: boldTextStyle()),
                    ],
                  ).center().visible(!appStore.isLoading),
                ],
              ],
            ).paddingSymmetric(horizontal: 6),
            if (appStore.isLoading)
              Positioned.fill(
                child: SizedBox(
                  height: context.height() * 0.5,
                  child: const Loader().center(),
                ),
              ),
          ],
        ),
      ),
    ),
  );

}
