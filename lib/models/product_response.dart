import '../utils/shared_import.dart';

class ProductResponse {
  Pagination? pagination;
  List<ProductModel>? data;

  ProductResponse({this.pagination, this.data});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(ProductModel.fromJson(v));
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

class ProductModel {
  int? id;
  String? title;
  String? description;
  String? affiliateLink;
  num? price;
  int? productcategoryId;
  String? featured;
  String? status;
  String? productImage;
  String? createdAt;
  String? updatedAt;

  ProductModel({
    this.id,
    this.title,
    this.description,
    this.affiliateLink,
    this.price,
    this.productcategoryId,
    this.featured,
    this.status,
    this.productImage,
    this.createdAt,
    this.updatedAt,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    affiliateLink = json['affiliate_link'];
    price = json['price'];
    productcategoryId = json['productcategory_id'];
    featured = json['featured'];
    status = json['status'];
    productImage = json['product_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['affiliate_link'] = affiliateLink;
    data['price'] = price;
    data['productcategory_id'] = productcategoryId;
    data['featured'] = featured;
    data['status'] = status;
    data['product_image'] = productImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
