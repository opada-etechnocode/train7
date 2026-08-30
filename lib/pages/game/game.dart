import 'package:animated_background/animated_background.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../../logic/game_data.dart';
import '../../utils/shared_import.dart' hide CountDownController;
import 'components/game_color_grid.dart';
import 'components/game_over_dialog_content.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  GameData gameData = GameData();

  late Timer timer;
  int timeLeft = 5;

  int gridSize = 2;
  Color? targetColor;
  Color? dummyColor;

  Random random = Random();

  var isReverse = false;

  final CountDownController _controllerTime = CountDownController();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAnimating = false;
  Offset _startPosition = Offset.zero;
  Offset _endPosition = Offset.zero;
  final List<GlobalKey> _boxKeys = List.generate(100, (_) => GlobalKey());
  final GlobalKey _actionBarKey = GlobalKey();

  @override
  void dispose() {
    timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    gridSize = gameData.getGridSize();
    gameData.targetIndex = random.nextInt(pow(gridSize, 2).toInt() - 1);
    nextColor();
    startTimer();
  }



  Future<void> saveScoreApi() async {
    log("-------->>>${getStringAsync(COUNTRY_CODE)}");
    if (gameData.score > 10 && userStore.isLoggedIn) {
      final Map<String, dynamic> req = {
        'score': gameData.score,
        'country_code': getStringAsync(COUNTRY_CODE),
      };
      await saveScore(req).then((value) {}).catchError((dynamic e){log("$e");});
    }
  }

  void _startAnimation(int index) {
    final RenderBox? box =
        _boxKeys[index].currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? actionBar =
        _actionBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      setState(() {
        _isAnimating = true;
        _startPosition = box.localToGlobal(Offset.zero);
        _endPosition = actionBar!.localToGlobal(
          Offset(actionBar.size.width - 40, -8),
        );
      });

      // Reset animation after completion
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _isAnimating = false;
        });
      });
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (gameData.isPlaying) {
        if (timeLeft == 0) {
          setState(() {
            timer.cancel();
          });
          endGame();
        } else {
          setState(() {
            timeLeft--;
          });
        }
      }
    });
  }

  void nextLevel(int index) {
    setState(() {
      _startAnimation(index);
      gameData.nextLevel(timeLeft);
      gridSize = gameData.getGridSize();
      //_controller.isStarted;
      _playSound('sounds/coins.mp3');
      timeLeft = gameData.level >= 15 ? 10 : 5;
      _controllerTime.restart(duration: timeLeft);
    });
    nextColor();
  }

  Future<void> endGame() async {
    setState(() {
      gameData.endGame();
      _playSound('sounds/wrong.mp3');
    });
    if (!mounted) return;
    _showGameOverDialog(context);
    saveScoreApi();
  }

  /* void continuePlaying() {
    setState(() {
      gameData.isPlaying = true;
      // timeLeft = 10;
    });
    startTimer();
    nextLevel();
  }*/
  Future<void> _playSound(String filePath) async {
    await _audioPlayer.play(AssetSource(filePath));
  }

  void nextColor() {
    // Random random = Random();
    final int r = random.nextInt(255);
    final int g = random.nextInt(255);
    final int b = random.nextInt(255);

    const int minOffset = 6;
    int offset = 50;

    if (gridSize == 3) {
      offset = 25;
    } else if (gridSize == 4) {
      offset = 12;
    } else if (gridSize == 5) {
      offset = 6;
    }

    // Offset is always guaranteed to be exactly the same.
    int rOffset = minOffset + random.nextInt(offset);
    int gOffset = minOffset + random.nextInt(offset);
    int bOffset = minOffset + random.nextInt(offset);

    if (r + rOffset > 255) {
      rOffset = -rOffset;
    }
    if (g + gOffset > 255) {
      gOffset = -gOffset;
    }
    if (b + bOffset > 255) {
      bOffset = -bOffset;
    }

    setState(() {
      targetColor = Color.fromRGBO(r + rOffset, g + gOffset, b + bOffset, 1.0);
      dummyColor = Color.fromRGBO(r, g, b, 1);
    });
  }

  int normalize(int value, {int min = 0, int max = 255}) {
    if (value < min) {
      return min;
    } else if (value > max) {
      return max;
    } else {
      return (min + (value * (max - min) / max)).floor();
    }
  }

  ParticleOptions particleOptions = const ParticleOptions(
    baseColor: primaryColor,
    // maxOpacity: 0.3,
    spawnMinSpeed: 30.0,
    spawnMaxSpeed: 70.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 40,
  );

  var particlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    backgroundColor: appStore.isDarkMode ? socialBackground : Colors.white,
    body: AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: particleOptions,
        paint: particlePaint,
      ),
      vsync: this,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 5,
              right: 0,
              child: Row(
                key: _actionBarKey,
                children: [
                  Image.asset(ic_coin, height: 27, width: 27),
                  10.width,
                  Text("${gameData.score}", style: primaryTextStyle(size: 22)),
                  10.width,
                ],
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      finish(context);
                    },
                    child: const Icon(
                      Octicons.chevron_left,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),
                  10.width,
                  Text(
                    "${languages.lblLevel}: ${gameData.level}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appStore.isDarkMode
                          ? Colors.white
                          : scaffoldColorDark,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularCountDownTimer(
                    duration: timeLeft,
                    controller: _controllerTime,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 3,
                    ringColor: Colors.grey[300]!,
                    fillColor: primaryLightColor,
                    backgroundColor: primaryColor,
                    strokeWidth: 13.0,
                    strokeCap: StrokeCap.round,
                    textStyle: const TextStyle(
                      fontSize: 33.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textFormat: CountdownTextFormat.S,
                    isReverse: true,
                    isReverseAnimation: true,
                  ),
                  GameColorGrid(
                    gridSize: gridSize,
                    targetIndex: gameData.targetIndex.validate(),
                    targetColor: targetColor,
                    dummyColor: dummyColor,
                    boxKeys: _boxKeys,
                    onCellTap: (index) async {
                      if (gameData.targetIndex == index) {
                        nextLevel(index);
                      } else {
                        endGame();
                      }
                    },
                  ),
                ],
              ),
            ),
            if (_isAnimating)
              TweenAnimationBuilder(
                tween: Tween<Offset>(begin: _startPosition, end: _endPosition),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                builder: (context, Offset value, child) => Positioned(
                  left: value.dx,
                  top: value.dy,
                  child: Hero(
                    tag: 'coin',
                    child: Image.asset(ic_coin, height: 27, width: 27),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  void _showGameOverDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => GameOverDialogContent(
        level: gameData.level,
        onExit: () async {
          Navigator.pop(context, true);
          Navigator.pop(context, true);
        },
      ),
    );
  }
}
