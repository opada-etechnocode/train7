import '../utils/shared_import.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final String? url;
  final String? img;
  final bool? autoPlay;
  final bool? hideControl;

  const YoutubePlayerScreen({
    super.key,
    this.url,
    this.img,
    this.autoPlay = false,
    this.hideControl = false,
  });

  @override
  YoutubePlayerScreenState createState() => YoutubePlayerScreenState();
}

class YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController youtubePlayerController;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  bool _isPlayerReady = false;
  String videoId = '';

  bool visibleOption = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    videoId = YoutubePlayer.convertUrlToId(widget.url!)!;
    log("--------50>>>$videoId");

    youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        hideControls: widget.hideControl ?? false,
        showLiveFullscreenButton: false,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
  }

  void fullScreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
  }

  void exitScreen() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  void listener() {
    if (_isPlayerReady &&
        mounted &&
        !youtubePlayerController.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    youtubePlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    _idController.dispose();
    _seekToController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (details.delta.dy < 0) {
      //  setState(() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      //   });
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onVerticalDragUpdate: (widget.hideControl == false) ? _onDragUpdate : null,
    child: YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      },
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      },
      player: YoutubePlayer(
        controller: youtubePlayerController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.white,
        //  thumbnail: cachedImage(widget.img, fit: BoxFit.fill, height: context.height()).cornerRadiusWithClipRRect(0),
        progressColors: ProgressBarColors(
          playedColor: Colors.white,
          bufferedColor: Colors.grey.shade200,
          handleColor: Colors.white,
          backgroundColor: Colors.grey,
        ),
        topActions: <Widget>[
          if (MediaQuery.of(context).orientation == Orientation.landscape)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.only(top: context.statusBarHeight + 20),
                icon: const Icon(Icons.close, color: Colors.white, size: 25.0),
                onPressed: exitScreen,
              ),
            ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          //
        },
      ),
      // ignore: deprecated_member_use
      builder: (context, player) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          exitScreen();
        },
        child: Scaffold(
          body: SizedBox(
            height: context.height(),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    player,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.gobackward_10,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            final Duration currentPosition =
                                youtubePlayerController.value.position;
                            final Duration targetPosition =
                                currentPosition - const Duration(seconds: 10);
                            youtubePlayerController.seekTo(targetPosition);
                          },
                        ).visible(
                          !youtubePlayerController.value.isPlaying &&
                              _isPlayerReady,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_isPlayerReady) {
                              youtubePlayerController.value.isPlaying
                                  ? youtubePlayerController.pause()
                                  : youtubePlayerController.play();
                              setState(() {});
                            }
                          },
                          child: const SizedBox(height: 50, width: 50),
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.goforward_10,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            final Duration currentPosition =
                                youtubePlayerController.value.position;
                            final Duration targetPosition =
                                currentPosition + const Duration(seconds: 10);
                            youtubePlayerController.seekTo(targetPosition);
                          },
                        ).visible(
                          !youtubePlayerController.value.isPlaying &&
                              _isPlayerReady,
                        ),
                      ],
                    ),
                  ],
                ).center(),
                if (visibleOption)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        onPressed: exitScreen,
                      ),
                      Platform.isAndroid
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                SimplePip(
                                  onPipEntered: () {
                                    visibleOption = false;
                                    setState(() {});
                                  },
                                  onPipExited: () {
                                    visibleOption = true;
                                    setState(() {});
                                  },
                                ).enterPipMode();
                              },
                              icon: const Icon(
                                Icons.picture_in_picture_alt_outlined,
                                color: Colors.white,
                                size: 25.0,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ).paddingOnly(top: 30, left: 8, right: 8),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
