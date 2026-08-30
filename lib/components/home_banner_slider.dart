import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../utils/shared_import.dart';

class HomeBannerSlider extends StatelessWidget {
  final List<BannerSliderModel>? bannerSlider;
  final PageController pageController;
  final int currentIndex;
  final void Function(int) onPageChanged;
  final bool shouldShowAds;
  final Map<int, NativeAd?> ads;
  final Map<int, ValueNotifier<bool>> adLoaded;
  final Map<int, ValueNotifier<bool>> adLoading;
  final void Function(int, bool, bool) loadAd;
  final Widget Function() buildAdPlaceholder;

  const HomeBannerSlider({
    super.key,
    required this.bannerSlider,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    required this.shouldShowAds,
    required this.ads,
    required this.adLoaded,
    required this.adLoading,
    required this.loadAd,
    required this.buildAdPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    if (bannerSlider == null || bannerSlider!.isEmpty) return const SizedBox.shrink();

    final int bannerCount = bannerSlider!.length;
    final int adCount = shouldShowAds ? (bannerCount ~/ 4) : 0;
    final int totalCount = bannerCount + adCount;

    return Column(
      children: [
        Container(
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PageView.builder(
            controller: pageController,
            itemCount: totalCount,
            onPageChanged: onPageChanged,
            itemBuilder: (context, i) {
              if (shouldShowAds && i != 0 && i % 4 == 0) {
                return _buildAdItem(i);
              }

              final index = shouldShowAds ? i - (i ~/ 4) : i;
              return _buildBannerItem(context, index);
            },
          ),
        ),
        8.height,
        _buildDotIndicator(totalCount),
      ],
    );
  }

  Widget _buildAdItem(int i) {
    final adIndex = (i ~/ 4) - 1;
    adLoaded[adIndex] ??= ValueNotifier(false);
    adLoading[adIndex] ??= ValueNotifier(false);

    if (!ads.containsKey(adIndex) && adLoading[adIndex]?.value != true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadAd(adIndex, shouldShowAds, true);
      });
    }

    return ValueListenableBuilder<bool>(
      valueListenable: adLoaded[adIndex]!,
      builder: (context, loaded, _) {
        if (!loaded) return buildAdPlaceholder();
        return SizedBox(
          height: 200,
          child: AdWidget(ad: ads[adIndex]!),
        );
      },
    );
  }

  Widget _buildBannerItem(BuildContext context, int index) {
    final banner = bannerSlider![index];
    return GestureDetector(
      onTap: () async {
        if (banner.type == 'url') {
          final url = banner.url ?? '';
          if (url.isNotEmpty) {
            final uri = WebUri(url);
            final browser = ChromeSafariBrowser();
            await browser.open(
              url: uri,
              settings: ChromeSafariBrowserSettings(
                showTitle: true,
                keepAliveEnabled: true,
              ),
            );
          }
        } else {
          WorkoutDetailScreen(id: banner.workoutId).launch<void>(context);
        }
      },
      child: cachedImage(
        banner.bannersliderImage ?? '',
        height: 150,
        fit: BoxFit.fill,
      ).cornerRadiusWithClipRRect(16),
    );
  }

  Widget _buildDotIndicator(int totalCount) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 22 : 10,
          height: 6,
          decoration: BoxDecoration(
            color: currentIndex == index ? primaryColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );

}
