import 'package:audioplayers/audioplayers.dart';

import '../../utils/shared_import.dart';

class GameHomeScreen extends StatefulWidget {
  const GameHomeScreen({super.key});

  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  final buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
  );

  var colorizeColors = [Colors.black, Colors.blue, Colors.orange, Colors.red];

  var colorizeTextStyle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  final AudioPlayer _audioPlayer = AudioPlayer();
  final now = DateTime.now();
  bool loadingAd = false;

  Future<void> _playSound(String filePath) async {
    await _audioPlayer.play(AssetSource(filePath));
    if (!mounted) return;
    Navigator.of(context).push(Routes.createRoute(context));
  }

  Future<void> loadAds() async {
    adClosed = false;
    setState(() {
      loadingAd = true;
    });
    await createInterstitialAd();
    await adShow();
    setState(() {
      loadingAd = false;
    });
    while (!adClosed!) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: appStore.isDarkMode ? socialBackground : Colors.white,
    appBar: AppBar(
      backgroundColor: appStore.isDarkMode ? socialBackground : Colors.white,
      title: Text(
        languages.lblMightyBrainWorkout,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: appStore.isDarkMode ? Colors.white : scaffoldColorDark,
          fontSize: 18,
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          finish(context);
        },
        child: const Icon(Octicons.chevron_left, color: primaryColor, size: 28),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            showLeaderboardBottomSheet(context);
          },
          child: Image.asset(
            scoreboard,
            height: 30,
            width: 30,
            color: appStore.isDarkMode ? Colors.white : scaffoldColorDark,
          ),
        ).paddingSymmetric(horizontal: 10),
      ],
    ),
    body: SafeArea(
      bottom: Platform.isAndroid ? true : false,
      left: false,
      right: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  ColorizeAnimatedText(
                    languages.lblGameTitle,
                    textStyle: colorizeTextStyle,
                    textAlign: TextAlign.center,
                    colors: colorizeColors,
                  ),
                ],
              ),
            ),
            //  Text(languages.lblFindadifferentcolortocheckbrainworkout, textAlign: TextAlign.center, style: primaryTextStyle(size: 25)),
            Lottie.asset('assets/mindgif.json', width: 300, height: 300),
            50.height,
            ElevatedButton(
              onPressed: () async {

                if (userStore.showAdsOnGame == 1 &&
                    userStore.isSubscribe == 0) {
                  await loadAds();
                }
                _playSound('sounds/startplay.mp3');
                /* } else {
                    final hoursSinceLastClick = await _getHoursSinceLastClick();
                    final hoursRemaining = 24 - (hoursSinceLastClick ?? 0);
                    log("---------121>>>${hoursRemaining}");
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.success(
                        backgroundColor: primaryColor,
                        message:
                            "${languages.lblPleaseWait} ${hoursRemaining.floor()} ${languages.lblHoursAfterPlayAgain}",
                      ),
                    );
                  }*/
              },
              style: buttonStyle,
              child: loadingAd
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: const Loader().center(),
                    )
                  : Text(
                      languages.lblStart,
                      style: primaryTextStyle(
                        weight: FontWeight.bold,
                        size: 18,
                        color: appStore.isDarkMode
                            ? Colors.white
                            : scaffoldColorDark,
                      ),
                    ),
            ),
          ],
        ),
      ),
    ),
  );

  void showLeaderboardBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LeaderboardBottomSheet(),
    );
  }
}
