import '../utils/shared_import.dart';

InterstitialAd? interstitialAd;
bool? adClosed;

Future<void> adShow() async {
  if (interstitialAd == null) {
    log('Warning: attempt to show interstitial before loaded.');
    return;
  }
  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        log('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      log('$ad onAdDismissedFullScreenContent.');
      adClosed = true;
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      log('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createInterstitialAd();
    },
  );
  await interstitialAd!.show();
}

Future<void> createInterstitialAd() async {
  final Completer<void> completer = Completer();

  InterstitialAd.load(
    adUnitId: kReleaseMode
        ? getInterstitialAdUnitId()!
        : Platform.isIOS
        ? userStore.admobInterstitialIdIos
        : userStore.admobInterstitialId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        log('$ad loaded');
        interstitialAd = ad;
        if (!completer.isCompleted) completer.complete();
      },
      onAdFailedToLoad: (LoadAdError error) {
        log('InterstitialAd failed to load: $error.');
        interstitialAd = null;
        if (!completer.isCompleted) completer.complete();
      },
    ),
  );

  return completer.future;
}

void disposeAdd() {
  interstitialAd?.dispose();
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return userStore.admobInterstitialIdIos;
  } else if (Platform.isAndroid) {
    return userStore.admobInterstitialId;
  }
  return null;
}

String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return userStore.admobBannerIdIos;
  } else if (Platform.isAndroid) {
    return userStore.admobBannerId;
  }
  return null;
}

String? getNativeAdUnitId() {
  if (Platform.isIOS) {
    return userStore.nativeAdIdIos;
  } else if (Platform.isAndroid) {
    return userStore.nativeAdId;
  }
  return null;
}

Widget showBannerAds(BuildContext context) => SizedBox(
  height: 50,
  width: MediaQuery.of(context).size.width,
  child: AdWidget(
    ad: BannerAd(
      adUnitId: getBannerAdUnitId()!,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    )..load(),
  ),
);

void loadInterstitialAds() {
  if (userStore.isSubscribe == 0) {
    createInterstitialAd();
  }
}

void showInterstitialAds() {
  if (userStore.isSubscribe == 0) {
    adShow();
  }
}

Map<int, NativeAd> ads = {};
Map<int, ValueNotifier<bool>> adLoaded = {};
Map<int, ValueNotifier<bool>> adLoading = {};

void loadAd(int index, bool shouldShowAds, bool? isBanner) {
  if (!shouldShowAds) return;

  adLoaded[index] ??= ValueNotifier(false);
  adLoading[index] ??= ValueNotifier(false);

  if (ads.containsKey(index) || adLoading[index]!.value) return;

  adLoading[index]!.value = true;

  final nativeAd = NativeAd(
    adUnitId: getNativeAdUnitId().validate(),
    factoryId: isBanner.validate() ? 'bannerTile' : 'listTile',
    request: const AdRequest(),
    listener: NativeAdListener(
      onAdLoaded: (Ad ad) {
        adLoading[index]!.value = false;
        adLoaded[index]!.value = true;
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        adLoading[index]!.value = false;
        adLoaded[index]!.value = false;
        debugPrint('Ad failed at index $index → $error');
      },
    ),
  );

  ads[index] = nativeAd;
  nativeAd.load();
}

Widget buildAdPlaceholder() => Column(
  children: [
    Container(
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 40),
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text(languages.lblAdloading, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
        ],
      ),
    ),
    20.height,
  ],
);
