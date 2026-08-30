import '../utils/shared_import.dart';

class LevelResponse {
  Pagination? pagination;
  List<LevelModel>? data;

  LevelResponse({this.pagination, this.data});

  LevelResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <LevelModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(LevelModel.fromJson(v));
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

class LevelModel {
  int? id;
  String? title;
  int? rate;
  String? status;
  String? levelImage;
  String? createdAt;
  String? updatedAt;
  bool? select = false;

  LevelModel({
    this.id,
    this.title,
    this.rate,
    this.status,
    this.levelImage,
    this.createdAt,
    this.updatedAt,
  });

  LevelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    rate = json['rate'];
    status = json['status'];
    levelImage = json['level_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['rate'] = rate;
    data['status'] = status;
    data['level_image'] = levelImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    return data;
  }
}
