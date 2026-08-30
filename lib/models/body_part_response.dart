import '../utils/shared_import.dart';

class BodyPartResponse {
  Pagination? pagination;
  List<BodyPartModel>? data;

  BodyPartResponse({this.pagination, this.data});

  BodyPartResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <BodyPartModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(BodyPartModel.fromJson(v));
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

class BodyPartModel {
  int? id;
  String? title;
  String? status;
  String? description;
  String? bodypartImage;
  String? createdAt;
  String? updatedAt;
  bool? select;

  BodyPartModel({
    this.id,
    this.title,
    this.status,
    this.description,
    this.bodypartImage,
    this.createdAt,
    this.updatedAt,
    this.select = false,
  });

  BodyPartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    description = json['description'];
    bodypartImage = json['bodypart_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    select = json['select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['description'] = description;
    data['bodypart_image'] = bodypartImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['select'] = select;
    return data;
  }
}
