import '../utils/shared_import.dart';

class CategoryDietResponse {
  Pagination? pagination;
  List<CategoryDietModel>? data;

  CategoryDietResponse({this.pagination, this.data});

  CategoryDietResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <CategoryDietModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(CategoryDietModel.fromJson(v));
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

class CategoryDietModel {
  int? id;
  String? title;
  String? status;
  String? categorydietImage;
  String? createdAt;
  String? updatedAt;
  // bool select = true;

  CategoryDietModel({
    this.id,
    this.title,
    this.status,
    this.categorydietImage,
    this.createdAt,
    this.updatedAt,
    // this.select = true
  });

  CategoryDietModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    categorydietImage = json['categorydiet_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // select = json['select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['categorydiet_image'] = categorydietImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    // data['select'] = this.select;
    return data;
  }
}
