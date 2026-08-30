import '../utils/shared_import.dart';

class ExerciseResponse {
  Pagination? pagination;
  List<ExerciseModel>? data;

  ExerciseResponse({this.pagination, this.data});

  ExerciseResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ExerciseModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(ExerciseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExerciseModel {
  int? id;
  String? title;
  String? status;
  int? isPremium;
  String? exerciseImage;
  String? videoType;
  String? videoUrl;
  List<BodypartName>? bodypartName;
  String? duration;
  List<Sets>? sets;
  int? equipmentId;
  String? equipmentTitle;
  int? levelId;
  String? levelTitle;
  String? instruction;
  String? tips;
  String? createdAt;
  String? updatedAt;
  String? type;
  String? based;

  ExerciseModel({
    this.id,
    this.title,
    this.status,
    this.isPremium,
    this.exerciseImage,
    this.videoType,
    this.videoUrl,
    this.bodypartName,
    this.duration,
    this.sets,
    this.equipmentId,
    this.equipmentTitle,
    this.levelId,
    this.levelTitle,
    this.instruction,
    this.tips,
    this.createdAt,
    this.type,
    this.based,
    this.updatedAt,
  });

  ExerciseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    isPremium = json['is_premium'];
    exerciseImage = json['exercise_image'];
    videoType = json['video_type'];
    videoUrl = json['video_url'];
    if (json['bodypart_name'] != null) {
      bodypartName = <BodypartName>[];
      json['bodypart_name'].forEach((dynamic v) {
        bodypartName!.add(BodypartName.fromJson(v));
      });
    }
    duration = json['duration'];
    if (json['sets'] != null) {
      sets = <Sets>[];
      json['sets'].forEach((dynamic v) {
        sets!.add(Sets.fromJson(v));
      });
    }
    equipmentId = json['equipment_id'];
    equipmentTitle = json['equipment_title'];
    levelId = json['level_id'];
    levelTitle = json['level_title'];
    instruction = json['instruction'];
    tips = json['tips'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    based = json['based'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['is_premium'] = isPremium;
    data['exercise_image'] = exerciseImage;
    data['video_type'] = videoType;
    data['video_url'] = videoUrl;
    if (bodypartName != null) {
      data['bodypart_name'] = bodypartName!.map((dynamic v) => v.toJson()).toList();
    }
    data['duration'] = duration;
    if (sets != null) {
      data['sets'] = sets!.map((dynamic v) => v.toJson()).toList();
    }
    data['equipment_id'] = equipmentId;
    data['equipment_title'] = equipmentTitle;
    data['level_id'] = levelId;
    data['level_title'] = levelTitle;
    data['instruction'] = instruction;
    data['tips'] = tips;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['type'] = type;
    data['based'] = based;
    return data;
  }
}
