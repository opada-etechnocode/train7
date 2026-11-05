class AiWorkoutStartResponse {
  String? message;
  String? sessionId;
  String? pythonSessionId;
  String? websocketUrl;

  AiWorkoutStartResponse({
    this.message,
    this.sessionId,
    this.pythonSessionId,
    this.websocketUrl,
  });

  AiWorkoutStartResponse.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
    sessionId = json['session_id']?.toString();
    pythonSessionId = json['python_session_id']?.toString();
    websocketUrl = json['websocket_url']?.toString();
  }
}

class AiWorkoutStopResponse {
  String? message;
  int? duration;
  int? reps;
  num? score;
  num? calories;

  AiWorkoutStopResponse({
    this.message,
    this.duration,
    this.reps,
    this.score,
    this.calories,
  });

  AiWorkoutStopResponse.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
    duration = _toInt(json['duration']);
    reps = _toInt(json['reps']);
    score = _toNum(json['score']);
    calories = _toNum(json['calories']);
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static num? _toNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    return num.tryParse(v.toString());
  }
}

class AiLandmark {
  final double x;
  final double y;
  final double z;

  const AiLandmark({required this.x, required this.y, this.z = 0});

  factory AiLandmark.fromJson(Map<String, dynamic> json) => AiLandmark(
        x: (json['x'] as num?)?.toDouble() ?? 0,
        y: (json['y'] as num?)?.toDouble() ?? 0,
        z: (json['z'] as num?)?.toDouble() ?? 0,
      );
}

class AiWorkoutFrameState {
  final int reps;
  final String stage;
  final num score;
  final double fps;
  final List<AiLandmark>? landmarks;

  const AiWorkoutFrameState({
    this.reps = 0,
    this.stage = 'WAITING',
    this.score = 100,
    this.fps = 0,
    this.landmarks,
  });

  factory AiWorkoutFrameState.fromJson(Map<String, dynamic> json) {
    List<AiLandmark>? marks;
    final raw = json['landmarks'];
    if (raw is List && raw.isNotEmpty) {
      marks = raw
          .whereType<Map>()
          .map((e) => AiLandmark.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return AiWorkoutFrameState(
      reps: AiWorkoutStopResponse._toInt(json['reps']) ?? 0,
      stage: json['stage']?.toString() ?? 'WAITING',
      score: AiWorkoutStopResponse._toNum(json['score']) ?? 100,
      fps: (json['fps'] as num?)?.toDouble() ?? 0,
      landmarks: marks,
    );
  }
}

/// Supported AI exercises only.
class AiExerciseType {
  final String key;
  final String titleEn;
  final String titleAr;

  const AiExerciseType({
    required this.key,
    required this.titleEn,
    required this.titleAr,
  });

  String label([String? languageCode]) =>
      languageCode == 'ar' ? titleAr : titleEn;
}

const List<AiExerciseType> kAiExerciseTypes = [
  AiExerciseType(
    key: 'bicep_curl',
    titleEn: 'Bicep Curl',
    titleAr: 'بايسبس كيرل',
  ),
  AiExerciseType(
    key: 'squat',
    titleEn: 'Squat',
    titleAr: 'سكوات',
  ),
  AiExerciseType(
    key: 'push_up',
    titleEn: 'Push-up',
    titleAr: 'ضغط',
  ),
  AiExerciseType(
    key: 'shoulder_press',
    titleEn: 'Shoulder Press',
    titleAr: 'شولدر برس',
  ),
  AiExerciseType(
    key: 'lateral_raise',
    titleEn: 'Lateral Raise',
    titleAr: 'لاتيرال ريز',
  ),
  AiExerciseType(
    key: 'tricep_extension',
    titleEn: 'Tricep Extension',
    titleAr: 'ترايسبس اكستنشن',
  ),
  AiExerciseType(
    key: 'lunge',
    titleEn: 'Lunge',
    titleAr: 'اندفاع',
  ),
];

/// Maps exercise titles to one of the supported AI keys, or null if unknown.
String? mapExerciseToAiKey(String? title) {
  final String t = (title ?? '').toLowerCase().trim();
  if (t.isEmpty) return null;

  if (t.contains('bicep') ||
      t.contains('curl') ||
      t.contains('بايسبس') ||
      t.contains('بايسيس')) {
    return 'bicep_curl';
  }
  if (t.contains('squat') || t.contains('سكوات') || t.contains('القرفصاء')) {
    return 'squat';
  }
  if (t.contains('push') ||
      t.contains('pushup') ||
      t.contains('push-up') ||
      t.contains('ضغط')) {
    return 'push_up';
  }
  if (t.contains('shoulder') ||
      t.contains('شولدر') ||
      t.contains('overhead press') ||
      (t.contains('كتف') && t.contains('برس'))) {
    return 'shoulder_press';
  }
  if (t.contains('lateral') ||
      t.contains('لاتيرال') ||
      t.contains('جانب')) {
    return 'lateral_raise';
  }
  if (t.contains('tricep') ||
      t.contains('tricap') ||
      t.contains('ترايسبس') ||
      t.contains('extension') ||
      t.contains('اكستنشن')) {
    return 'tricep_extension';
  }
  if (t.contains('lunge') || t.contains('اندفاع')) {
    return 'lunge';
  }
  return null;
}

AiExerciseType? aiExerciseByKey(String key) {
  for (final AiExerciseType e in kAiExerciseTypes) {
    if (e.key == key) return e;
  }
  return null;
}
