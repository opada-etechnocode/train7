import '../utils/shared_import.dart';

class FoodRecognitionResponse {
  bool? success;
  int? historyId;
  int? remainingRequests;
  FoodRecognitionData? data;

  FoodRecognitionResponse({
    this.success,
    this.historyId,
    this.remainingRequests,
    this.data,
  });

  FoodRecognitionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    historyId = json['history_id'];
    remainingRequests = json['remaining_requests'];
    data = json['data'] != null
        ? FoodRecognitionData.fromJson(json['data'])
        : null;
  }
}

class FoodRecognitionData {
  bool? isFood;
  String? lang;
  String? imagecacheId;
  List<FoodRecognitionGroup>? results;

  FoodRecognitionData({
    this.isFood,
    this.lang,
    this.imagecacheId,
    this.results,
  });

  FoodRecognitionData.fromJson(Map<String, dynamic> json) {
    isFood = json['is_food'];
    lang = json['lang'];
    imagecacheId = json['imagecache_id'];
    if (json['results'] != null) {
      results = <FoodRecognitionGroup>[];
      json['results'].forEach((dynamic v) {
        results!.add(FoodRecognitionGroup.fromJson(v));
      });
    }
  }

  FoodRecognitionItem? get topItem {
    FoodRecognitionItem? best;
    if (results == null) return null;
    for (final group in results!) {
      if (group.items == null) continue;
      for (final item in group.items!) {
        if (best == null || (item.score ?? 0) > (best.score ?? 0)) {
          best = item;
        }
      }
    }
    return best;
  }
}

class FoodRecognitionGroup {
  String? group;
  List<FoodRecognitionItem>? items;

  FoodRecognitionGroup({this.group, this.items});

  FoodRecognitionGroup.fromJson(Map<String, dynamic> json) {
    group = json['group'];
    if (json['items'] != null) {
      items = <FoodRecognitionItem>[];
      json['items'].forEach((dynamic v) {
        items!.add(FoodRecognitionItem.fromJson(v));
      });
    }
  }
}

class FoodRecognitionItem {
  String? name;
  String? foodId;
  String? group;
  int? score;
  bool? generic;
  FoodNutrition? nutrition;
  List<FoodServingSize>? servingSizes;

  FoodRecognitionItem({
    this.name,
    this.foodId,
    this.group,
    this.score,
    this.generic,
    this.nutrition,
    this.servingSizes,
  });

  FoodRecognitionItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    foodId = json['food_id'];
    group = json['group'];
    score = json['score'];
    generic = json['generic'];
    nutrition = json['nutrition'] != null
        ? FoodNutrition.fromJson(json['nutrition'])
        : null;
    if (json['servingSizes'] != null) {
      servingSizes = <FoodServingSize>[];
      json['servingSizes'].forEach((dynamic v) {
        servingSizes!.add(FoodServingSize.fromJson(v));
      });
    }
  }
}

class FoodNutrition {
  num? calories;
  num? protein;
  num? totalFat;
  num? totalCarbs;

  FoodNutrition({
    this.calories,
    this.protein,
    this.totalFat,
    this.totalCarbs,
  });

  FoodNutrition.fromJson(Map<String, dynamic> json) {
    calories = json['calories'];
    protein = json['protein'];
    totalFat = json['totalFat'];
    totalCarbs = json['totalCarbs'];
  }
}

class FoodServingSize {
  String? unit;
  num? servingWeight;

  FoodServingSize({this.unit, this.servingWeight});

  FoodServingSize.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    servingWeight = json['servingWeight'];
  }
}

class FoodRecognitionListResponse {
  Pagination? pagination;
  List<FoodRecognitionHistory>? data;

  FoodRecognitionListResponse({this.pagination, this.data});

  FoodRecognitionListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <FoodRecognitionHistory>[];
      json['data'].forEach((dynamic v) {
        data!.add(FoodRecognitionHistory.fromJson(v));
      });
    }
  }
}

class FoodRecognitionHistory {
  int? id;
  String? provider;
  bool? isFood;
  String? topFoodName;
  String? topGroup;
  int? topScore;
  String? calories;
  String? protein;
  String? totalFat;
  String? totalCarbs;
  String? status;
  String? image;
  FoodRecognitionData? responseJson;
  String? createdAt;
  String? updatedAt;

  FoodRecognitionHistory({
    this.id,
    this.provider,
    this.isFood,
    this.topFoodName,
    this.topGroup,
    this.topScore,
    this.calories,
    this.protein,
    this.totalFat,
    this.totalCarbs,
    this.status,
    this.image,
    this.responseJson,
    this.createdAt,
    this.updatedAt,
  });

  FoodRecognitionHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provider = json['provider'];
    isFood = json['is_food'];
    topFoodName = json['top_food_name'];
    topGroup = json['top_group'];
    topScore = json['top_score'];
    calories = json['calories']?.toString();
    protein = json['protein']?.toString();
    totalFat = json['total_fat']?.toString();
    totalCarbs = json['total_carbs']?.toString();
    status = json['status'];
    image = json['image'];
    if (json['response_json'] != null) {
      if (json['response_json'] is Map<String, dynamic>) {
        responseJson = FoodRecognitionData.fromJson(json['response_json']);
      } else if (json['response_json'] is String) {
            try {
      responseJson = FoodRecognitionData.fromJson(
            jsonDecode(json['response_json']),
          );
        } on Exception catch (_) {}
      }
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  String get formattedCalories {
    final value = double.tryParse(calories.validate()) ?? 0;
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}
