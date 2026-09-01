import 'package:mobx/mobx.dart';
import '../utils/shared_import.dart';

/// Shared post card widget used by Community, Bookmark, and PostDetails screens.
/// Renders post header, media, description, and action bar (like, comment, share, bookmark).
class PostCardWidget extends StatelessWidget {
  final PostData postData;
  final int? apiPostId;
  final int? apiUserId;
  final bool canEdit;
  final bool showPopupMenu;
  final bool fromBookmark;
  final int index;
  final VoidCallback? onRefresh;
  final Post post;
  final LikeComment likeComment;
  final ValueNotifier<int> likeChange;
  final ValueNotifier<int> bookMarkChange;
  final ValueNotifier<int> pageChange;
  final ValueNotifier<bool> heartVisible;
  final PageController pageController;
  final bool isBottomSheetOpen;
  final void Function(bool) onBottomSheetOpenChanged;
  final ObservableList<dynamic>? mPostList;
  final bool useExpandableLinkify;
  final EdgeInsets? margin;

  const PostCardWidget({
    super.key,
    required this.postData,
    required this.apiPostId,
    required this.apiUserId,
    required this.canEdit,
    required this.showPopupMenu,
    required this.fromBookmark,
    required this.index,
    this.onRefresh,
    required this.post,
    required this.likeComment,
    required this.likeChange,
    required this.bookMarkChange,
    required this.pageChange,
    required this.heartVisible,
    required this.pageController,
    required this.isBottomSheetOpen,
    required this.onBottomSheetOpenChanged,
    this.mPostList,
    this.useExpandableLinkify = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) => Card(
   elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Column(
      children: [
        _buildHeader(context),
        ValueListenableBuilder(
          valueListenable: likeChange,
          builder: (BuildContext context, int value, Widget? child) => GestureDetector(
            onDoubleTap: _onDoubleTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildMedia(context), _buildDescription(context)],
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: heartVisible,
                  builder: (BuildContext context, bool isVisible, Widget? _) => IgnorePointer(
                    ignoring: !isVisible,
                    child: AnimatedOpacity(
                      opacity: isVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 0.25).paddingSymmetric(horizontal: 8),
        4.height,
        _buildActionBar(context),
        10.height,
      ],
    ),
  );

  Widget _buildHeader(BuildContext context) {
    final users = postData.users;
    final displayName = users?.displayName ?? '';
    final profileImage = users?.profileImage ?? '';
    final createdAt = postData.createdAt ?? '';

    Widget headerContent = Row(
      children: [
        cachedImage(
          profileImage,
          fit: BoxFit.cover,
          height: 40,
          width: 40,
        ).cornerRadiusWithClipRRect(20),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayName, style: boldTextStyle(size: 16), maxLines: 3),
            5.height,
            Text(
              "${languages.posted} $createdAt",
              style: secondaryTextStyle(
                size: 12,
                color: textSecondaryColorGlobal,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (showPopupMenu) _buildPopupMenu(context),
      ],
    );

    if (showPopupMenu) {
      headerContent = GestureDetector(
        onTap: () => _onUserTap(context),
        child: headerContent,
      );
    }

    return headerContent.paddingSymmetric(horizontal: 10, vertical: 16);
  }

  void _onUserTap(BuildContext context) {
    if (postData.userId != null && postData.userId != userStore.userId) {
      if (postData.users != null) {
        OtherUserProfileScreen(userDetails: postData.users!).launch<void>(context);
      }
    } else {
      const EditProfileScreen().launch<void>(context);
    }
  }

  Widget _buildPopupMenu(BuildContext context) {
    final users = postData.users;
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: primaryOpacity,
      itemBuilder: (BuildContext context) => [
        if (users?.id != userStore.userId)
          PopupMenuItem(
            height: 38,
            onTap: () {
              post.showAnimatedDialog(context, postData.id, () {
                onRefresh?.call();
              });
            },
            value: 1,
            child: Text(
              languages.lblReportPost,
              style: primaryTextStyle(color: scaffoldColorDark),
            ),
          ),
        if (users?.id == userStore.userId) ...[
          PopupMenuItem(
            height: 38,
            onTap: () async {
              final data = await Navigator.push(
                context,
                MaterialPageRoute<String>(
                  builder: (BuildContext context) => AddPostScreen(
                    flow: 'EditFlow',
                    postData:
                        fromBookmark &&
                            mPostList != null &&
                            index < mPostList!.length
                        ? _getPostDataFromItem(mPostList![index])
                        : postData,
                  ),
                ),
              );
              if (data == "refresh") {
                onRefresh?.call();
              }
            },
            value: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.pen , size: 16, color: Colors.black),
                6.width,
                Text(
                  languages.lblEditPost,
                  style: primaryTextStyle(color: scaffoldColorDark),
                ),
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
                onAccept: (BuildContext buildContext) {
                  if (mPostList != null) {
                    post.deletePost(postData.id, mPostList!);
                  }
                },
              );
            },
            value: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete, size: 20, color: Colors.black),
                6.width,
                Text(
                  languages.lblDelPost,
                  style: primaryTextStyle(color: scaffoldColorDark),
                ),
              ],
            ),
          ),
        ],
      ],
      child: Image.asset(ic_menu, height: 24, width: 24, color: primaryColor),
    );
  }

  PostData? _getPostDataFromItem(dynamic item) {
    if (item is BookmarkData) {
      return item.posts;
    }
    if (item is PostData) {
      return item;
    }
    return null;
  }

  Widget _buildMedia(BuildContext context) {
    final mediaArray = postData.postingMediaArray ?? [];
    if (mediaArray.isEmpty) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder(
      valueListenable: pageChange,
      builder: (BuildContext context, int value, Widget? child) => Column(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double size = constraints.maxWidth;
              return SizedBox(
                height: size,
                width: size,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (_) => pageChange.value++,
                  itemCount: mediaArray.length,
                  itemBuilder: (BuildContext context, int mediaIndex) {
                    final media = mediaArray[mediaIndex];
                    if (media.mimeType == "image/jpeg" ||
                        media.mimeType == "image/png") {
                      return cachedImage(
                            media.url,
                            height: size,
                            width: size,
                            fit: BoxFit.cover,
                          )
                          .cornerRadiusWithClipRRect(10)
                          .onTap(() {
                            final List<String> urls = mediaArray
                                .map((e) => e.url.validate())
                                .toList();
                            post.showFullScreenDialog(
                              context,
                              urls,
                              postData.users?.displayName ?? '',
                              mediaIndex,
                            );
                          })
                          .paddingSymmetric(horizontal: 10);
                    } else {
                      return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ChewieScreen(
                              url: media.url ?? '',
                              image: "",
                              autoPlay: true,
                            ),
                          )
                          .onTap(() {
                            final List<String> urls = mediaArray
                                .map((e) => e.url.validate())
                                .toList();
                            post.showFullScreenDialog(
                              context,
                              urls,
                              postData.users?.displayName ?? '',
                              mediaIndex,
                            );
                          })
                          .paddingSymmetric(horizontal: 10);
                    }
                  },
                ),
              );
            },
          ),
          7.height,
          SmoothPageIndicator(
            controller: pageController,
            count: mediaArray.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 5,
              dotWidth: 5,
              activeDotColor: primaryColor,
            ),
          ).visible(mediaArray.length > 1),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final description = postData.description ?? '';
    if (description.isEmptyOrNull) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: useExpandableLinkify
            ? ExpandableLinkify(
                text: description,
                style: primaryTextStyle(size: 16),
                linkStyle: const TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.none,
                ),
              )
            : ReadMoreText(
                description,
                trimLines: 3,
                trimMode: TrimMode.Line,
                trimCollapsedText: languages.readMore,
                trimExpandedText: languages.readLess,
                colorClickableText: primaryColor,
                style: primaryTextStyle(size: 16),
              ),
      ),
    );
  }

  Future<void> _onDoubleTap() async {
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
    await post.likePost(apiPostId ?? postData.id);
  }

  Widget _buildActionBar(BuildContext context) {
    final iconColor = appStore.isDarkMode ? GreyLightColor : Colors.black;

    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: likeChange,
          builder: (BuildContext context, int value, Widget? child) => Image.asset(
            postData.isLiked.validate() ? ic_like_filled : ic_like,
            color: postData.isLiked.validate() ? Colors.red : iconColor,
            height: 21,
            width: 21,
          ).onTap(_onLikeTap),
        ),
        5.width,
        GestureDetector(
          onTap: () => _onLikeCountTap(context),
          child: ValueListenableBuilder(
            valueListenable: likeChange,
            builder: (BuildContext context, int value, Widget? child) => Row(
              children: [
                Text(
                  '${(postData.postingLikeCount ?? 0)}',
                  style: primaryTextStyle(size: 17),
                ),
                Text(
                  (postData.postingLikeCount ?? 0) <= 1
                      ? ' ${languages.lblLike}'
                      : ' ${languages.lblLikes}',
                  style: secondaryTextStyle(
                    size: 15,
                    color: textSecondaryColorGlobal,
                  ),
                ),
              ],
            ),
          ),
        ),
        15.width,
        GestureDetector(
          onTap: () => _onCommentTap(context),
          child: SizedBox(
            child: Row(
              children: [
                Image.asset(
                  ic_comment,
                  height: 20,
                  width: 20,
                  color: iconColor,
                ),
                5.width,
                Text(
                  '${(postData.postingCommentCount ?? 0)}',
                  style: primaryTextStyle(size: 17),
                ),
                Text(
                  (postData.postingCommentCount ?? 0) <= 1
                      ? ' ${languages.lblCmt}'
                      : ' ${languages.lblComments}',
                  style: secondaryTextStyle(
                    size: 15,
                    color: textSecondaryColorGlobal,
                  ),
                ),
              ],
            ),
          ),
        ),
        15.width,
        GestureDetector(
          onTap: () {
            final String postLink = '$mBackendURL/post/${postData.id}';
            Share.share('${languages.checkOutPost} $postLink');
          },
          child: SizedBox(
            child: Row(
              children: [
                Image.asset(
                  ic_share_community,
                  height: 20,
                  width: 20,
                  color: iconColor,
                ),
                5.width,
                Text(
                  languages.share,
                  style: secondaryTextStyle(
                    size: 15,
                    color: textSecondaryColorGlobal,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        ValueListenableBuilder(
          valueListenable: bookMarkChange,
          builder: (context, value, child) => Image.asset(
            postData.isBookmark ?? false ? ic_save_filled : ic_save,
            color: iconColor,
            height: 20,
            width: 20,
          ).onTap(_onBookmarkTap),
        ),
      ],
    ).paddingSymmetric(horizontal: 10);
  }

  Future<void> _onLikeTap() async {
    postData.isLiked = !(postData.isLiked ?? false);
    if (postData.isLiked.validate()) {
      postData.postingLikeCount = postData.postingLikeCount.validate() + 1;
    } else {
      postData.postingLikeCount = postData.postingLikeCount.validate() - 1;
    }
    likeChange.value++;
    await post.likePost(apiPostId ?? postData.id);
  }

  Future<void> _onLikeCountTap(BuildContext context) async {
    if ((postData.postingLikeCount ?? 0) == 0) {
      return;
    }
    if (isBottomSheetOpen) {
      return;
    }
    onBottomSheetOpenChanged(true);
    likeComment.mLikeList.clear();
    likeComment.pageLike = 1;
    likeComment.bottomSheetForLike(
      index,
      apiPostId ?? postData.id,
      apiUserId ?? 0,
      context,
      isFirstTime: true,
    );
    await likeComment.likesList(apiPostId ?? postData.id, isFirstTime: true);
    onBottomSheetOpenChanged(false);
  }

  Future<void> _onCommentTap(BuildContext context) async {
    if (isBottomSheetOpen) {
      return;
    }
    onBottomSheetOpenChanged(true);
    likeComment.mCommentList.clear();
    likeComment.pageComment = 1;
    likeComment.bottomSheetBuilder(
      index,
      apiPostId ?? postData.id,
      apiUserId ?? 0,
      canEdit,
      context,
      mPostList ?? [postData],
      isFirstTime: true,
      fromBookmark: fromBookmark,
    );
    await likeComment.commentList(apiPostId ?? postData.id, isFirstTime: true);
    onBottomSheetOpenChanged(false);
  }

  Future<void> _onBookmarkTap() async {
    postData.isBookmark = !(postData.isBookmark ?? false);
    bookMarkChange.value++;
    await post.bookMarkPost(postData.id, fn: fromBookmark ? onRefresh : null);
  }
}
