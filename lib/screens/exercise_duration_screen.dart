import '../utils/shared_import.dart';

class ExerciseDurationScreen extends StatefulWidget {
  static String tag = '/ExerciseDurationScreen';
  final ExerciseDetailResponse? mExerciseModel;
  final String? workOutId;
  final int? workoutDayId;

  const ExerciseDurationScreen(
    this.mExerciseModel,
    this.workOutId,
    this.workoutDayId, {
    super.key,
  });

  @override
  ExerciseDurationScreenState createState() => ExerciseDurationScreenState();
}

class ExerciseDurationScreenState extends State<ExerciseDurationScreen>
    with TickerProviderStateMixin {
  CountDownController mCountDownController = CountDownController();
  var mode = "portrait";
  bool _isInitialized = false;
  String? durationstring;
  Duration? duration1;
  String _currentTime = '0:00';
  String _totalTime = '0:00';
  double _videoProgress = 0.0;


  final castManager = CastManager();
  bool isLoading = false;

  late FlutterTts flutterTts;

  //  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _controller;
  GoogleCastOptions? options;

  int? bufferDelay;
  bool? isChanged = false;
  YoutubePlayerController? youtubePlayerController;
  TextEditingController? _idController;
  late TextEditingController _seekToController;
  late PlayerState _playerState;
  late YoutubeMetaData videoMetaData;
  final bool _isPlayerReady = false;
  String? videoId = '';

  bool visibleOption = true;
  bool isFirstCall = true;

  bool _isCurrentlyLandscape = false;
  bool _isShowControllar = false;
  bool _isMuted = false;
  bool _isPlaying = false;
  Timer? _hideTimer;

  int page = 1;
  int? numPage;
  int currentTabIndex = 0;
  bool isLastPage = false;
  ScrollController scrollController = ScrollController();
  List<DayExerciseModel> mDayExerciseList = [];
  List<WorkoutDay>? mUpNextDayList = [];

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    init();
    getDayExerciseData();
    castManager.initPlatformState();
    GoogleCastDiscoveryManager.instance.startDiscovery();
    flutterTts = FlutterTts();
    initializePlayer();
    _setOrientation(isLandscape: false);
    initPlatformState();
    // GoogleCastDiscoveryManager.instance.startDiscovery();
    // GoogleCastDiscoveryManager.instance.devicesStream.listen((devices) {
    //   log("Devices Found: ${devices.map((e) => e.friendlyName).join(", ")}");
    // });
    // GoogleCastSessionManager.instance.currentSessionStream.listen((session) {
    //   log("Session updated: $session");
    // });
  }

  Future<void> init() async {
    durationstring = widget.mExerciseModel!.data!.duration.validate();
    duration1 = parseDuration(durationstring!);
    if (widget.mExerciseModel!.data!.duration != null &&
        widget.mExerciseModel!.data!.videoUrl.validate().contains(
          "https://youtu",
        )) {
      duration1 = parseDuration(
        widget.mExerciseModel!.data!.duration.validate(),
      );
    }

    if (videoId != null) {
      videoId = YoutubePlayer.convertUrlToId(
        widget.mExerciseModel!.data!.videoUrl.validate(),
      );
    }
    if (videoId != null) {
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(showLiveFullscreenButton: false),
      )..addListener(listener);
    }
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    if (youtubePlayerController != null) {
      youtubePlayerController!.addListener(() {
        if (_playerState == PlayerState.playing) {
          if (isChanged == true) {
            mCountDownController.resume();
            isChanged = false;
          }
        }
        if (_playerState == PlayerState.paused) {
          mCountDownController.pause();
          flutterTts.pause();
          isChanged = true;
        }
      });
    }
    videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  Future<void> getDayExerciseData() async {
    await getDayExerciseDetailApi(
          widget.mExerciseModel!.data!.id!,
          widget.workoutDayId,
          widget.workOutId,
        )
        .then((value) {
          mUpNextDayList = value.data;
          appStore.setLoading(false);
          isLoading = false;
          setState(() {});
        })
        .catchError((e, s) {
          isLastPage = true;
          isLoading = false;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  Future<void> _prepareForCasting() async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
    }
    await _controller.setVolume(0.0);
    _isPlaying = false;
  }

  Future<void> initializePlayer() async {
    log("-------------135>>>${widget.mExerciseModel?.data?.videoUrl ?? ''}");
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.mExerciseModel?.data?.videoUrl ?? ''),
    );
    // await Future.wait([_controller.initialize()]);
    await _controller.initialize();
    _controller.setLooping(true);
    _isInitialized = true;
    setState(() {});
    if (_controller.value.isInitialized) {
      _controller.play();
      _isPlaying = true;
    }
    _controller.addListener(() {
      if (_controller.value.isInitialized) {
        // _videoProgress = _controller.value.position.inMilliseconds / _controller.value.duration.inMilliseconds;

        final position = _controller.value.position.inMilliseconds.toDouble();
        final duration = _controller.value.duration.inMilliseconds.toDouble();
        _videoProgress = duration > 0
            ? (position / duration).clamp(0.0, 1.0)
            : 0.0;

        //_controller.setVolume(0.0);
        _currentTime = _formatDuration(_controller.value.position);
        _totalTime = _formatDuration(_controller.value.duration);
        if (mounted) {
          setState(() {});
        }
      }

      if (_controller.value.isPlaying) {
        log('Video is playing');
        if (isChanged == true) {
          mCountDownController.resume();
          isChanged = false;
        }
      } else if (_controller.value.isBuffering) {
        log('Video is buffering');
      } else if (_controller.value.isInitialized) {
        mCountDownController.pause();
        flutterTts.pause();
        isChanged = true;
      } else {
        log('Video controller is in an unknown state');
      }
    });
    setState(() {});
  }

  Future<void> initPlatformState({
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    try {
      const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
      log("Initializing Google Cast with appId: $appId");

      if (Platform.isIOS) {
        options = IOSGoogleCastOptions(
          GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(appId),
        );
      } else if (Platform.isAndroid) {
        options = GoogleCastOptionsAndroid(appId: appId);
      } else {
        throw UnsupportedError("Platform not supported");
      }
      // Initialize Cast context
      await GoogleCastContext.instance.setSharedInstanceWithOptions(options!);
      log("GoogleCastContext initialized successfully");
    } catch (e, s) {
      log('Error initializing CastContext: $e');
      log('Stack trace: $s');

      // Retry logic
      if (retryCount < maxRetries) {
        log(
          "Retrying initialization (attempt ${retryCount + 1}/$maxRetries)...",
        );
        await Future<void>.delayed(Duration(seconds: retryCount + 1));
        return initPlatformState(
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      } else {
        log("Failed to initialize CastContext after $maxRetries attempts.");
        rethrow;
      }
    }
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _controller.pause();
    currPlayIndex += 1;
    await initializePlayer();
  }

  void _toggleVolume() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
      GoogleCastSessionManager.instance.setDeviceVolume(_isMuted ? 0.0 : 1.0);
      _isPlaying == true
          ? GoogleCastRemoteMediaClient.instance.play()
          : GoogleCastRemoteMediaClient.instance.pause();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _toggleController() {
    setState(() {
      _isShowControllar = !_isShowControllar;
    });

    _hideTimer?.cancel();

    if (_isShowControllar) {
      _hideTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _isShowControllar = false;
          });
        }
      });
    }
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    if (youtubePlayerController != null) {
      youtubePlayerController!.pause();
    }
    if (youtubePlayerController != null) {
      youtubePlayerController!.dispose();
    }
    if (_idController != null) {
      _idController!.dispose();
    }
    _seekToController.dispose();
    GoogleCastDiscoveryManager.instance.stopDiscovery();
    GoogleCastSessionManager.instance.endSessionAndStopCasting();
    GoogleCastSessionManager.instance.endSession();
    _hideTimer?.cancel();
    WakelockPlus.disable();
    castManager.endCast();
    super.dispose();
  }

  void exitScreen() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    finish(context);
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        GoogleCastRemoteMediaClient.instance.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        GoogleCastRemoteMediaClient.instance.play();
        _isPlaying = true;
      }
    });
  }

  void _skipForward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);

    if (newPosition < _controller.value.duration) {
      _controller.seekTo(newPosition);
      if (GoogleCastSessionManager.instance.connectionState ==
          GoogleCastConnectState.connected) {
        GoogleCastRemoteMediaClient.instance.seek(
          GoogleCastMediaSeekOption(position: newPosition),
        );
        _isPlaying == true
            ? GoogleCastRemoteMediaClient.instance.play()
            : GoogleCastRemoteMediaClient.instance.pause();
      }
    } else {
      _controller.seekTo(_controller.value.duration);
      if (GoogleCastSessionManager.instance.connectionState ==
          GoogleCastConnectState.connected) {
        GoogleCastRemoteMediaClient.instance.seek(
          GoogleCastMediaSeekOption(position: _controller.value.duration),
        );
        _isPlaying == true
            ? GoogleCastRemoteMediaClient.instance.play()
            : GoogleCastRemoteMediaClient.instance.pause();
      }
    }
  }

  void _skipBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _controller.seekTo(newPosition);
      if (GoogleCastSessionManager.instance.connectionState ==
          GoogleCastConnectState.connected) {
        GoogleCastRemoteMediaClient.instance.seek(
          GoogleCastMediaSeekOption(position: newPosition),
        );
        _isPlaying == true
            ? GoogleCastRemoteMediaClient.instance.play()
            : GoogleCastRemoteMediaClient.instance.pause();
      }
    } else {
      _controller.seekTo(Duration.zero);
      if (GoogleCastSessionManager.instance.connectionState ==
          GoogleCastConnectState.connected) {
        GoogleCastRemoteMediaClient.instance.seek(
          GoogleCastMediaSeekOption(position: Duration.zero),
        );
        _isPlaying == true
            ? GoogleCastRemoteMediaClient.instance.play()
            : GoogleCastRemoteMediaClient.instance.pause();
      }
    }
  }

  void _setOrientation({required bool isLandscape}) {
    setState(() {
      _isCurrentlyLandscape = isLandscape;
    });

    SystemChrome.setPreferredOrientations([
      if (isLandscape) ...[
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ] else ...[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    ]);
  }

  void _toggleOrientation() {
    _setOrientation(isLandscape: !_isCurrentlyLandscape);
  }

  void listener() {
    if (_isPlayerReady &&
        mounted &&
        !youtubePlayerController!.value.isFullScreen) {
      setState(() {
        _playerState = youtubePlayerController!.value.playerState;
        videoMetaData = youtubePlayerController!.metadata;
      });
    }
  }

  @override
  void deactivate() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    if (youtubePlayerController != null) {
      youtubePlayerController!.pause();
    }
    super.deactivate();
  }

  Duration parseDuration(String durationString) {
    final List<String> components = durationString.split(':');

    final int hours = int.parse(components[0]);
    final int minutes = int.parse(components[1]);
    final int seconds = int.parse(components[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String twoDigitHours = twoDigits(duration.inHours);
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {


    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      mode = "landScape";
    } else {
      mode = "portrait";
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 56),
        child: Visibility(
          visible: mode == 'portrait' ? true : false,
          child: appBarWidget(
            widget.mExerciseModel!.data!.title.validate(),
            context: context,
            actions: [
              StreamBuilder<GoogleCastSession?>(
                stream: castManager.streamOfState(),
                builder: (context, snapshot) {
                  final bool isConnected =
                      GoogleCastSessionManager.instance.connectionState ==
                      GoogleCastConnectState.connected;
                  GoogleCastSessionManager.instance.setDeviceVolume(0);
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (widget.mExerciseModel?.data?.videoUrl != null &&
                              (widget.mExerciseModel!.data!.videoUrl!.contains(
                                    "https://youtu",
                                  ) ||
                                  widget.mExerciseModel!.data!.videoUrl!
                                      .contains("https://www.youtu"))) {
                            toast(languages.lblCastingnotsupported);
                          } else {
                            if (snapshot.data?.connectionState !=
                                GoogleCastConnectState.connected) {
                              _showDeviceBottomSheet(context);
                            } else if (snapshot.data?.connectionState ==
                                GoogleCastConnectState.connected) {
                              showConfirmDialogCustom(
                                context,
                                title: languages.lblStopcasting,
                                positiveText: "Stop",
                                image: ic_logo,
                                onAccept: (buildContext) {
                                  castManager.endCast();
                                },
                              );
                            }
                          }
                        },
                        icon: Icon(
                          isConnected
                              ? Icons.cast_connected
                              : Icons.cast_outlined,
                          color: primaryColor,
                        ),
                      ),
                      if (Platform.isIOS) ...[
                        GestureDetector(
                          onTap: () {
                            if (widget.mExerciseModel?.data?.videoUrl != null &&
                                (widget.mExerciseModel!.data!.videoUrl!
                                        .contains("https://youtu") ||
                                    widget.mExerciseModel!.data!.videoUrl!
                                        .contains("https://www.youtu"))) {
                              toast(languages.lblCastingnotsupported);
                            } else {
                              if (snapshot.data?.connectionState !=
                                  GoogleCastConnectState.connected) {
                                _showDeviceBottomSheet(context);
                              } else if (snapshot.data?.connectionState ==
                                  GoogleCastConnectState.connected) {
                                showConfirmDialogCustom(
                                  context,
                                  title: languages.lblStopcasting,
                                  positiveText: "Stop",
                                  image: ic_logo,
                                  onAccept: (buildContext) {
                                    castManager.endCast();
                                  },
                                );
                              }
                            }
                          },
                          child: Image.asset(
                            ic_broadcast,
                            color: isConnected ? primaryColor : Colors.black54,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                      15.width,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: mode == 'portrait'
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            widget.mExerciseModel!.data!.videoUrl.validate().contains(
                      "https://youtu",
                    ) ||
                    widget.mExerciseModel!.data!.videoUrl.validate().contains(
                      "https://www.youtu",
                    )
                ? AspectRatio(
                    aspectRatio: mode == "portrait" ? 12 / 7 : 15 / 7,
                    child: YoutubePlayerScreen(
                      url: widget.mExerciseModel!.data!.videoUrl.validate(),
                      img: widget.mExerciseModel!.data!.exerciseImage
                          .validate(),
                      autoPlay: true,
                    ),
                  )
                : AspectRatio(
                    aspectRatio: mode == "portrait"
                        ? MediaQuery.of(context).size.aspectRatio > 1.5
                              ? 16 / 9
                              : 12 / 7
                        : 15 / 7,
                    child: _isInitialized
                        ? GestureDetector(
                            onTap: _toggleController,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    VideoPlayer(_controller),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      top: 0,
                                      child: ExerciseVideoControls(
                                        isShowController: _isShowControllar,
                                        isPlaying: _isPlaying,
                                        isMuted: _isMuted,
                                        isCurrentlyLandscape: _isCurrentlyLandscape,
                                        currentTime: _currentTime,
                                        totalTime: _totalTime,
                                        videoProgress: _videoProgress,
                                        onTogglePlay: _togglePlay,
                                        onSkipBackward: _skipBackward,
                                        onSkipForward: _skipForward,
                                        onToggleVolume: _toggleVolume,
                                        onToggleOrientation: _toggleOrientation,
                                        onSliderChanged: (value) {
                                          setState(() {
                                            _videoProgress = value;
                                          });
                                        },
                                        onSliderChangeEnd: (value) {
                                          final milliseconds = (_controller.value.duration.inMilliseconds * value).toInt();
                                          _controller.seekTo(Duration(milliseconds: milliseconds));
                                          if (GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected) {
                                            GoogleCastRemoteMediaClient.instance.seek(GoogleCastMediaSeekOption(position: Duration(milliseconds: milliseconds)));
                                            _isPlaying == true ? GoogleCastRemoteMediaClient.instance.play() : GoogleCastRemoteMediaClient.instance.pause();
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              cachedImage(
                                widget.mExerciseModel!.data!.exerciseImage.validate(),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ).cornerRadiusWithClipRRect(16),
                              if (isLoading) const Loader().center(),
                            ],
                          ).center().paddingSymmetric(horizontal: 4),),
            60.height,
            CountDownProgressIndicator(
              controller: mCountDownController,
              valueColor: primaryColor,
              backgroundColor: Colors.transparent,
              duration: (duration1 != null && duration1!.inSeconds > 0)
                  ? duration1!.inSeconds
                  : (widget.mExerciseModel!.data!.duration.validate().toInt() > 0
                      ? widget.mExerciseModel!.data!.duration.validate().toInt()
                      : 1),
              text: "",
              timeFormatter: (seconds) {
                final d = Duration(seconds: seconds);
                final hours = d.inHours.toString().padLeft(2, '0');
                final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
                final secs = (d.inSeconds % 60).toString().padLeft(2, '0');
                return "$hours:$minutes:$secs";
              },
              timeTextStyle: boldTextStyle(size: 60, color: textPrimaryColorGlobal),
              onComplete: () {
                _completeExerciseAction();
              },
            ),
            60.height,
            if (!widget.workOutId.isEmptyOrNull)
            AppButton(
              text: languages.lblComplete,
              color: primaryColor,
              width: context.width(),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              onTap: () {
                _completeExerciseAction();
              },
            ),
            30.height,
            if (mUpNextDayList != null && mUpNextDayList!.isNotEmpty && mUpNextDayList!.every((e) => e.exercise!.isNotEmpty)) ...[
              const Divider(height: 20),
              16.height,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(languages.lblUpNext, style: boldTextStyle(size: 18)),
              ).paddingSymmetric(horizontal: 20),
            ],
            16.height,
            ExerciseUpNextComponent(
              mUpNextDayList: mUpNextDayList,
              scrollController: scrollController,
              workOutId: widget.workOutId,
              onRefresh: getDayExerciseData,
              isLoading: isLoading,
            ),
            16.height,
          ],
        ),
      ),
    );
  }

  void _showDeviceBottomSheet(BuildContext context) {

    showModalBottomSheet<void>(
      context: context,
      elevation: 0,
      enableDrag: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      transitionAnimationController: AnimationController(vsync: this, duration: const Duration(seconds: 1)),
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Material(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            color: appStore.isDarkMode ? Colors.black54 : Colors.black12,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          height: MediaQuery.of(context).size.height * 0.3,
          child: ExerciseCastDeviceList(
            isLoading: isLoading,
            onDeviceTap: (device) async {
              setState(() {
                isLoading = true;
              });
              await _prepareForCasting();
              await castManager
                  .startCast(
                device,
                imageUrl: widget.mExerciseModel?.data?.exerciseImage,
                videoUrl: widget.mExerciseModel?.data?.videoUrl,
                startTime: _controller.value.position,
                isPlaying: _isPlaying,
              )
                  .then((v) async {
                if (!mounted) return;
                _controller.play();
                _isPlaying = true;
                setState(() {
                  isLoading = false;
                });
                if (!context.mounted) return;
                Navigator.pop(context);
              });
              castManager.startListeningForPlaybackCompletion(
                widget.mExerciseModel?.data?.videoUrl,
                () {
                  _controller.play();
                  mCountDownController.resume();
                  _isPlaying = true;
                },
                () {
                  _controller.pause();
                  mCountDownController.pause();
                  _isPlaying = false;
                },
              );
            },
          ),
        ),
      ),
    ).then((_) {
      setState(() {
        // _isBottomSheetOpen = false;
      });
    });
  }

  Future<void> _completeExerciseAction() async {
    final Map<String, dynamic> req = {
      "exercise_id": widget.mExerciseModel!.data!.id,
      "workout_id": widget.workOutId,
      "workout_day_id": widget.workoutDayId,
    };
    appStore.setLoading(true);
    await storeUserWorkoutExercise(req).then((value) {
      if (!mounted) return;
      appStore.setLoading(false);
      Navigator.pop(context, {
        'action': 'refreshWorkout',
        'workoutDayId': widget.workoutDayId,
      });
    }).catchError((dynamic e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }
}
