import '../utils/shared_import.dart';

class ExerciseDurationScreencast extends StatefulWidget {
  static String tag = '/ExerciseDurationScreen';
  final ExerciseDetailResponse? mExerciseModel;
  final String? workOutId;
  final int? workoutDayId;

  const ExerciseDurationScreencast({
    super.key,
    this.mExerciseModel,
    this.workOutId,
    this.workoutDayId,
  });

  @override
  ExerciseDurationScreencastState createState() =>
      ExerciseDurationScreencastState();
}

class ExerciseDurationScreencastState extends State<ExerciseDurationScreencast>
    with TickerProviderStateMixin {
  CountDownController1 mCountDownController1 = CountDownController1();

  Duration? duration;

  //FlutterTts? flutterTts;
  int i = 0;
  int? mLength;
  Workout? _workout;
  Tabata? _tabata;
  bool _isMuted = false;

  List<String>? mExTime = [];
  List<String>? mRestTime = [];
  bool _isBottomSheetOpen = false;

  late VideoPlayerController _controller;
  GoogleCastOptions? options;

  bool _isInitialized = false;
  bool _isPlaying = false;
  double _videoProgress = 0.0;
  bool _isCurrentlyLandscape = false;
  bool _isShowControllar = false;
  Timer? _hideTimer;

  String _currentTime = '0:00';
  String _totalTime = '0:00';

  int? bufferDelay;
  YoutubePlayerController? youtubePlayerController;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  late PlayerState? _playerState;
  late YoutubeMetaData videoMetaData;
  final bool _isPlayerReady = false;
  String? videoId = '';

  bool visibleOption = true;
  bool? isChanged = false;
  final castManager = CastManager();
  bool isLoading = false;

  int page = 1;
  int? numPage;
  int currentTabIndex = 0;
  bool isLastPage = false;
  ScrollController scrollController = ScrollController();
  List<DayExerciseModel> mDayExerciseList = [];
  List<WorkoutDay>? mUpNextDayList = [];

  @override
  initState() {
    log("--------------85>>>>${widget.mExerciseModel?.data?.exerciseImage}");
    super.initState();
    WakelockPlus.enable();
    getDayExerciseData();
    if (widget.mExerciseModel!.data!.sets != null) {
      widget.mExerciseModel!.data!.sets!.forEachIndexed((element, index) {
        if (widget.mExerciseModel!.data!.based == "reps") {
          mExTime!.add(element.reps.toString());
        } else {
          mExTime!.add(element.time.toString());
        }
        mRestTime!.add(element.rest.toString());
        setState(() {});
      });
      _tabata = Tabata(
        sets: 1,
        reps: widget.mExerciseModel!.data!.sets!.length,
        startDelay: const Duration(seconds: 3),
        exerciseTime: mExTime,
        restTime: mRestTime,
        breakTime: const Duration(seconds: 60),
        status: widget.mExerciseModel!.data!.based == "reps"
            ? "reps"
            : "second",
        secondsPerRep: widget.mExerciseModel!.data!.secondsPerRep,
      );
    }

    _initVideoPlayer();
    _setOrientation(isLandscape: false);

    init();
    castManager.initPlatformState();

    if (videoId != null) {
      videoId = YoutubePlayer.convertUrlToId(
        widget.mExerciseModel!.data!.videoUrl.validate(),
      );
    }
    // if (flutterTts != null) flutterTts!.awaitSpeakCompletion(true);
    // flutterTts!.pause();
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
            _workout!.resetTimer();
            isChanged = false;
          }
        }
        if (_playerState == PlayerState.paused) {
          _workout!.pause();
          // if (flutterTts != null) flutterTts!.pause();
          // isChanged = true;
        }
      });
    }
    videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    initPlatformState();
    GoogleCastDiscoveryManager.instance.startDiscovery();
    GoogleCastDiscoveryManager.instance.devicesStream.listen((devices) {
      log("Devices Found: ${devices.map((e) => e.friendlyName).join(", ")}");
    });

    GoogleCastSessionManager.instance.currentSessionStream.listen((session) {
      log("Session updated: $session");
    });
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

  Future<void> init() async {
    //
    if (widget.mExerciseModel!.data!.sets != null) {
      mLength = widget.mExerciseModel!.data!.sets!.length - 1;
    }
    if (_tabata == null) {
      return;
    }
    _workout = Workout(_tabata!, _onWorkoutChanged);
    _start();
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

      await GoogleCastContext.instance.setSharedInstanceWithOptions(options!);
      log("GoogleCastContext initialized successfully");
    } catch (e) {
      if (retryCount < maxRetries) {
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

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _workout?.dispose();
    _seekToController.dispose();
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (youtubePlayerController != null) {
      youtubePlayerController!.pause();
    }
    if (youtubePlayerController != null) {
      youtubePlayerController!.dispose();
    }
    _idController.dispose();
    GoogleCastDiscoveryManager.instance.stopDiscovery();
    GoogleCastSessionManager.instance.endSessionAndStopCasting();
    GoogleCastSessionManager.instance.endSession();
    _hideTimer?.cancel();
    castManager.endCast();
    WakelockPlus.disable();

    super.dispose();
  }

  void exitScreen() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    finish(context);
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
    // Pauses video while navigating to next page.
    if (youtubePlayerController != null) {
      youtubePlayerController!.pause();
    }
    super.deactivate();
  }

  Future<void> _initVideoPlayer() async {
    debugPrint('---initVideoPlayer----------');
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.mExerciseModel?.data?.videoUrl ?? ''),
    );
    await _controller.initialize();
    _controller.setLooping(true);
    _isInitialized = true;
    setState(() {});

    if (_controller.value.isInitialized) {
      _controller.play();
      _isPlaying = true;
      //_controller.pause();
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
          _workout!.resetTimer();
          isChanged = false;
        }
      } else if (_controller.value.isBuffering) {
        log('Video is buffering');
      } else if (_controller.value.isInitialized) {
        _workout!.pause();
        flutterTts.pause();
        isChanged = true;
      } else {
        log('Video controller is in an unknown state');
      }
    });
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
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

  int currPlayIndex = 0;

  Future<void> _onWorkoutChanged() async {
    if (_workout!.step == WorkoutState.finished) {
      await setExerciseApi();
      if (!mounted) return;
      if (_isBottomSheetOpen) {
        Navigator.pop(context);
        Navigator.pop(context, {
          'action': 'refreshWorkout',
          'workoutDayId': widget.workoutDayId,
        });
      } else {
        Navigator.pop(context, {
          'action': 'refreshWorkout',
          'workoutDayId': widget.workoutDayId,
        });
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _start() {
    _workout!.start();
  }

  Future<void> setExerciseApi() async {
    final Map<String, dynamic> req = {
      "exercise_id": widget.mExerciseModel!.data!.id,
      "workout_id": widget.workOutId,
      "workout_day_id": widget.workoutDayId,
    };
    appStore.setLoading(true);
    await storeUserWorkoutExercise(req)
        .then((value) {
          appStore.setLoading(false);
        })
        .catchError((dynamic e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
  }

  Widget dividerHorizontalLine({bool? isSmall = false}) =>
      Container(height: isSmall == true ? 40 : 65, width: 4, color: whiteColor);

  Widget mSetText(String value, {String? value2}) =>
      Text(value, style: boldTextStyle(size: 18)).center();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Duration parseDuration(String durationString) {
    final List<String> components = durationString.split(':');

    final int hours = int.parse(components[0]);
    final int minutes = int.parse(components[1]);
    final int seconds = int.parse(components[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  Widget mData(List<Sets> strings) {
    final List<Widget> list = [];
    for (var i = 0; i < strings.length; i++) {
      list.add(Text(strings[i].time.toString()));
    }
    return Row(children: list);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarIconBrightness: appStore.isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        appBar: isLandscape
            ? null
            : appBarWidget(
                widget.mExerciseModel?.data?.title ?? "",
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
                              if (widget.mExerciseModel?.data?.videoUrl !=
                                      null &&
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
                                if (widget.mExerciseModel?.data?.videoUrl !=
                                        null &&
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
                                color: isConnected
                                    ? primaryColor
                                    : Colors.black54,
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
        body: SingleChildScrollView(
          physics: isLandscape
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: (_workout?.step == WorkoutState.resting || _workout?.step == WorkoutState.breaking) ? 0.2 : 1.0,
                child: widget.mExerciseModel!.data!.videoUrl.validate().contains(
                          "https://youtu",
                        ) ||
                        widget.mExerciseModel!.data!.videoUrl.validate().contains(
                          "https://www.youtu",
                        )
                    ? AspectRatio(
                        aspectRatio: 12 / 7,
                        child: YoutubePlayerScreen(
                          url: widget.mExerciseModel!.data!.videoUrl.validate(),
                          img: widget.mExerciseModel!.data!.exerciseImage
                              .validate(),
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: isLandscape ? 12 / 6 : 12 / 7,
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
                                          child: _controls(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  cachedImage(
                                    widget.mExerciseModel!.data!.exerciseImage
                                        .validate(),
                                    fit: BoxFit.fill,
                                    height: context.height(),
                                    width: double.infinity,
                                  ).cornerRadiusWithClipRRect(0),
                                  if (!_controller.value.isInitialized) ...[
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                ],
                              ),
                      ).center().paddingSymmetric(horizontal: 4),
              ),
              30.height,
              if (widget.mExerciseModel!.data!.sets != null)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: appStore.isDarkMode ? cardDarkColor : Colors.grey.shade50,
                        borderRadius: radius(16),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        children: [
                          Text(languages.lblSets.toUpperCase(), style: secondaryTextStyle(size: 12, weight: FontWeight.bold, letterSpacing: 1.2)),
                          8.height,
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: "${_workout?.rep}", style: boldTextStyle(size: 20)),
                                TextSpan(text: " / ${widget.mExerciseModel?.data?.sets?.length.toString()}", style: secondaryTextStyle(size: 16, weight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).expand(),
                    16.width,
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: appStore.isDarkMode ? cardDarkColor : Colors.grey.shade50,
                        borderRadius: radius(16),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        children: [
                          Text(languages.lblWeight.toUpperCase(), style: secondaryTextStyle(size: 12, weight: FontWeight.bold, letterSpacing: 1.2)),
                          8.height,
                          _workout!.rep >= 1
                              ? RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: widget.mExerciseModel!.data!.sets![_workout!.rep - 1].weight.validate(), style: boldTextStyle(size: 20)),
                                      TextSpan(text: " ${userStore.weightUnit.validate().toUpperCase()}", style: boldTextStyle(size: 14, color: primaryColor)),
                                    ],
                                  ),
                                )
                              : Text("-", style: boldTextStyle(size: 20)),
                        ],
                      ),
                    ).expand(),
                  ],
                ).paddingSymmetric(horizontal: 16),
              50.height,
              if (_workout != null)
                Center(
                  child: SizedBox(
                    height: 190,
                    width: 190,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 190,
                            width: 190,
                            child: CircularProgressIndicator(
                              value: (_workout!.step == WorkoutState.exercising && _workout!.config.exerciseTime != null && _workout!.rep <= (_workout!.config.exerciseTime?.length ?? 0))
                                  ? (1.0 - (_workout!.timeLeft.inSeconds / (double.tryParse(_workout!.config.exerciseTime![_workout!.rep - 1]) ?? 1.0)))
                                  : (_workout!.step == WorkoutState.resting && _workout!.config.restTime != null && _workout!.rep <= (_workout!.config.restTime?.length ?? 0))
                                      ? (1.0 - (_workout!.timeLeft.inSeconds / (double.tryParse(_workout!.config.restTime![_workout!.rep - 1]) ?? 1.0)))
                                      : 0,
                              strokeWidth: 10,
                              backgroundColor: primaryColor.withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                child: Text(
                                  (_workout!.config.status == "reps" && _workout!.step == WorkoutState.exercising)
                                      ? "${_workout!.timeLeft.inSeconds}"
                                      : formatTime1(_workout!.timeLeft),
                                  style: boldTextStyle(size: 50, color: primaryColor),
                                ),
                              ),
                              if (_workout!.step == WorkoutState.exercising)
                                Text(
                                  (_workout!.config.status == "reps") ? languages.lblReps.toUpperCase() : "${languages.lblSecond.toUpperCase()}S",
                                  style: secondaryTextStyle(size: 14, weight: FontWeight.bold, letterSpacing: 2.0),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              16.height,
              if (!widget.workOutId.isEmptyOrNull)
                AppButton(
                  text: languages.lblComplete,
                  width: context.width(),
                  color: primaryColor,
                  onTap: () {
                    showConfirmDialogCustom(
                      context,
                      title: languages.confirmCompleteExercise,
                      onAccept: (buildContext) async {
                        final Map<String, dynamic> req = {
                          "exercise_id": widget.mExerciseModel!.data!.id,
                          "workout_id": widget.workOutId,
                          "workout_day_id": widget.workoutDayId,
                        };
                        appStore.setLoading(true);
                        await storeUserWorkoutExercise(req)
                            .then((value) {
                              if (!context.mounted) return;
                              Navigator.pop(context, {
                                'action': 'refreshWorkout',
                                'workoutDayId': widget.workoutDayId,
                              });
                            })
                            .catchError((e) {
                              appStore.setLoading(false);
                            });
                      },
                    );
                  },
                ).paddingSymmetric(horizontal: 20),
              // 16.height,
              16.height,
              if (mUpNextDayList != null &&
                  mUpNextDayList!.isNotEmpty &&
                  mUpNextDayList!.every((e) => e.exercise!.isNotEmpty)) ...[
                const Divider(height: 20),
                16.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    languages.lblUpNext,
                    style: boldTextStyle(size: 18),
                  ),
                ).paddingSymmetric(horizontal: 20),
              ],
              16.height,
              Stack(
                children: [
                  mUpNextDayList != null && mUpNextDayList!.isNotEmpty
                      ? AnimatedListView(
                          controller: scrollController,
                          itemCount: mUpNextDayList!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final day = mUpNextDayList![index];

                            if (day.isRest == 1 ||
                                day.exercise == null ||
                                day.exercise!.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            /*  final workoutExercise = day.exercise!.first;
                            final exercise = workoutExercise.exercise;

                            List<String> mSets = [];

                            if (exercise?.type == "sets" && exercise?.sets?.isNotEmpty == true) {
                              for (final s in exercise!.sets!) {
                                mSets.add(
                                  exercise.based == "time" ? "${s.time}s" : "${s.reps}x",
                                );
                              }
                            }*/
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${languages.lblDay}${day.sequence.validate() + 1}",
                                  style: primaryTextStyle(
                                    weight: FontWeight.w700,
                                    size: 15,
                                    color: primaryColor,
                                  ),
                                ).paddingSymmetric(horizontal: 10),
                                5.height,

                                /*   UpNextExerciseComponent(
                                  mDayExerciseModel: workoutExercise,
                                  mSets: mSets,
                                  workOutId: widget.workOutId,
                                  workoutDayId: day.workoutDayId,
                                  onRefreshWorkout: (workoutDayId) {
                                    getDayExerciseData();
                                    log("back day id ${workoutDayId}");
                                  },
                                ),*/
                                ...day.exercise!.map((workoutExercise) {
                                  final exercise = workoutExercise.exercise;

                                  final List<String> mSets = [];

                                  if (exercise?.type == "sets" &&
                                      exercise?.sets?.isNotEmpty == true) {
                                    for (final s in exercise!.sets!) {
                                      mSets.add(
                                        exercise.based == "time"
                                            ? "${s.time}s"
                                            : "${s.reps}x",
                                      );
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: UpNextExerciseComponent(
                                      mDayExerciseModel: workoutExercise,
                                      mSets: mSets,
                                      workOutId: widget.workOutId,
                                      workoutDayId: day.workoutDayId,
                                      onRefreshWorkout: (workoutDayId) {
                                        getDayExerciseData();
                                        debugPrint("back day id $workoutDayId");
                                      },
                                    ),
                                  );
                                }),
                                5.height,
                              ],
                            );
                          },
                        )
                      : const SizedBox.shrink().visible(!isLoading == true),
                  const Loader()
                      .center()
                      .paddingOnly(top: 50)
                      .visible(isLoading == true)
                      .center(),
                ],
              ),
            ],
          ).center(),
        ),
      ),
    );
  }

  Widget _controls() => Visibility(
    visible: _isShowControllar == true,
    child: Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 65),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: _skipBackward,
                  child: Image.asset(ic_backward, height: 30, width: 30),
                ),
              ),
              20.width,
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: 0.6,
                  ), // Background color
                  shape: BoxShape.circle, // Make it round
                ),
                child: IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlay,
                ),
              ),
              20.width,
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: _skipForward,
                  child: Image.asset(ic_forward, width: 30, height: 30),
                ),
              ),
            ],
          ).expand(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          _currentTime,
                          style: boldTextStyle(color: Colors.white, size: 13),
                        ),
                        Text(
                          ' / $_totalTime',
                          style: primaryTextStyle(
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            size: 30,
                          ),
                          onPressed: _toggleVolume,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isCurrentlyLandscape
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: Colors.white,
                          ),
                          onPressed: _toggleOrientation,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 5.0,
                      overlayShape: SliderComponentShape.noOverlay,
                      //overlayShape: SliderComponentShape.noThumb,
                      thumbColor: primaryColor,
                      trackShape: SliderCustomTrackShape(),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6.0,
                      ),
                    ),
                    child: Slider(
                      value: _videoProgress,
                      onChanged: (value) {
                        setState(() {
                          _videoProgress = value;
                        });
                      },
                      onChangeStart: (value) {
                        setState(() {});
                      },
                      onChangeEnd: (value) {
                        final milliseconds =
                            (_controller.value.duration.inMilliseconds * value)
                                .toInt();
                        _controller.seekTo(
                          Duration(milliseconds: milliseconds),
                        );
                        if (GoogleCastSessionManager.instance.connectionState ==
                            GoogleCastConnectState.connected) {
                          GoogleCastRemoteMediaClient.instance.seek(
                            GoogleCastMediaSeekOption(
                              position: Duration(milliseconds: milliseconds),
                            ),
                          );
                          _isPlaying == true
                              ? GoogleCastRemoteMediaClient.instance.play()
                              : GoogleCastRemoteMediaClient.instance.pause();
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _prepareForCasting() async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
    }
    await _controller.setVolume(0.0);
    _isPlaying = false;
  }

  Widget _buildDeviceList() => StreamBuilder<List<GoogleCastDevice>>(
    stream: GoogleCastDiscoveryManager.instance.devicesStream,
    builder: (context, snapshot) {
      final devices = snapshot.data ?? [];

      if (devices.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cast, size: 48, color: Colors.black),
              const SizedBox(height: 10),
              Text(
                languages.lblNoFoundData,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: devices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final device = devices[index];
          return InkWell(
            onTap: () async {
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
                    // videoController: _controller,
                    isPlaying: _isPlaying,
                  )
                  .then((v) {
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
                  _isPlaying = true;
                },
                () {
                  _controller.pause();
                  _isPlaying = false;
                },
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.05),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.15),
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Leading Icon with gradient container
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withValues(alpha: 0.2),
                          primaryColor.withValues(alpha: 0.4),
                        ],
                      ),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.cast_connected,
                      size: 28,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Device Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.friendlyName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (device.modelName != null &&
                            device.modelName!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              device.modelName!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Trailing Icon with subtle animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: isLoading
                        ? const Loader(color: Colors.transparent)
                        : Icon(
                            Icons.chevron_right,
                            size: 24,
                            color: primaryColor.withValues(alpha: 0.7),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  void _showDeviceBottomSheet(BuildContext context) {
    setState(() {
      _isBottomSheetOpen = true;
    });
    showModalBottomSheet<void>(
      context: context,
      elevation: 0,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      ),
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
          child: _buildDeviceList(),
        ),
      ),
    ).then((_) {
      setState(() {
        _isBottomSheetOpen = false;
      });
    });
  }
}
