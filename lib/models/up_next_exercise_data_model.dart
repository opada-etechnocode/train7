import '../utils/shared_import.dart';

/// ===============================
/// RESPONSE MODEL
/// ===============================
class UpNextExerciseDataModel {
  List<WorkoutDay>? data;

  UpNextExerciseDataModel({this.data});

  UpNextExerciseDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WorkoutDay>[];
      json['data'].forEach((dynamic v) {
        data!.add(WorkoutDay.fromJson(v));
      });
    }
  }
}

/// ===============================
/// WORKOUT DAY MODEL
/// ===============================
class WorkoutDay {
  int? workoutDayId;
  int? sequence;
  int? isRest;
  List<WorkoutExercise>? exercise;

  WorkoutDay({this.workoutDayId, this.sequence, this.isRest, this.exercise});

  WorkoutDay.fromJson(Map<String, dynamic> json) {
    workoutDayId = json['workout_day_id'] ?? json['day'];
    sequence = json['sequence'];
    isRest = json['is_rest'];

    if (json['exercise'] != null) {
      exercise = <WorkoutExercise>[];
      json['exercise'].forEach((dynamic v) {
        exercise!.add(WorkoutExercise.fromJson(v));
      });
    } else {
      exercise = [];
    }
  }
}

/// ===============================
/// WORKOUT EXERCISE MODEL
/// ===============================
class WorkoutExercise {
  int? id;
  int? workoutId;
  int? workoutDayId;
  int? exerciseId;
  bool? isCompleted;
  String? exerciseImage;
  String? exerciseTitle;
  int? exerciseIsPremium;
  Exercise? exercise;
  int? sequence;
  String? createdAt;
  String? updatedAt;

  WorkoutExercise({
    this.id,
    this.workoutId,
    this.workoutDayId,
    this.exerciseId,
    this.isCompleted,
    this.exerciseImage,
    this.exerciseTitle,
    this.exerciseIsPremium,
    this.exercise,
    this.sequence,
    this.createdAt,
    this.updatedAt,
  });

  WorkoutExercise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workoutId = json['workout_id'];
    workoutDayId = json['workout_day_id'];
    exerciseId = json['exercise_id'];
    isCompleted = json['is_completed'];
    exerciseImage = json['exercise_image'];
    exerciseTitle = json['exercise_title'];
    exerciseIsPremium = json['exercise_is_premium'];
    sequence = json['sequence'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    exercise = json['exercise'] != null
        ? Exercise.fromJson(json['exercise'])
        : null;
  }
}
