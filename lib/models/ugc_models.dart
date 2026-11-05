import '../utils/shared_import.dart';

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

num? _toNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString());
}

bool _toBool(dynamic v) => v == true || v == 1 || v == '1';

/// User-created program (UGC) — different from subscription packages.
class UgcProgramModel {
  int? id;
  String? name;
  String? objective;
  int? durationWeeks;
  bool? isRecurring;
  String? frequency;
  List<UgcProgramDay>? days;
  String? createdAt;
  String? updatedAt;

  UgcProgramModel({
    this.id,
    this.name,
    this.objective,
    this.durationWeeks,
    this.isRecurring,
    this.frequency,
    this.days,
    this.createdAt,
    this.updatedAt,
  });

  UgcProgramModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    objective = json['objective']?.toString();
    durationWeeks = _toInt(json['duration_weeks']);
    isRecurring = json['is_recurring'] == null
        ? null
        : _toBool(json['is_recurring']);
    frequency = json['frequency']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['days'] != null) {
      days = <UgcProgramDay>[];
      json['days'].forEach((dynamic v) {
        days!.add(UgcProgramDay.fromJson(Map<String, dynamic>.from(v as Map)));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['objective'] = objective;
    data['duration_weeks'] = durationWeeks;
    data['is_recurring'] = isRecurring;
    data['frequency'] = frequency;
    if (days != null) {
      data['days'] = days!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class UgcProgramDay {
  int? weekNumber;
  int? dayOfWeek;
  String? specificDate;
  String? type; // workout | rest | cardio
  int? workoutId;
  int? dietId;
  int? waterGoalMl;
  int? stepsGoal;

  UgcProgramDay({
    this.weekNumber,
    this.dayOfWeek,
    this.specificDate,
    this.type,
    this.workoutId,
    this.dietId,
    this.waterGoalMl,
    this.stepsGoal,
  });

  UgcProgramDay.fromJson(Map<String, dynamic> json) {
    weekNumber = _toInt(json['week_number']);
    dayOfWeek = _toInt(json['day_of_week']);
    specificDate = json['specific_date']?.toString();
    type = json['type']?.toString();
    workoutId = _toInt(json['workout_id']);
    dietId = _toInt(json['diet_id']);
    waterGoalMl = _toInt(json['water_goal_ml']);
    stepsGoal = _toInt(json['steps_goal']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (weekNumber != null) data['week_number'] = weekNumber;
    if (dayOfWeek != null) data['day_of_week'] = dayOfWeek;
    if (specificDate != null) data['specific_date'] = specificDate;
    data['type'] = type;
    data['workout_id'] = workoutId;
    data['diet_id'] = dietId;
    data['water_goal_ml'] = waterGoalMl;
    data['steps_goal'] = stepsGoal;
    return data;
  }
}

class UgcProgramListResponse {
  Pagination? pagination;
  List<UgcProgramModel>? data;

  UgcProgramListResponse({this.pagination, this.data});

  UgcProgramListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <UgcProgramModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(
          UgcProgramModel.fromJson(Map<String, dynamic>.from(v as Map)),
        );
      });
    }
  }
}

class UgcProgramDetailResponse {
  UgcProgramModel? data;

  UgcProgramDetailResponse({this.data});

  UgcProgramDetailResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      if (json['data'] is Map) {
        data = UgcProgramModel.fromJson(
          Map<String, dynamic>.from(json['data'] as Map),
        );
      }
    } else if (json['id'] != null) {
      data = UgcProgramModel.fromJson(json);
    }
  }
}

class UgcWorkoutSet {
  int? reps;
  num? weight;

  UgcWorkoutSet({this.reps, this.weight});

  UgcWorkoutSet.fromJson(Map<String, dynamic> json) {
    reps = _toInt(json['reps']);
    weight = _toNum(json['weight']);
  }

  Map<String, dynamic> toJson() => {
        'reps': reps,
        'weight': weight,
      };
}

class UgcWorkoutExercise {
  int? exerciseId;
  List<UgcWorkoutSet>? sets;

  UgcWorkoutExercise({this.exerciseId, this.sets});

  UgcWorkoutExercise.fromJson(Map<String, dynamic> json) {
    exerciseId = _toInt(json['exercise_id']);
    if (json['sets'] != null) {
      sets = <UgcWorkoutSet>[];
      json['sets'].forEach((dynamic v) {
        sets!.add(UgcWorkoutSet.fromJson(Map<String, dynamic>.from(v as Map)));
      });
    }
  }

