import '../utils/shared_import.dart';

class WorkoutTypeResponse {
  Pagination? pagination;
  List<WorkoutTypeModel>? data;

  WorkoutTypeResponse({this.pagination, this.data});

  WorkoutTypeResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <WorkoutTypeModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(WorkoutTypeModel.fromJson(v));
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

class WorkoutTypeModel {
  int? id;
  String? title;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool? select = false;

  WorkoutTypeModel({
    this.id,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  WorkoutTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
