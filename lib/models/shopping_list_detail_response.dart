
// Helper: safely parse int whether the API sends a number or a string.
int? _parseInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

// Helper: safely parse num whether the API sends a number or a string.
num? _parseNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString());
}

// Helper: safely parse bool — handles true/false, 1/0, "1"/"0", "true"/"false".
bool? _parseBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is int) return v != 0;
  final s = v.toString().toLowerCase();
  if (s == '1' || s == 'true') return true;
  if (s == '0' || s == 'false') return false;
  return null;
}

class ShoppingListDetailResponse {
  String? message;
  ShoppingListDetailData? data;

  ShoppingListDetailResponse({this.message, this.data});

  ShoppingListDetailResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? ShoppingListDetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ShoppingListDetailData {
  int? id;
  int? userId;
  int? dailyPlanId;
  String? title;
  String? startDate;
  String? endDate;
  int? servings;
  String? status;
  int? itemsCount;
  List<ShoppingListItem>? items;
  List<ShoppingListCategory>? itemsByCategory;
  String? createdAt;
  String? updatedAt;

  ShoppingListDetailData({
    this.id,
    this.userId,
    this.dailyPlanId,
    this.title,
    this.startDate,
    this.endDate,
    this.servings,
    this.status,
    this.itemsCount,
    this.items,
    this.itemsByCategory,
    this.createdAt,
    this.updatedAt,
  });

  ShoppingListDetailData.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    userId = _parseInt(json['user_id']);
    dailyPlanId = _parseInt(json['daily_plan_id']);
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    servings = _parseInt(json['servings']);
    status = json['status'];
    itemsCount = _parseInt(json['items_count']);
    if (json['items'] != null) {
      items = <ShoppingListItem>[];
      json['items'].forEach((v) {
        items!.add(ShoppingListItem.fromJson(v));
      });
    }
    if (json['items_by_category'] != null) {
      itemsByCategory = <ShoppingListCategory>[];
      json['items_by_category'].forEach((v) {
        itemsByCategory!.add(ShoppingListCategory.fromJson(v));
      });
    }
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
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (itemsByCategory != null) {
      data['items_by_category'] = itemsByCategory!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ShoppingListItem {
  int? id;
  int? shoppingListId;
  int? ingredientId;
  String? ingredientTitle;
  int? ingredientCategoryId;
  String? ingredientCategoryTitle;
  String? customItemName;
  num? totalGrams;
  num? displayQuantity;
  int? measurementUnitId;
  String? displayUnitTitle;
  String? displayUnitSymbol;
  bool? isChecked;
  bool? manuallyAdded;
  String? createdAt;
  String? updatedAt;

  ShoppingListItem({
    this.id,
    this.shoppingListId,
    this.ingredientId,
    this.ingredientTitle,
    this.ingredientCategoryId,
    this.ingredientCategoryTitle,
    this.customItemName,
    this.totalGrams,
    this.displayQuantity,
    this.measurementUnitId,
    this.displayUnitTitle,
    this.displayUnitSymbol,
    this.isChecked,
    this.manuallyAdded,
    this.createdAt,
    this.updatedAt,
  });

  ShoppingListItem.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    shoppingListId = _parseInt(json['shopping_list_id']);
    ingredientId = _parseInt(json['ingredient_id']);
    ingredientTitle = json['ingredient_title'];
    ingredientCategoryId = _parseInt(json['ingredient_category_id']);
    ingredientCategoryTitle = json['ingredient_category_title'];
    customItemName = json['custom_item_name'];
    totalGrams = _parseNum(json['total_grams']);
    displayQuantity = _parseNum(json['display_quantity']);
    measurementUnitId = _parseInt(json['measurement_unit_id']);
    displayUnitTitle = json['display_unit_title'];
    displayUnitSymbol = json['display_unit_symbol'];
    isChecked = _parseBool(json['is_checked']);
    manuallyAdded = _parseBool(json['manually_added']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shopping_list_id'] = shoppingListId;
    data['ingredient_id'] = ingredientId;
    data['ingredient_title'] = ingredientTitle;
    data['ingredient_category_id'] = ingredientCategoryId;
    data['ingredient_category_title'] = ingredientCategoryTitle;
    data['custom_item_name'] = customItemName;
    data['total_grams'] = totalGrams;
    data['display_quantity'] = displayQuantity;
    data['measurement_unit_id'] = measurementUnitId;
    data['display_unit_title'] = displayUnitTitle;
    data['display_unit_symbol'] = displayUnitSymbol;
    data['is_checked'] = isChecked;
    data['manually_added'] = manuallyAdded;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ShoppingListCategory {
  int? ingredientCategoryId;
  String? ingredientCategoryTitle;
  List<ShoppingListItem>? items;

  ShoppingListCategory({
    this.ingredientCategoryId,
    this.ingredientCategoryTitle,
    this.items,
  });

  ShoppingListCategory.fromJson(Map<String, dynamic> json) {
    ingredientCategoryId = _parseInt(json['ingredient_category_id']);
    ingredientCategoryTitle = json['ingredient_category_title'];
    if (json['items'] != null) {
      items = <ShoppingListItem>[];
      json['items'].forEach((v) {
        items!.add(ShoppingListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ingredient_category_id'] = ingredientCategoryId;
    data['ingredient_category_title'] = ingredientCategoryTitle;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
