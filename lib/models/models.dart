import '../utils/shared_import.dart';

FlutterTts flutterTts = FlutterTts();

class Tabata {
  int? sets;
  int? reps;
  List<String>? exerciseTime;
  List<String>? restTime;
  Duration? breakTime;
  Duration? startDelay;
  String? status;
  int? secondsPerRep;

  Tabata({
    required this.sets,
    required this.reps,
    required this.startDelay,
    required this.exerciseTime,
    required this.restTime,
    required this.breakTime,
    required this.status,
    this.secondsPerRep,
  });

  Tabata.fromJson(Map<String, dynamic> json) {
    sets = json['sets'];
    reps = json['reps'];
    status = json['status'];
    exerciseTime = json['exerciseTime'].cast<String>();
    restTime = json['restTime'].cast<String>();
    breakTime = Duration(seconds: json['breakTime']);
    startDelay = Duration(seconds: json['startDelay']);
    secondsPerRep = json['seconds_per_rep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sets'] = sets;
    data['reps'] = reps;
    data['status'] = status;
    data['exerciseTime'] = exerciseTime;
    data['restTime'] = restTime;
    data['breakTime'] = breakTime!.inSeconds;
    data['startDelay'] = startDelay!.inSeconds;
    data['seconds_per_rep'] = secondsPerRep;
    return data;
  }
}

enum WorkoutState { initial, starting, exercising, resting, breaking, finished }

class Workout {
  final Tabata _config;

  /// Callback for when the workout's state has changed.
  final Function _onStateChange;

  WorkoutState _step = WorkoutState.initial;

  Timer? _timer;

  late Duration _timeLeft;

  Duration _totalTime = const Duration();

  int _set = 0;

  final String _status = "";

  int _rep = 0;
  int _subSeconds = 0;

  Workout(this._config, this._onStateChange);

  /// Starts or resumes the workout
  void start() {
    flutterTts.awaitSpeakCompletion(true);
    if (_step == WorkoutState.initial) {
      _step = WorkoutState.starting;

      flutterTts.speak("three");
      if (_config.startDelay!.inSeconds == 0) {
        _nextStep();
      } else {
        _timeLeft = _config.startDelay!;
      }
    }

    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    _onStateChange();
  }

  void resetTimer() {
    start();
    _onStateChange();
  }

  /// Pauses the workout
  void pause() {
    _timer?.cancel();
    _onStateChange();
  }

  /// Stops the timer without triggering the state change callback.
  void dispose() {
    _timer?.cancel();
  }

  void _tick(Timer timer) {
    if (_step != WorkoutState.starting) {
      _totalTime += const Duration(seconds: 1);
    }

    if (_timeLeft.inSeconds == 1 &&
        (_config.status != "reps" ||
            _step != WorkoutState.exercising ||
            (_subSeconds + 1) >= (_config.secondsPerRep ?? 1))) {
      _nextStep();
    } else {
      if (_config.status == "reps" && _step == WorkoutState.exercising) {
        _subSeconds++;
        if (_subSeconds >= (_config.secondsPerRep ?? 1)) {
          _subSeconds = 0;
          _timeLeft -= const Duration(seconds: 1);
        }
      } else {
        _timeLeft -= const Duration(seconds: 1);
      }

      if (_step == WorkoutState.starting) {
        flutterTts.speak(_timeLeft.inSeconds.toString());
      } else {
        if (_step != WorkoutState.resting) {
          if (_timeLeft.inSeconds == 10) {
            flutterTts.speak(languages.lblTenSecondRemaining);
          }
        }
        if (_timeLeft.inSeconds == 3) {
          // _playSound(_settings.countdownPip);
          if (_step == WorkoutState.resting) {
            flutterTts.speak(languages.lblThreeSecondRemainingForRest);
          } else {
            flutterTts.speak(languages.lblThreeSecondRemaining);
          }
        }
      }
    }
    _onStateChange();
  }

  /// Moves the workout to the next step and sets up state for it.
  void _nextStep() {
    if (_step == WorkoutState.exercising) {
      if (rep == _config.reps) {
        if (set == _config.sets) {
          _finish();
        } else {
          _startBreak();
        }
      } else {
        _startRest();
      }
    } else if (_step == WorkoutState.resting) {
      _startRep();
    } else if (_step == WorkoutState.starting ||
        _step == WorkoutState.breaking) {
      flutterTts.speak("Go");

      _startSet();
    }
  }

  // Future _playSound(String sound) {
  //   if (_settings.silentMode) {
  //     return Future.value();
  //   }
  //   return player.play(sound, mode: PlayerMode.LOW_LATENCY);
  // }

  void _startRest() {
    _step = WorkoutState.resting;
    if (Duration(seconds: _config.restTime![_rep - 1].toInt()).inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = Duration(seconds: _config.restTime![_rep - 1].toInt());
    flutterTts.speak(
      '${_timeLeft.inSeconds.toString()} second rest up next ${_config.exerciseTime![_rep]} ${_config.status}',
    );
  }

  void _startRep() {
    _rep++;
    _subSeconds = 0;
    _step = WorkoutState.exercising;
    _timeLeft = Duration(seconds: _config.exerciseTime![_rep - 1].toInt());
  }

  void _startBreak() {
    _step = WorkoutState.breaking;
    if (_config.breakTime!.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _config.breakTime!;
    flutterTts.speak("break");
    // _playSound(_settings.startBreak);
  }

  void _startSet() {
    // flutterTts.speak("Exercise Start");
    _set++;
    _rep = 1;
    _subSeconds = 0;
    _step = WorkoutState.exercising;
    _timeLeft = Duration(seconds: _config.exerciseTime![_rep - 1].toInt());
    // _playSound(_settings.startSet);
  }

  void _finish() {
    _timer?.cancel();
    _step = WorkoutState.finished;
    _timeLeft = const Duration();
    flutterTts.speak(languages.lblExerciseComplete);
    // _playSound(_settings.endWorkout).then((p) {
    //   if (p == null) {
    //     return;
    //   }
    //   p.onPlayerCompletion.first.then((_) {
    //     _playSound(_settings.endWorkout);
    //   });
    // });
  }

  Tabata get config => _config;

  String get status => _status;

  int get set => _set;

  int get rep => _rep;

  WorkoutState get step => _step;

  Duration get timeLeft => _timeLeft;

  Duration get totalTime => _totalTime;

  bool get isActive => _timer != null && _timer!.isActive;
}