  Map<String, dynamic> toJson() => {
        'exercise_id': exerciseId,
        'sets': (sets ?? []).map((e) => e.toJson()).toList(),
      };
}

class UgcWorkoutDay {
  bool? isRest;
  List<UgcWorkoutExercise>? exercises;

  UgcWorkoutDay({this.isRest, this.exercises});

  UgcWorkoutDay.fromJson(Map<String, dynamic> json) {
    isRest = _toBool(json['is_rest']);
    if (json['exercises'] != null) {
      exercises = <UgcWorkoutExercise>[];
      json['exercises'].forEach((dynamic v) {
        exercises!.add(
          UgcWorkoutExercise.fromJson(Map<String, dynamic>.from(v as Map)),
        );
      });
    }
  }

  Map<String, dynamic> toJson() => {
        'is_rest': isRest ?? false,
        'exercises': (exercises ?? []).map((e) => e.toJson()).toList(),
      };
}

class UgcWorkoutPayload {
  int? id;
  String? title;
  String? description;
  int? levelId;
  int? workoutTypeId;
  List<UgcWorkoutDay>? days;

  UgcWorkoutPayload({
    this.id,
    this.title,
    this.description,
    this.levelId,
    this.workoutTypeId,
    this.days,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['level_id'] = levelId;
    data['workout_type_id'] = workoutTypeId;
    data['days'] = (days ?? []).map((e) => e.toJson()).toList();
    return data;
  }
}

class UgcDietPayload {
  int? id;
  String? title;
  int? categoryDietId;
  num? calories;
  num? protein;
  num? carbs;
  num? fat;
  String? description;
  String? ingredients;

  UgcDietPayload({
    this.id,
    this.title,
    this.categoryDietId,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.description,
    this.ingredients,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['title'] = title;
    data['categorydiet_id'] = categoryDietId;
    data['calories'] = calories;
    data['protein'] = protein;
    data['carbs'] = carbs;
    data['fat'] = fat;
    data['description'] = description;
    data['ingredients'] = ingredients;
    return data;
  }
}

// -------------------- Program day detail (schedule) --------------------

class ProgramDayDetailResponse {
  ProgramDayDetail? data;

  ProgramDayDetailResponse({this.data});

  ProgramDayDetailResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is Map) {
      data = ProgramDayDetail.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      );
    }
  }
}

class ProgramDayDetail {
  int? id;
  int? programId;
  int? weekNumber;
  int? dayOfWeek;
  String? specificDate;
  String? type;
  int? workoutId;
  int? dietId;
  int? waterGoalMl;
  int? stepsGoal;
  ProgramDayWorkout? workout;
  ProgramDayDiet? diet;

  ProgramDayDetail({
    this.id,
    this.programId,
    this.weekNumber,
    this.dayOfWeek,
    this.specificDate,
    this.type,
    this.workoutId,
    this.dietId,
    this.waterGoalMl,
    this.stepsGoal,
    this.workout,
    this.diet,
  });

  ProgramDayDetail.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    programId = _toInt(json['program_id']);
    weekNumber = _toInt(json['week_number']);
    dayOfWeek = _toInt(json['day_of_week']);
    specificDate = json['specific_date']?.toString();
    type = json['type']?.toString();
    workoutId = _toInt(json['workout_id']);
    dietId = _toInt(json['diet_id']);
    waterGoalMl = _toInt(json['water_goal_ml']);
    stepsGoal = _toInt(json['steps_goal']);
    if (json['workout'] is Map) {
      workout = ProgramDayWorkout.fromJson(
        Map<String, dynamic>.from(json['workout'] as Map),
      );
    }
    if (json['diet'] is Map) {
      diet = ProgramDayDiet.fromJson(
        Map<String, dynamic>.from(json['diet'] as Map),
      );
    }
  }

  List<ProgramDayExerciseItem> get allExercises {
    final List<ProgramDayExerciseItem> out = [];
    for (final ProgramDayWorkoutDay d in workout?.days ?? []) {
      out.addAll(d.exercises ?? []);
    }
    return out;
  }
}

class ProgramDayDiet {
  int? id;
  String? title;
  String? calories;
  String? protein;
  String? carbs;
  String? fat;

  ProgramDayDiet({
    this.id,
    this.title,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
  });

  ProgramDayDiet.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    title = json['title']?.toString();
    calories = json['calories']?.toString();
    protein = json['protein']?.toString();
    carbs = json['carbs']?.toString();
    fat = json['fat']?.toString();
  }
}

class ProgramDayWorkout {
  int? id;
  String? title;
  String? description;
  int? levelId;
  int? workoutTypeId;
  List<ProgramDayWorkoutDay>? days;

