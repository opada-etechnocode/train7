class ExerciseDetailResponse {
  ExerciseData? data;

  ExerciseDetailResponse({this.data});

  ExerciseDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ExerciseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ExerciseData {
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
  String? equipmentImg;
  int? levelId;
  String? levelTitle;
  String? instruction;
  String? tips;
  String? createdAt;
  String? updatedAt;
  String? type;
  String? based;
  int? secondsPerRep;

  ExerciseData({
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
    this.equipmentImg,
    this.levelId,
    this.levelTitle,
    this.instruction,
    this.tips,
    this.createdAt,
    this.type,
    this.based,
    this.secondsPerRep,
    this.updatedAt,
  });

  ExerciseData.fromJson(Map<String, dynamic> json) {
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
    equipmentImg = json['equipment_image'];
    levelId = json['level_id'];
    levelTitle = json['level_title'];
    instruction = json['instruction'];
    tips = json['tips'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    based = json['based'];
    secondsPerRep = json['seconds_per_rep'];
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
    data['equipment_image'] = equipmentImg;
    data['level_id'] = levelId;
    data['level_title'] = levelTitle;
    data['instruction'] = instruction;
    data['tips'] = tips;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['type'] = type;
    data['based'] = based;
    data['seconds_per_rep'] = secondsPerRep;
    return data;
  }
}

class BodypartName {
  int? id;
  String? title;
  String? bodypartImage;

  BodypartName({this.id, this.title, this.bodypartImage});

  BodypartName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bodypartImage = json['bodypart_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['bodypart_image'] = bodypartImage;
    return data;
  }
}

class Sets {
  String? reps;
  String? rest;
  String? time;
  String? weight;

  Sets({this.reps, this.rest, this.time, this.weight});

  Sets.fromJson(Map<String, dynamic> json) {
    reps = json['reps'];
    rest = json['rest'];
    time = json['time'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reps'] = reps;
    data['rest'] = rest;
    data['time'] = time;
    data['weight'] = weight;
    return data;
  }
}
