import '../utils/shared_import.dart';

/// Action bar for post cards showing like, comment, share, and bookmark buttons.
///
/// Developer: Ashika Bhanderi
/// Updated: 2026-03-12 12:21:00
///
/// Reasoning:
/// - Extracted from OtherUserProfileScreen to comply with the 200-line widget rule
/// - Centralizes post action bar UI for reuse across different post list screens
class PostActionBar extends StatelessWidget {
  final PostData postData;
  final ValueNotifier<int> likeChange;
  final ValueNotifier<int> bookMarkChange;
  final VoidCallback onLikeTap;
  final VoidCallback onLikeCountTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onBookmarkTap;

  const PostActionBar({
    super.key,
    required this.postData,
    required this.likeChange,
    required this.bookMarkChange,
    required this.onLikeTap,
    required this.onLikeCountTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) => Row(
      children: [
        _buildLikeButton(),
        5.width,
        _buildLikeCount(),
        15.width,
        _buildCommentButton(context),
        15.width,
        _buildShareButton(),
        const Spacer(),
        _buildBookmarkButton(),
      ],
    ).paddingSymmetric(horizontal: 10);

  Widget _buildLikeButton() => ValueListenableBuilder(
      valueListenable: likeChange,
      builder: (context, value, child) => Image.asset(
        postData.isLiked.validate() ? ic_like_filled : ic_like,
        color: postData.isLiked.validate()
            ? Colors.red
            : appStore.isDarkMode
                ? GreyLightColor
                : Colors.black,
        height: 21,
        width: 21,
      ).onTap(onLikeTap),
    );

  Widget _buildLikeCount() => GestureDetector(
      onTap: onLikeCountTap,
      child: ValueListenableBuilder(
        valueListenable: likeChange,
        builder: (context, value, child) => Row(
          children: [
            Text(
              '${(postData.postingLikeCount ?? 0)}',
              style: primaryTextStyle(size: 17),
            ),
            Text(
              (postData.postingLikeCount! <= 1)
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
    );

  Widget _buildCommentButton(BuildContext context) => GestureDetector(
      onTap: onCommentTap,
      child: SizedBox(
        child: Row(
          children: [
            Image.asset(
              ic_comment,
              height: 20,
              width: 20,
              color: appStore.isDarkMode ? GreyLightColor : Colors.black,
            ),
            5.width,
            Text(
              '${(postData.postingCommentCount ?? 0)}',
              style: primaryTextStyle(size: 17),
            ),
            Text(
              (postData.postingCommentCount! <= 1)
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
    );

  Widget _buildShareButton() => GestureDetector(
      onTap: onShareTap,
      child: SizedBox(
        child: Row(
          children: [
            Image.asset(
              ic_share_community,
              height: 20,
              width: 20,
              color: appStore.isDarkMode ? GreyLightColor : Colors.black,
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
    );

  Widget _buildBookmarkButton() => ValueListenableBuilder(
      valueListenable: bookMarkChange,
      builder: (context, value, child) => Image.asset(
        postData.isBookmark ?? false ? ic_save_filled : ic_save,
        color: appStore.isDarkMode ? GreyLightColor : Colors.black,
        height: 20,
        width: 20,
      ).onTap(onBookmarkTap),
    );
}