  ProgramDayWorkout({
    this.id,
    this.title,
    this.description,
    this.levelId,
    this.workoutTypeId,
    this.days,
  });

  ProgramDayWorkout.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    title = json['title']?.toString();
    description = json['description']?.toString();
    levelId = _toInt(json['level_id']);
    workoutTypeId = _toInt(json['workout_type_id']);
    if (json['days'] != null) {
      days = <ProgramDayWorkoutDay>[];
      json['days'].forEach((dynamic v) {
        days!.add(
          ProgramDayWorkoutDay.fromJson(Map<String, dynamic>.from(v as Map)),
        );
      });
    }
  }
}

class ProgramDayWorkoutDay {
  int? id;
  String? workoutImage;
  int? workoutId;
  String? workoutTitle;
  int? isRest;
  int? sequence;
  List<ProgramDayExerciseItem>? exercises;

  ProgramDayWorkoutDay({
    this.id,
    this.workoutImage,
    this.workoutId,
    this.workoutTitle,
    this.isRest,
    this.sequence,
    this.exercises,
  });

  ProgramDayWorkoutDay.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    workoutImage = json['workout_image']?.toString();
    workoutId = _toInt(json['workout_id']);
    workoutTitle = json['workout_title']?.toString();
    isRest = _toInt(json['is_rest']);
    sequence = _toInt(json['sequence']);
    if (json['exercises'] != null) {
      exercises = <ProgramDayExerciseItem>[];
      json['exercises'].forEach((dynamic v) {
        exercises!.add(
          ProgramDayExerciseItem.fromJson(Map<String, dynamic>.from(v as Map)),
        );
      });
    }
  }
}

class ProgramDayExerciseItem {
  int? id;
  int? workoutId;
  int? workoutDayId;
  int? exerciseId;
  bool? isCompleted;
  String? exerciseImage;
  String? exerciseTitle;
  int? exerciseIsPremium;
  int? sequence;
  ProgramDayExerciseDetail? exercise;

  ProgramDayExerciseItem({
    this.id,
    this.workoutId,
    this.workoutDayId,
    this.exerciseId,
    this.isCompleted,
    this.exerciseImage,
    this.exerciseTitle,
    this.exerciseIsPremium,
    this.sequence,
    this.exercise,
  });

  ProgramDayExerciseItem.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    workoutId = _toInt(json['workout_id']);
    workoutDayId = _toInt(json['workout_day_id']);
    exerciseId = _toInt(json['exercise_id']);
    isCompleted = _toBool(json['is_completed']);
    exerciseImage = json['exercise_image']?.toString();
    exerciseTitle = json['exercise_title']?.toString();
    exerciseIsPremium = _toInt(json['exercise_is_premium']);
    sequence = _toInt(json['sequence']);
    if (json['exercise'] is Map) {
      exercise = ProgramDayExerciseDetail.fromJson(
        Map<String, dynamic>.from(json['exercise'] as Map),
      );
    }
  }
}

class ProgramDayExerciseDetail {
  int? id;
  String? title;
  String? status;
  int? isPremium;
  String? exerciseImage;
  String? duration;
  String? based;
  String? type;
  int? secondsPerRep;
  List<ProgramDayExerciseSet>? sets;

  ProgramDayExerciseDetail({
    this.id,
    this.title,
    this.status,
    this.isPremium,
    this.exerciseImage,
    this.duration,
    this.based,
    this.type,
    this.secondsPerRep,
    this.sets,
  });

  ProgramDayExerciseDetail.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    title = json['title']?.toString();
    status = json['status']?.toString();
    isPremium = _toInt(json['is_premium']);
    exerciseImage = json['exercise_image']?.toString();
    duration = json['duration']?.toString();
    based = json['based']?.toString();
    type = json['type']?.toString();
    secondsPerRep = _toInt(json['seconds_per_rep']);
    if (json['sets'] != null) {
      sets = <ProgramDayExerciseSet>[];
      json['sets'].forEach((dynamic v) {
        sets!.add(
          ProgramDayExerciseSet.fromJson(Map<String, dynamic>.from(v as Map)),
        );
      });
    }
  }
}

class ProgramDayExerciseSet {
  String? reps;
  String? weight;
  String? rest;
  String? time;

  ProgramDayExerciseSet({this.reps, this.weight, this.rest, this.time});

  ProgramDayExerciseSet.fromJson(Map<String, dynamic> json) {
    reps = json['reps']?.toString();
    weight = json['weight']?.toString();
    rest = json['rest']?.toString();
    time = json['time']?.toString();
  }
}
