class WorkoutDetailResponse {
  WorkoutDetailModel? data;
  List<Workoutday>? workoutday;

  WorkoutDetailResponse({this.data, this.workoutday});

  WorkoutDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? WorkoutDetailModel.fromJson(json['data'])
        : null;
    if (json['workoutday'] != null) {
      workoutday = <Workoutday>[];
      json['workoutday'].forEach((dynamic v) {
        workoutday!.add(Workoutday.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (workoutday != null) {
      data['workoutday'] = workoutday!.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkoutDetailModel {
  int? id;
  String? title;
  String? status;
  int? isPremium;
  int? levelId;
  String? levelTitle;
  int? levelRate;
  String? workoutImage;
  int? workoutTypeId;
  String? workoutTypeTitle;
  String? createdAt;
  String? updatedAt;
  int? isFavourite;
  int? isFavouriteLocally;
  String? description;
  bool? isSelected = false;

  WorkoutDetailModel({
    this.id,
    this.title,
    this.status,
    this.isPremium,
    this.levelId,
    this.levelTitle,
    this.levelRate,
    this.workoutImage,
    this.workoutTypeId,
    this.workoutTypeTitle,
    this.createdAt,
    this.updatedAt,
    this.isFavourite,
    this.isFavouriteLocally,
    this.description,
  });

  WorkoutDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    isPremium = json['is_premium'];
    levelId = json['level_id'];
    levelTitle = json['level_title'];
    levelRate = json['level_rate'];
    workoutImage = json['workout_image'];
    workoutTypeId = json['workout_type_id'];
    workoutTypeTitle = json['workout_type_title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFavourite = json['is_favourite'];
    isFavouriteLocally = json['isFavouriteLocally'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['is_premium'] = isPremium;
    data['level_id'] = levelId;
    data['level_title'] = levelTitle;
    data['level_rate'] = levelRate;
    data['workout_image'] = workoutImage;
    data['workout_type_id'] = workoutTypeId;
    data['workout_type_title'] = workoutTypeTitle;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_favourite'] = isFavourite;
    data['isFavouriteLocally'] = isFavouriteLocally;
    data['description'] = description;
    return data;
  }
}

class Workoutday {
  int? id;
  int? workoutId;
  int? sequence;
  int? isRest;
  String? createdAt;
  String? updatedAt;

  Workoutday({
    this.id,
    this.workoutId,
    this.sequence,
    this.isRest,
    this.createdAt,
    this.updatedAt,
  });

  Workoutday.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workoutId = json['workout_id'];
    sequence = json['sequence'];
    isRest = json['is_rest'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['workout_id'] = workoutId;
    data['sequence'] = sequence;
    data['is_rest'] = isRest;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
