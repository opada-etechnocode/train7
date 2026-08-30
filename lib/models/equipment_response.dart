import '../utils/shared_import.dart';

class EquipmentResponse {
  Pagination? pagination;
  List<EquipmentModel>? data;

  EquipmentResponse({this.pagination, this.data});

  EquipmentResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <EquipmentModel>[];
      json['data'].forEach((dynamic v) {
        data!.add(EquipmentModel.fromJson(v));
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

class EquipmentModel {
  int? id;
  String? title;
  String? status;
  String? description;
  String? equipmentImage;
  String? createdAt;
  String? updatedAt;
  bool? isSelected = false;

  EquipmentModel({
    this.id,
    this.title,
    this.status,
    this.description,
    this.equipmentImage,
    this.createdAt,
    this.updatedAt,
  });

  EquipmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    description = json['description'];
    equipmentImage = json['equipment_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['description'] = description;
    data['equipment_image'] = equipmentImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
