import '../utils/shared_import.dart';


class ShoppingListResponse {
  Pagination? pagination;
  List<ShoppingListData>? data;

  ShoppingListResponse({this.pagination, this.data});

  ShoppingListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ShoppingListData>[];
      json['data'].forEach((v) {
        data!.add(ShoppingListData.fromJson(v));
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

class ShoppingListData {
  int? id;
  int? userId;
  int? dailyPlanId;
  String? title;
  String? startDate;
  String? endDate;
  int? servings;
  String? status;
  int? itemsCount;
  String? createdAt;
  String? updatedAt;

  ShoppingListData({
    this.id,
    this.userId,
    this.dailyPlanId,
    this.title,
    this.startDate,
    this.endDate,
    this.servings,
    this.status,
    this.itemsCount,
    this.createdAt,
    this.updatedAt,
  });

  ShoppingListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    dailyPlanId = json['daily_plan_id'];
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    servings = json['servings'];
    status = json['status'];
    itemsCount = json['items_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['daily_plan_id'] = dailyPlanId;
    data['title'] = title;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['servings'] = servings;
    data['status'] = status;
    data['items_count'] = itemsCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
