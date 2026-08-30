import '../utils/shared_import.dart';

/// A widget that displays post media (images and videos) in a PageView
/// with a smooth page indicator.
///
/// Developer: Ashika Bhanderi
/// Updated: 2026-03-12 12:21:00
///
/// Reasoning:
/// - Extracted from OtherUserProfileScreen to comply with the 200-line widget rule
/// - Reusable for any screen displaying post media galleries
class PostMediaViewer extends StatelessWidget {
  final PostData postData;
  final PageController pageController;
  final ValueNotifier<int> pageChange;
  final Post post;
  final int postIndex;

  const PostMediaViewer({
    super.key,
    required this.postData,
    required this.pageController,
    required this.pageChange,
    required this.post,
    required this.postIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (postData.postingMediaArray == null ||
        postData.postingMediaArray!.isEmpty) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder(
      valueListenable: pageChange,
      builder: (context, value, child) => Column(
        children: [
          _buildMediaPageView(context),
          7.height,
          SmoothPageIndicator(
            controller: pageController,
            count: postData.postingMediaArray!.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 5,
              dotWidth: 5,
              activeDotColor: primaryColor,
            ),
          ).visible(postData.postingMediaArray!.length > 1),
        ],
      ),
    );
  }

  Widget _buildMediaPageView(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final double size = constraints.maxWidth;
        return SizedBox(
          height: size,
          width: size,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (page) {
              pageChange.value++;
            },
            itemCount: postData.postingMediaArray!.length,
            itemBuilder: (context, mediaIndex) {
              final media = postData.postingMediaArray![mediaIndex];
              return _buildMediaItem(context, media, size);
            },
          ),
        );
      },
    );

  Widget _buildMediaItem(
    BuildContext context,
    PostingMediaArray media,
    double size,
  ) {
    final List<String> urls = [];
    postData.postingMediaArray?.forEach((e) {
      urls.add(e.url.validate());
    });

    if (media.mimeType == "image/jpeg" || media.mimeType == "image/png") {
      return cachedImage(
        media.url,
        height: size,
        width: size,
        fit: BoxFit.cover,
      )
          .cornerRadiusWithClipRRect(10)
          .onTap(() async {
            post.showFullScreenDialog(
              context,
              urls,
              postData.users?.displayName ?? '',
              postIndex,
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
          .onTap(() async {
            post.showFullScreenDialog(
              context,
              urls,
              postData.users?.displayName ?? '',
              postIndex,
            );
          })
          .paddingSymmetric(horizontal: 10);
    }
  }
}
