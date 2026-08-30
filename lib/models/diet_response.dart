import '../utils/shared_import.dart';

class DietResponse {
  Pagination? pagination;
  List<DietModel>? data;

  DietResponse({this.pagination, this.data});

  DietResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <DietModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(DietModel.fromJson(v));
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

class DietModel {
  int? id;
  String? title;
  String? calories;
  String? carbs;
  String? protein;
  String? fat;
  String? servings;
  String? totalTime;
  String? isFeatured;
  String? status;
  String? ingredients;
  String? description;
  String? dietImage;
  int? isPremium;
  int? categorydietId;
  String? categorydietTitle;
  String? createdAt;
  String? updatedAt;
  int? isFavourite;

  DietModel({
    this.id,
    this.title,
    this.calories,
    this.carbs,
    this.protein,
    this.fat,
    this.servings,
    this.totalTime,
    this.isFeatured,
    this.status,
    this.ingredients,
    this.description,
    this.dietImage,
    this.isPremium,
    this.categorydietId,
    this.categorydietTitle,
    this.createdAt,
    this.updatedAt,
    this.isFavourite,
  });

  DietModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    calories = json['calories'];
    carbs = json['carbs'];
    protein = json['protein'];
    fat = json['fat'];
    servings = json['servings'];
    totalTime = json['total_time'];
    isFeatured = json['is_featured'];
    status = json['status'];
    ingredients = json['ingredients'];
    description = json['description'];
    dietImage = json['diet_image'];
    isPremium = json['is_premium'];
    categorydietId = json['categorydiet_id'];
    categorydietTitle = json['categorydiet_title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['calories'] = calories;
    data['carbs'] = carbs;
    data['protein'] = protein;
    data['fat'] = fat;
    data['servings'] = servings;
    data['total_time'] = totalTime;
    data['is_featured'] = isFeatured;
    data['status'] = status;
    data['ingredients'] = ingredients;
    data['description'] = description;
    data['diet_image'] = dietImage;
    data['is_premium'] = isPremium;
    data['categorydiet_id'] = categorydietId;
    data['categorydiet_title'] = categorydietTitle;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_favourite'] = isFavourite;
    return data;
  }
}
