import '../utils/shared_import.dart';

class DayExerciseResponse {
  Pagination? pagination;
  List<DayExerciseModel> data = [];

  DayExerciseResponse({this.pagination, required this.data});

  DayExerciseResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
      json['data'].forEach((dynamic v) {
        data.add(DayExerciseModel.fromJson(v));
      });
    }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
      data['data'] = this.data.map((dynamic v) => v.toJson()).toList();
    return data;
  }
}

class DayExerciseModel {
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

  DayExerciseModel({
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

  DayExerciseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workoutId = json['workout_id'];
    workoutDayId = json['workout_day_id'];
    exerciseId = json['exercise_id'];
    isCompleted = json['is_completed'];
    exerciseImage = json['exercise_image'];
    exerciseTitle = json['exercise_title'];
    exerciseIsPremium = json['exercise_is_premium'];
    exercise = json['exercise'] != null
        ? Exercise.fromJson(json['exercise'])
        : null;
    sequence = json['sequence'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['workout_id'] = workoutId;
    data['workout_day_id'] = workoutDayId;
    data['exercise_id'] = exerciseId;
    data['is_completed'] = isCompleted;
    data['exercise_image'] = exerciseImage;
    data['exercise_title'] = exerciseTitle;
    data['exercise_is_premium'] = exerciseIsPremium;
    if (exercise != null) {
      data['exercise'] = exercise!.toJson();
    }
    data['sequence'] = sequence;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Exercise {
  int? id;
  String? title;
  String? status;
  int? isPremium;
  String? exerciseImage;
  String? instruction;
  List<BodypartName>? bodypartName;
  int? levelId;
  String? levelTitle;
  String? duration;
  List<Sets>? sets;
  String? based;
  String? type;
  String? createdAt;
  String? updatedAt;

  Exercise({
    this.id,
    this.title,
    this.status,
    this.isPremium,
    this.exerciseImage,
    this.instruction,
    this.bodypartName,
    this.levelId,
    this.levelTitle,
    this.duration,
    this.sets,
    this.based,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  Exercise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    isPremium = json['is_premium'];
    exerciseImage = json['exercise_image'];
    instruction = json['instruction'];
    if (json['bodypart_name'] != null) {
      bodypartName = <BodypartName>[];
      json['bodypart_name'].forEach((dynamic v) {
        bodypartName!.add(BodypartName.fromJson(v));
      });
    }
    levelId = json['level_id'];
    levelTitle = json['level_title'];
    duration = json['duration'];
    if (json['sets'] != null) {
      sets = <Sets>[];
      json['sets'].forEach((dynamic v) {
        sets!.add(Sets.fromJson(v));
      });
    }
    based = json['based'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['is_premium'] = isPremium;
    data['exercise_image'] = exerciseImage;
    data['instruction'] = instruction;
    if (bodypartName != null) {
      data['bodypart_name'] = bodypartName!.map((dynamic v) => v.toJson()).toList();
    }
    data['level_id'] = levelId;
    data['level_title'] = levelTitle;
    data['duration'] = duration;
    if (sets != null) {
      data['sets'] = sets!.map((dynamic v) => v.toJson()).toList();
    }
    data['based'] = based;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
