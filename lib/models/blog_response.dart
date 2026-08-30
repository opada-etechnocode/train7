import '../utils/shared_import.dart';

class BlogResponse {
  Pagination? pagination;
  List<BlogModel>? data;

  BlogResponse({this.pagination, this.data});

  BlogResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <BlogModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(BlogModel.fromJson(v));
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

class BlogModel {
  int? id;
  String? title;
  List<TagsName>? tagsName;
  List<String>? tagsId;
  List<String>? categoryIds;
  List<TagsName>? categoryName;
  String? datetime;
  String? status;
  String? isFeatured;
  String? postImage;
  String? description;
  String? createdAt;
  String? updatedAt;

  BlogModel({
    this.id,
    this.title,
    this.tagsName,
    this.tagsId,
    this.categoryIds,
    this.categoryName,
    this.datetime,
    this.status,
    this.isFeatured,
    this.postImage,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  BlogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['tags_name'] != null) {
      tagsName = <TagsName>[];
      json['tags_name'].forEach((dynamic v) {
        tagsName!.add(TagsName.fromJson(v));
      });
    }
    tagsId = json['tags_id'].cast<String>();
    categoryIds = json['category_ids'].cast<String>();
    if (json['category_name'] != null) {
      categoryName = <TagsName>[];
      json['category_name'].forEach((dynamic v) {
        categoryName!.add(TagsName.fromJson(v));
      });
    }
    datetime = json['datetime'];
    status = json['status'];
    isFeatured = json['is_featured'];
    postImage = json['post_image'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (tagsName != null) {
      data['tags_name'] = tagsName!.map((v) => v.toJson()).toList();
    }
    data['tags_id'] = tagsId;
    data['category_ids'] = categoryIds;
    if (categoryName != null) {
      data['category_name'] = categoryName!.map((v) => v.toJson()).toList();
    }
    data['datetime'] = datetime;
    data['status'] = status;
    data['is_featured'] = isFeatured;
    data['post_image'] = postImage;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class TagsName {
  int? id;
  String? title;

  TagsName({this.id, this.title});

  TagsName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
