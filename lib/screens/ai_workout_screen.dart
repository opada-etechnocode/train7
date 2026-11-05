import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../components/ai_pose_painter.dart';
import '../models/ai_workout_models.dart';
import '../utils/ai_camera_frame_converter.dart';
import '../utils/shared_import.dart';

class AiWorkoutScreen extends StatefulWidget {
  final String exerciseKey;
  final String? exerciseTitle;

  const AiWorkoutScreen({
    super.key,
    required this.exerciseKey,
    this.exerciseTitle,
  });

  @override
  State<AiWorkoutScreen> createState() => _AiWorkoutScreenState();
}

class _AiWorkoutScreenState extends State<AiWorkoutScreen> {
  /// Keeps last python session so a new entry can stop a leftover session.
  static String? _lastPythonSessionId;

  CameraController? _camera;
  WebSocketChannel? _channel;
  StreamSubscription? _wsSub;

  String? _pythonSessionId;
  bool _starting = true;
  bool _streaming = false;
  bool _sending = false;
  bool _stopping = false;
  bool _disposed = false;
  String? _error;

  AiWorkoutFrameState _state = const AiWorkoutFrameState();
  DateTime _lastSent = DateTime.fromMillisecondsSinceEpoch(0);

  static const Duration _sendInterval = Duration(milliseconds: 100); // ~10 FPS

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (_disposed) return;
    setState(() {
      _starting = true;
      _error = null;
      _stopping = false;
      _streaming = false;
      _state = const AiWorkoutFrameState();
    });

    try {
      // Always free previous camera/socket and stop leftover AI session
      await _releaseResources(callStopApi: true);

      final PermissionStatus cam = await Permission.camera.request();
      if (!cam.isGranted) {
        throw Exception(languages.lblAiCameraDenied);
      }

      // Give OS a moment to fully release the camera after dispose
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (_disposed || !mounted) return;

      final AiWorkoutStartResponse start = await startAiWorkoutApi(
        exercise: widget.exerciseKey,
        camera: 'front',
      );
      _pythonSessionId = start.pythonSessionId ?? start.sessionId;
      _lastPythonSessionId = _pythonSessionId;
      final String? websocketUrl = start.websocketUrl;
      if (websocketUrl.validate().isEmpty ||
          _pythonSessionId.validate().isEmpty) {
        throw Exception(languages.lblAiStartFailed);
      }

      final List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception(languages.lblAiCameraDenied);
      }
      final CameraDescription front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final CameraController controller = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await controller.initialize();
      if (_disposed || !mounted) {
        await controller.dispose();
        return;
      }
      _camera = controller;

      _connectSocket(websocketUrl!);
      await controller.startImageStream(_onCameraFrame);

