import 'package:mobx/mobx.dart';
import '../utils/shared_import.dart';

class PostDetailsScreen extends StatefulWidget {
  final PostData? postData;
  final bool isFromLink;
  const PostDetailsScreen({super.key, this.postData, this.isFromLink = false});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final Post post = Post();
  final LikeComment likeComment = LikeComment();

  ValueNotifier<int> likeChange = ValueNotifier(0);
  ValueNotifier<int> bookMarkChange = ValueNotifier(0);
  ValueNotifier<int> pageChange = ValueNotifier(0);
  ValueNotifier<bool> heartVisible = ValueNotifier(false);
  PageController pageController = PageController();
  bool isBottomSheetOpen = false;

  @override
  void dispose() {
    pageController.dispose();
    likeComment.scrollControllerComment.dispose();
    likeComment.scrollControllerLikes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postData == null) {
      return Scaffold(
        appBar: appBarWidget('', context: context),
        body: Center(child: Text(languages.lblNoPost)),
      );
    }

    return AnnotatedRegion(
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
          '',
          backWidget:
              Icon(
                appStore.selectedLanguageCode == 'ar'
                    ? MaterialIcons.arrow_forward_ios
                    : Octicons.chevron_left,
                color: primaryColor,
                size: 28,
              ).onTap(() {
                Navigator.of(context).pop(true);
              }),
          color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
          context: context,
          titleSpacing: 16,
        ),
        body: SingleChildScrollView(
          child: PostCardWidget(
            postData: widget.postData!,
            apiPostId: widget.postData!.id,
            apiUserId: widget.postData!.users?.id ?? 0,
            canEdit: widget.postData!.canEdit ?? false,
            showPopupMenu: true,
            fromBookmark: false,
            index: 0,
            onRefresh: () => setState(() {}),
            post: post,
            likeComment: likeComment,
            likeChange: likeChange,
            bookMarkChange: bookMarkChange,
            pageChange: pageChange,
            heartVisible: heartVisible,
            pageController: pageController,
            isBottomSheetOpen: isBottomSheetOpen,
            onBottomSheetOpenChanged: (v) =>
                setState(() => isBottomSheetOpen = v),
            mPostList: ObservableList<PostData>()..add(widget.postData!),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          ),
        ),
      ),
    );
  }
}
