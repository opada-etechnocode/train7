import '../utils/shared_import.dart';

class DailyPlanRecipeListResponse {
  Pagination? pagination;
  List<RecipeItem> data = [];

  DailyPlanRecipeListResponse({this.pagination,required this.data});

  DailyPlanRecipeListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if(json['data'] != null) {
      json['data'].forEach((dynamic v) {
        data.add(RecipeItem.fromJson(v));
      });
    }
    }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
      data['data'] = this.data.map((dynamic v) => v.toJson()).toList();
    return data;
  }
}

class RecipeItem {
  int? id;
  String? title;
  int? calories;
  String? preparationTime;
  String? recipeImage;
  List<RecipeCategory>? recipeCategory;
  List<RecipeTag>? recipeTag;
  String? level;
  List<String>? specify;
  int? kcal;
  double? protein;
  double? fats;
  double? carbs;
  String? preparationMethods;
  double? ingredientUnit;
  String? createdAt;
  String? updatedAt;
  int? isFavourite;

  RecipeItem({
    this.id,
    this.title,
    this.calories,
    this.preparationTime,
    this.recipeImage,
    this.recipeCategory,
    this.recipeTag,
    this.level,
    this.specify,
    this.kcal,
    this.protein,
    this.fats,
    this.carbs,
    this.preparationMethods,
    this.ingredientUnit,
    this.createdAt,
    this.updatedAt,
    this.isFavourite,
  });

  RecipeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    calories = json['calories'];
    preparationTime = json['preparation_time']?.toString();
    recipeImage = json['recipe_image'];
    if (json['recipe_category'] != null) {
      recipeCategory = <RecipeCategory>[];
      if (json['recipe_category'] is List) {
        for (var v in (json['recipe_category'] as List)) {
          if (v is Map<String, dynamic>) {
            recipeCategory!.add(RecipeCategory.fromJson(v));
          } else {
            recipeCategory!.add(RecipeCategory(title: v?.toString()));
          }
        }
      }
    }
    if (json['recipe_tag'] != null) {
      recipeTag = <RecipeTag>[];
      if (json['recipe_tag'] is List) {
        for (var v in (json['recipe_tag'] as List)) {
          if (v is Map<String, dynamic>) {
            recipeTag!.add(RecipeTag.fromJson(v));
          } else {
            recipeTag!.add(RecipeTag(title: v?.toString()));
          }
        }
      }
    }
    level = json['level'];
    if (json['specify'] != null) {
      specify = json['specify'].cast<String>();
    }
    kcal = json['kcal'];
    protein = (json['protein'] as num?)?.toDouble();
    fats = (json['fats'] as num?)?.toDouble();
    carbs = (json['carbs'] as num?)?.toDouble();
    preparationMethods = json['preparation_methods'];
    ingredientUnit = (json['ingredient_unit'] as num?)?.toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['calories'] = calories;
    data['preparation_time'] = preparationTime;
    data['recipe_image'] = recipeImage;
    if (recipeCategory != null) {
      data['recipe_category'] = recipeCategory!.map((v) => v.toJson()).toList();
    }
    if (recipeTag != null) {
      data['recipe_tag'] = recipeTag!.map((v) => v.toJson()).toList();
    }
    data['level'] = level;
    data['specify'] = specify;
    data['kcal'] = kcal;
    data['protein'] = protein;
    data['fats'] = fats;
    data['carbs'] = carbs;
    data['preparation_methods'] = preparationMethods;
    data['ingredient_unit'] = ingredientUnit;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_favourite'] = isFavourite;
    return data;
  }
}

class RecipeCategory {
  int? id;
  String? title;
  String? recipeCategoryImage;

  RecipeCategory({this.id, this.title, this.recipeCategoryImage});

  RecipeCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    recipeCategoryImage = json['recipe_category_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['recipe_category_image'] = recipeCategoryImage;
    return data;
  }
}

class RecipeCategoryResponse {
  Pagination? pagination;
  List<RecipeCategory>? data = [];

  RecipeCategoryResponse({this.pagination, this.data});

  RecipeCategoryResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      json['data'].forEach((dynamic v) {
        data!.add(RecipeCategory.fromJson(v));
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

class RecipeTag {
  int? id;
  String? title;
  String? recipeTagImage;

  RecipeTag({this.id, this.title, this.recipeTagImage});

  RecipeTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    recipeTagImage = json['recipetag_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['recipetag_image'] = recipeTagImage;
    return data;
  }
}

class RecipeTagResponse {
  Pagination? pagination;
  List<RecipeTag>? data = [];

  RecipeTagResponse({this.pagination, this.data});

  RecipeTagResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      json['data'].forEach((dynamic v) {
        data!.add(RecipeTag.fromJson(v));
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
