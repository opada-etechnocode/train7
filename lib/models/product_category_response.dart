import '../utils/shared_import.dart';

class ProductCategoryResponse {
  Pagination? pagination;
  List<ProductCategoryModel>? data;

  ProductCategoryResponse({this.pagination, this.data});

  ProductCategoryResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ProductCategoryModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(ProductCategoryModel.fromJson(v));
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

class ProductCategoryModel {
  int? id;
  String? title;
  String? productcategoryImage;
  String? createdAt;
  String? updatedAt;

  ProductCategoryModel({
    this.id,
    this.title,
    this.productcategoryImage,
    this.createdAt,
    this.updatedAt,
  });

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    productcategoryImage = json['productcategory_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['productcategory_image'] = productcategoryImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
