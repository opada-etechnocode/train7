import 'package:mobx/mobx.dart';
import '../utils/shared_import.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with SingleTickerProviderStateMixin {
  final Post post = Post();
  final LikeComment likeComment = LikeComment();

  ObservableList<BookmarkData> mPostList = ObservableList<BookmarkData>();

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

  @override
  void initState() {
    super.initState();

    init();
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
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();
    likeComment.scrollControllerComment.dispose();
    likeComment.scrollControllerLikes.dispose();
    _pageControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> init() async {
    getPostList();
  }

  Future<void> getPostList() async {
    appStore.setLoading(true);
    await getBookMarkPostsApi(page: page)
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
        .catchError((e, s) {
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
        languages.lblPostBmk,
        center: true,
        color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
        context: context,
        titleSpacing: 16,
        actions: [],
      ),
      body: Observer(
        builder: (_) => Stack(
          children: [
            if (mPostList.isNotEmpty) ...[
              SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: mPostList.length,
                      itemBuilder: (context, index) {
                        _pageControllers[index] ??= PageController();
                        final bookmarkItem = mPostList[index];
                        final postData = bookmarkItem.posts!;
                        return PostCardWidget(
                          postData: postData,
                          apiPostId: bookmarkItem.postingId,
                          apiUserId: bookmarkItem.userId ?? 0,
                          canEdit: postData.canEdit.validate(),
                          showPopupMenu: true,
                          fromBookmark: true,
                          index: index,
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
                          heartVisible: heartVisibleList[index],
                          pageController: _pageControllers[index]!,
                          isBottomSheetOpen: isBottomSheetOpen,
                          onBottomSheetOpenChanged: (v) =>
                              setState(() => isBottomSheetOpen = v),
                          mPostList: mPostList,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                        );
                      },
                    ),
                    8.height,
                  ],
                ),
              ),
            ] else ...[
              Column(
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
              ).center().visible(!appStore.isLoading),
            ],
            const SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Loader(),
            ).visible(appStore.isLoading),
          ],
        ),
      ),
    ),
  );
}
