import 'package:mobx/mobx.dart';
import '../utils/shared_import.dart';

class OtherUserProfilePostItem extends StatelessWidget {
  final PostData postData;
  final Post post;
  final ObservableList<PostData> mPostList;
  final VoidCallback onRefresh;
  final ValueNotifier<int> likeChange;
  final ValueNotifier<int> bookMarkChange;
  final ValueNotifier<int> pageChange;
  final PageController pageController;
  final ValueNotifier<bool> heartVisible;
  final AnimationController animationController;
  final bool Function() isBottomSheetOpen;
  final void Function(bool) setBottomSheetOpen;
  final LikeComment likeComment;

  const OtherUserProfilePostItem({
    super.key,
    required this.postData,
    required this.post,
    required this.mPostList,
    required this.onRefresh,
    required this.likeChange,
    required this.bookMarkChange,
    required this.pageChange,
    required this.pageController,
    required this.heartVisible,
    required this.animationController,
    required this.isBottomSheetOpen,
    required this.setBottomSheetOpen,
    required this.likeComment,
  });

  @override
  Widget build(BuildContext context) => Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              cachedImage(
                postData.users?.profileImage ?? '',
                fit: BoxFit.cover,
                height: 40,
                width: 40,
              ).cornerRadiusWithClipRRect(20),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postData.users?.displayName ?? '',
                    style: boldTextStyle(size: 16),
                    maxLines: 3,
                  ),
                  5.height,
                  Text(
                    "${languages.posted} ${postData.createdAt}",
                    style: secondaryTextStyle(size: 12, color: textSecondaryColorGlobal),
                  ),
                ],
              ),
              const Spacer(),
              _buildPopupMenu(context),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 16),
          _buildPostContent(context),
          const Divider(thickness: 0.25).paddingSymmetric(horizontal: 8),
          4.height,
          PostActionBar(
            postData: postData,
            likeChange: likeChange,
            bookMarkChange: bookMarkChange,
            onLikeTap: () async {
              postData.isLiked = !(postData.isLiked ?? false);
              if (postData.isLiked.validate()) {
                postData.postingLikeCount = postData.postingLikeCount.validate() + 1;
              } else {
                postData.postingLikeCount = postData.postingLikeCount.validate() - 1;
              }
              likeChange.value++;
              await post.likePost(postData.id);
            },
            onLikeCountTap: () async {
              if (postData.postingLikeCount != 0) {
                if (isBottomSheetOpen()) return;
                setBottomSheetOpen(true);
                likeComment.mLikeList.clear();
                likeComment.pageLike = 1;
                likeComment.bottomSheetForLike(
                  mPostList.indexOf(postData),
                  postData.id,
                  postData.users?.id ?? 0,
                  context,
                  isFirstTime: true,
                );
                await likeComment.likesList(postData.id, isFirstTime: true);
                setBottomSheetOpen(false);
              }
            },
            onCommentTap: () async {
              if (isBottomSheetOpen()) return;
              setBottomSheetOpen(true);
              likeComment.mCommentList.clear();
              likeComment.pageComment = 1;
              likeComment.bottomSheetBuilder(
                mPostList.indexOf(postData),
                postData.id,
                postData.users?.id ?? 0,
                postData.canEdit.validate(),
                context,
                mPostList,
                isFirstTime: true,
              );
              await likeComment.commentList(postData.id, isFirstTime: true);
              setBottomSheetOpen(false);
            },
            onShareTap: () async {
              final String postLink = '$mBackendURL/post/${postData.id}';
              Share.share('${languages.checkOutPost} $postLink');
            },
            onBookmarkTap: () async {
              postData.isBookmark = !(postData.isBookmark ?? false);
              bookMarkChange.value++;
              await post.bookMarkPost(postData.id);
            },
          ),
          10.height,
        ],
      ),
    );

  Widget _buildPopupMenu(BuildContext context) => PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: primaryOpacity,
      itemBuilder: (context) => [
        if (postData.users?.id != userStore.userId) ...[
          PopupMenuItem(
            height: 38,
            onTap: () {
              post.showAnimatedDialog(context, postData.id, onRefresh);
            },
            value: 1,
            child: Text(languages.lblReportPost, style: primaryTextStyle(color: scaffoldColorDark)),
          ),
        ],
        if (postData.users?.id == userStore.userId) ...[
          PopupMenuItem(
            height: 38,
            onTap: () async {
              final data = await Navigator.push(
                context,
                MaterialPageRoute<String>(
                  builder: (context) => AddPostScreen(flow: 'EditFlow', postData: postData),
                ),
              );
              if (data == "refresh") onRefresh();
            },
            value: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FontAwesomeIcons.pen, size: 16, color: Colors.black),
                6.width,
                Text(languages.lblEditPost, style: primaryTextStyle(color: scaffoldColorDark)),
              ],
            ),
          ),
          PopupMenuItem<int>(
            enabled: false,
            height: 1,
            padding: EdgeInsets.zero,
            child: Container(height: 1, color: Colors.white),
          ),
          PopupMenuItem(
            height: 38,
            onTap: () {
              showConfirmDialogCustom(
                context,
                dialogType: DialogType.DELETE,
                title: languages.lblDeletePost,
                positiveText: languages.lblDelete,
                image: ic_delete,
                onAccept: (buildContext) {
                  post.deletePost(postData.id, mPostList);
                },
              );
            },
            value: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete, size: 20, color: Colors.black),
                6.width,
                Text(languages.lblDelPost, style: primaryTextStyle(color: scaffoldColorDark)),
              ],
            ),
          ),
        ],
      ],
      child: Image.asset(ic_menu, height: 24, width: 24, color: primaryColor),
    );

  Widget _buildPostContent(BuildContext context) => ValueListenableBuilder(
      valueListenable: likeChange,
      builder: (context, value, child) => GestureDetector(
        onDoubleTap: () async {
          postData.isLiked = !(postData.isLiked ?? false);
          if (postData.isLiked.validate()) {
            postData.postingLikeCount = postData.postingLikeCount.validate() + 1;
            heartVisible.value = true;
            Future.delayed(const Duration(seconds: 1), () {
              heartVisible.value = false;
            });
          } else {
            postData.postingLikeCount = postData.postingLikeCount.validate() - 1;
          }
          likeChange.value++;
          await post.likePost(postData.id);
          animationController.forward(from: 0.0);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (postData.postingMediaArray!.isNotEmpty) ...[
                  PostMediaViewer(
                    postData: postData,
                    pageController: pageController,
                    pageChange: pageChange,
                    post: post,
                    postIndex: mPostList.indexOf(postData),
                  ),
                ],
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: ExpandableLinkify(
                      text: postData.description ?? '',
                      style: primaryTextStyle(size: 16),
                      linkStyle: const TextStyle(color: primaryColor, decoration: TextDecoration.none),
                    ),
                  ),
                ).visible(!postData.description.isEmptyOrNull),
              ],
            ),
            ValueListenableBuilder<bool>(
              valueListenable: heartVisible,
              builder: (context, isVisible, _) => IgnorePointer(
                ignoring: !isVisible,
                child: AnimatedOpacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.favorite, color: Colors.redAccent, size: 100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
