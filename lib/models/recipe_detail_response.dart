class RecipeDetailResponse {
  RecipeDetailData? data;
  List<RecipeStep>? recipeSteps;
  List<RecipeIngredient>? recipeIngredients;

  RecipeDetailResponse({this.data, this.recipeSteps, this.recipeIngredients});

  RecipeDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? RecipeDetailData.fromJson(json['data'])
        : null;

    if (json['recipe_steps'] != null) {
      recipeSteps = <RecipeStep>[];
      for (dynamic v in (json['recipe_steps'] as List)) {
        if (v is Map<String, dynamic>) {
          recipeSteps!.add(RecipeStep.fromJson(v));
        }
      }
    }

    if (json['recipe_ingredients'] != null) {
      recipeIngredients = <RecipeIngredient>[];
      for (dynamic v in (json['recipe_ingredients'] as List)) {
        if (v is Map<String, dynamic>) {
          recipeIngredients!.add(RecipeIngredient.fromJson(v));
        }
      }
    }
  }
}

class RecipeDetailData {
  int? id;
  String? title;
  String? slug;
  String? type;
  List<String>? mealType;
  String? description;
  int? preparationTime;
  int? calories;
  num? protein;
  num? fats;
  num? carbs;
  List<RecipeCategoryMini>? recipeCategories;
  List<RecipeTagMini>? recipeTags;
  int? isFavourite;

  RecipeDetailData({
    this.id,
    this.title,
    this.slug,
    this.type,
    this.mealType,
    this.description,
    this.preparationTime,
    this.calories,
    this.protein,
    this.fats,
    this.carbs,
    this.recipeCategories,
    this.recipeTags,
    this.isFavourite,
  });

  RecipeDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    type = json['type'];
    if (json['meal_type'] is List) {
      mealType = (json['meal_type'] as List).map((e) => e.toString()).toList();
    }
    description = json['description'];
    preparationTime = (json['preparation_time'] as num?)?.toInt();
    calories = (json['calories'] as num?)?.toInt();
    protein = json['protein'] as num?;
    fats = json['fats'] as num?;
    carbs = json['carbs'] as num?;

    if (json['recipe_categories'] != null) {
      recipeCategories = <RecipeCategoryMini>[];
      for (dynamic v in (json['recipe_categories'] as List)) {
        if (v is Map<String, dynamic>) {
          recipeCategories!.add(RecipeCategoryMini.fromJson(v));
        }
      }
    }

    if (json['recipe_tags'] != null) {
      recipeTags = <RecipeTagMini>[];
      for (dynamic v in (json['recipe_tags'] as List)) {
        if (v is Map<String, dynamic>) {
          recipeTags!.add(RecipeTagMini.fromJson(v));
        }
      }
    }
    isFavourite = json['is_favourite'];
  }
}

class RecipeCategoryMini {
  int? id;
  String? name;

  RecipeCategoryMini({this.id, this.name});

  RecipeCategoryMini.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    name = json['name']?.toString();
  }
}

class RecipeTagMini {
  int? id;
  String? name;

  RecipeTagMini({this.id, this.name});

  RecipeTagMini.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    name = json['name']?.toString();
  }
}

class RecipeStep {
  int? id;
  String? instruction;
  int? sequence;

  RecipeStep({this.id, this.instruction, this.sequence});

  RecipeStep.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    instruction = json['instruction']?.toString();
    sequence = (json['sequence'] as num?)?.toInt();
  }
}

class RecipeIngredient {
  int? id;
  int? ingredientId;
  int? measurementUnitId;
  String? ingredientName;
  String? measurementUnitName;
  num? quantity;
  num? quantityGrams;
  num? calories;
  num? protein;
  num? fats;
  num? carbs;

  RecipeIngredient({
    this.id,
    this.ingredientId,
    this.measurementUnitId,
    this.ingredientName,
    this.measurementUnitName,
    this.quantity,
    this.quantityGrams,
    this.calories,
    this.protein,
    this.fats,
    this.carbs,
  });

  RecipeIngredient.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    ingredientId = (json['ingredient_id'] as num?)?.toInt();
    measurementUnitId = (json['measurement_unit_id'] as num?)?.toInt();
    ingredientName = json['ingredient_title']?.toString();
    measurementUnitName = json['measurement_unit_title']?.toString();
    quantity = json['quantity'] as num?;
    quantityGrams = json['quantity_grams'] as num?;
    calories = json['calories'] as num?;
    protein = json['protein'] as num?;
    fats = json['fats'] as num?;
    carbs = json['carbs'] as num?;
  }
}
