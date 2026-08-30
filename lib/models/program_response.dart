import '../utils/shared_import.dart';

class ProgramResponse {
  Pagination? pagination;
  List<ProgramModel>? data;

  ProgramResponse({this.pagination, this.data});

  ProgramResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ProgramModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(ProgramModel.fromJson(Map<String, dynamic>.from(v as Map)));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProgramAdviceOption {
  int? id;
  String? key;
  String? label;
  String? description;
  int? order;
  bool? isActive;
  bool? isRequired;

  ProgramAdviceOption({
    this.id,
    this.key,
    this.label,
    this.description,
    this.order,
    this.isActive,
    this.isRequired,
  });

  ProgramAdviceOption.fromJson(Map<String, dynamic> json) {
    id = ProgramModel._toInt(json['id']);
    key = json['key']?.toString();
    label = json['label']?.toString();
    description = json['description']?.toString();
    order = ProgramModel._toInt(json['order']);
    isActive = json['is_active'] == true || json['is_active'] == 1;
    isRequired = json['is_required'] == true || json['is_required'] == 1;
  }
}

class ProgramAdvice {
  int? id;
  String? name;
  String? seedText;
  bool? status;
  List<ProgramAdviceOption>? options;

  ProgramAdvice({
    this.id,
    this.name,
    this.seedText,
    this.status,
    this.options,
  });

  ProgramAdvice.fromJson(Map<String, dynamic> json) {
    id = ProgramModel._toInt(json['id']);
    name = json['name']?.toString();
    seedText = json['seed_text']?.toString();
    status = json['status'] == true || json['status'] == 1;
    if (json['options'] != null) {
      options = <ProgramAdviceOption>[];
      json['options'].forEach((dynamic v) {
        options!.add(
          ProgramAdviceOption.fromJson(Map<String, dynamic>.from(v as Map)),
        );
      });
    }
  }
}

class ProgramModel {
  int? id;
  String? name;
  int? duration;
  String? durationUnit;
  num? price;
  String? description;
  String? status;
  int? dietId;
  int? adviceId;
  int? exerciseId;
  int? foodRecognitionLimit;
  num? followUpPrice;
  String? imageUrl;
  DietModel? diet;
  ExerciseModel? exercise;
  ProgramAdvice? advice;
  String? createdAt;
  String? updatedAt;

  ProgramModel({
    this.id,
    this.name,
    this.duration,
    this.durationUnit,
    this.price,
    this.description,
    this.status,
    this.dietId,
    this.adviceId,
    this.exerciseId,
    this.foodRecognitionLimit,
    this.followUpPrice,
    this.imageUrl,
    this.diet,
    this.exercise,
    this.advice,
    this.createdAt,
    this.updatedAt,
  });

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static num? _toNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }

  ProgramModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    duration = _toInt(json['duration']);
    durationUnit = json['duration_unit']?.toString();
    price = _toNum(json['price']);
    description = json['description']?.toString();
    status = json['status']?.toString();
    dietId = _toInt(json['diet_id']);
    adviceId = _toInt(json['advice_id']);
    exerciseId = _toInt(json['exercise_id']);
    foodRecognitionLimit = _toInt(json['food_recognition_limit']);
    followUpPrice = _toNum(json['follow_up_price']);
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();

    if (json['diet'] != null && json['diet'] is Map) {
      diet = DietModel.fromJson(Map<String, dynamic>.from(json['diet'] as Map));
      imageUrl = diet?.dietImage;
    }

    if (json['exercise'] != null && json['exercise'] is Map) {
      final Map<String, dynamic> exerciseJson =
          Map<String, dynamic>.from(json['exercise'] as Map);
      if (exerciseJson['exercise_id'] != null) {
        exerciseJson['id'] = exerciseJson['exercise_id'];
      }
      exercise = ExerciseModel.fromJson(exerciseJson);
      imageUrl ??= exercise?.exerciseImage;
    }

    if (json['advice'] != null && json['advice'] is Map) {
      advice = ProgramAdvice.fromJson(
        Map<String, dynamic>.from(json['advice'] as Map),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['duration'] = duration;
    data['duration_unit'] = durationUnit;
    data['price'] = price;
    data['description'] = description;
    data['status'] = status;
    data['diet_id'] = dietId;
    data['advice_id'] = adviceId;
    data['exercise_id'] = exerciseId;
    data['food_recognition_limit'] = foodRecognitionLimit;
    data['follow_up_price'] = followUpPrice;
    data['image_url'] = imageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