      if (!mounted || _disposed) return;
      setState(() {
        _starting = false;
        _streaming = true;
      });
    } on Exception catch (e) {
      log('AI workout start error: $e');
      await _releaseResources(callStopApi: false);
      if (mounted && !_disposed) {
        setState(() {
          _starting = false;
          _error = e.toString();
        });
      }
    }
  }

  void _connectSocket(String url) {
    _wsSub?.cancel();
    try {
      _channel?.sink.close();
    } on Exception catch (_) {}

    final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(url));
    _channel = channel;
    _wsSub = channel.stream.listen(
      (dynamic message) {
        try {
          if (message is! String) return;
          final Map<String, dynamic> json =
              Map<String, dynamic>.from(jsonDecode(message) as Map);
          final AiWorkoutFrameState next = AiWorkoutFrameState.fromJson(json);
          if (!mounted || _disposed) return;
          setState(() => _state = next);
        } on Exception catch (e) {
          log('AI ws parse: $e');
        }
      },
      onError: (Object e) {
        log('AI ws error: $e');
      },
      onDone: () {
        log('AI ws closed');
      },
      cancelOnError: false,
    );
  }

  Future<void> _onCameraFrame(CameraImage image) async {
    if (!_streaming || _sending || _channel == null || _disposed) return;
    final DateTime now = DateTime.now();
    if (now.difference(_lastSent) < _sendInterval) return;
    _lastSent = now;
    _sending = true;
    try {
      // Rotate to upright (sensor orientation) so landmarks match preview,
      // same as the browser demo which sends upright video frames.
      final int rotation = _camera?.description.sensorOrientation ?? 0;
      final Uint8List? jpeg = convertCameraImageToJpeg(
        image,
        quality: 70,
        maxWidth: 640,
        rotationDegrees: rotation,
      );
      if (jpeg != null && jpeg.isNotEmpty) {
        _channel!.sink.add(jpeg);
      }
    } on Exception catch (e) {
      log('AI frame send: $e');
    } finally {
      _sending = false;
    }
  }

  Future<void> _resetReps() async {
    try {
      _channel?.sink.add('reset');
    } on Exception catch (_) {}
  }

  Future<void> _releaseResources({required bool callStopApi}) async {
    _streaming = false;

    final CameraController? cam = _camera;
    _camera = null;
    if (cam != null) {
      try {
        if (cam.value.isStreamingImages) {
          await cam.stopImageStream();
        }
      } on Exception catch (e) {
        log('AI stopImageStream: $e');
      }
      try {
        await cam.dispose();
      } on Exception catch (e) {
        log('AI camera dispose: $e');
      }
    }

    try {
      _channel?.sink.add('stop');
    } on Exception catch (_) {}

    await _wsSub?.cancel();
    _wsSub = null;
    try {
      await _channel?.sink.close();
    } on Exception catch (_) {}
    _channel = null;

    final String? sessionToStop =
        callStopApi ? (_pythonSessionId ?? _lastPythonSessionId) : null;
    if (sessionToStop.validate().isNotEmpty) {
      try {
        await stopAiWorkoutApi(pythonSessionId: sessionToStop!);
      } on Exception catch (e) {
        log('AI stop api (cleanup): $e');
      }
      if (_lastPythonSessionId == sessionToStop) {
        _lastPythonSessionId = null;
      }
      if (_pythonSessionId == sessionToStop) {
        _pythonSessionId = null;
      }
    }
  }

  Future<void> _stopAndExit() async {
    if (_stopping) return;
    _stopping = true;
    if (mounted) setState(() => _streaming = false);

    final String? sessionId = _pythonSessionId ?? _lastPythonSessionId;
    await _releaseResources(callStopApi: false);

    AiWorkoutStopResponse? summary;
    if (sessionId.validate().isNotEmpty) {
      try {
        summary = await stopAiWorkoutApi(pythonSessionId: sessionId!);
        _lastPythonSessionId = null;
        _pythonSessionId = null;
      } on Exception catch (e) {
        log('AI stop api: $e');
      }
    }

    if (!mounted || _disposed) return;
    if (summary != null) {
      await _showSummary(summary);
    }
    if (mounted && !_disposed) finish(context);
  }

  Future<void> _showSummary(AiWorkoutStopResponse summary) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: radius(16)),
        title: Text(languages.lblAiWorkoutSummary, style: boldTextStyle()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryRow(languages.lblAiReps, '${summary.reps ?? _state.reps}'),
            _summaryRow(
              languages.lblAiScore,
              '${(summary.score ?? _state.score).round()}%',
            ),
            if (summary.duration != null)
              _summaryRow(languages.lblDuration, '${summary.duration}s'),
            if (summary.calories != null)
              _summaryRow(languages.lblCalories, '${summary.calories}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              languages.lblDone,
              style: boldTextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Text(k, style: secondaryTextStyle()).expand(),
            Text(v, style: boldTextStyle()),
          ],
        ),
      );

  @override
  void dispose() {
    _disposed = true;
    _streaming = false;
    // Fire-and-forget cleanup; camera must be stopped before dispose.
    unawaited(_releaseResources(callStopApi: true));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        await _stopAndExit();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_camera != null && _camera!.value.isInitialized)
                // Front CameraPreview is already mirrored on device — do NOT scaleX(-1).
                // Landmarks from the server are in unmirrored JPEG space, so flip X when drawing.
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width:
                        _camera!.value.previewSize?.height ?? context.width(),
                    height:
                        _camera!.value.previewSize?.width ?? context.height(),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(_camera!),
                        CustomPaint(
                          painter: AiPosePainter(
                            landmarks: _state.landmarks,
                            mirrorX: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(color: Colors.black),
              if (_starting) const Loader().center(),
              if (_error != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          style: primaryTextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        16.height,
                        AppButton(
                          text: languages.lblRetry,
                          color: primaryColor,
                          height: 42,
                          onTap: _bootstrap,
                        ),
                        8.height,
                        AppButton(
                          text: languages.lblCancel,
                          color: Colors.white24,
                          textColor: Colors.white,
                          height: 42,
                          onTap: () => finish(context),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _stopAndExit,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        widget.exerciseTitle.validate(
                          value: widget.exerciseKey,
                        ),
                        style: boldTextStyle(color: Colors.white, size: 16),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: _resetReps,
                      tooltip: languages.lblAiReset,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 64,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${languages.lblAiReps}: ${_state.reps}',
                        style: boldTextStyle(
                          color: const Color(0xFF00FF00),
                          size: 28,
                        ),
                      ),
                      4.height,
                      Text(
                        '${languages.lblAiStage}: ${_state.stage}',
                        style: boldTextStyle(
                          color: const Color(0xFF00BFFF),
                          size: 16,
                        ),
                      ),
                      4.height,
                      Text(
                        '${languages.lblAiScore}: ${_state.score.round()}%',
                        style: boldTextStyle(
                          color: const Color(0xFFFFD700),
                          size: 16,
                        ),
                      ),
                      4.height,
                      Text(
                        'FPS: ${_state.fps.toStringAsFixed(1)}',
                        style: secondaryTextStyle(
                          color: Colors.white70,
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: AppButton(
                  text: languages.lblAiFinish,
                  color: primaryColor,
                  height: 44,
                  elevation: 0,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: _stopAndExit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
