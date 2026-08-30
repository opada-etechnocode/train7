class DailyPlanResponse {
  DailyPlanData? data;
  DailyPlanRecipe? dailyPlanRecipe;
  List<String>? dayHasDailyPlan;

  DailyPlanResponse({this.data, this.dailyPlanRecipe, this.dayHasDailyPlan});

  DailyPlanResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DailyPlanData.fromJson(json['data']) : null;
    dailyPlanRecipe = json['daily_plan_recipe'] != null
        ? DailyPlanRecipe.fromJson(json['daily_plan_recipe'])
        : null;
    dayHasDailyPlan = json['day_has_daily_plan'] != null
        ? List<String>.from(json['day_has_daily_plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (dailyPlanRecipe != null) {
      data['daily_plan_recipe'] = dailyPlanRecipe!.toJson();
    }
    if (dayHasDailyPlan != null) {
      data['day_has_daily_plan'] = dayHasDailyPlan;
    }
    return data;
  }
}

class DailyPlanData {
  int? id;
  int? userId;
  String? date;
  num? eaten;
  num? leftEat;
  int? dailyKcal;
  int? calories;
  int? protein;
  int? fats;
  int? carbs;
  DailyPlan? dailyPlan;
  List<MealType>? mealType = [];
  String? createdAt;
  String? updatedAt;

  DailyPlanData({
    this.id,
    this.userId,
    this.date,
    this.eaten,
    this.leftEat,
    this.dailyKcal,
    this.calories,
    this.protein,
    this.fats,
    this.carbs,
    this.dailyPlan,
    this.mealType,
    this.createdAt,
    this.updatedAt,
  });

  DailyPlanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    eaten = json['eaten'];
    leftEat = json['left_eat'];
    dailyKcal = json['daily_kcal'];
    calories = json['calories'];
    protein = json['protein'];
    fats = json['fats'];
    carbs = json['carbs'];
    dailyPlan = json['daily_plan'] != null
        ? DailyPlan.fromJson(json['daily_plan'])
        : null;
      json['meal_type'].forEach((dynamic v) {
        mealType!.add(MealType.fromJson(v));
      });
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['date'] = date;
    data['eaten'] = eaten;
    data['left_eat'] = leftEat;
    data['daily_kcal'] = dailyKcal;
    data['calories'] = calories;
    data['protein'] = protein;
    data['fats'] = fats;
    data['carbs'] = carbs;
    if (dailyPlan != null) {
      data['daily_plan'] = dailyPlan!.toJson();
    }
    if (mealType != null) {
      data['meal_type'] = mealType!.map((dynamic v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DailyPlan {
  MacroTarget? protein;
  MacroTarget? fat;
  MacroTarget? carbs;
  String? age;
  String? goal;
  String? activity;
  String? macroType;
  String? weightInKg;
  dynamic heightInCm;
  String? bmr;
  int? kCal;
  double? kCalFrom;
  double? kCalTo;

  DailyPlan({
    this.protein,
    this.fat,
    this.carbs,
    this.age,
    this.goal,
    this.activity,
    this.macroType,
    this.weightInKg,
    this.heightInCm,
    this.bmr,
    this.kCal,
    this.kCalFrom,
    this.kCalTo,
  });

  DailyPlan.fromJson(Map<String, dynamic> json) {
    protein = json['protein'] != null
        ? MacroTarget.fromJson(json['protein'])
        : null;
    fat = json['fat'] != null ? MacroTarget.fromJson(json['fat']) : null;
    carbs = json['carbs'] != null ? MacroTarget.fromJson(json['carbs']) : null;
    age = json['age'];
    goal = json['goal'];
    activity = json['activity'];
    macroType = json['macro_type'];
    weightInKg = json['weight_in_kg'];
    heightInCm = json['height_in_cm'];
    bmr = json['bmr'];
    kCal = json['kCal'];
    kCalFrom = (json['kCal_from'] as num?)?.toDouble();
    kCalTo = (json['kCal_to'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (protein != null) {
      data['protein'] = protein!.toJson();
    }
    if (fat != null) {
      data['fat'] = fat!.toJson();
    }
    if (carbs != null) {
      data['carbs'] = carbs!.toJson();
    }
    data['age'] = age;
    data['goal'] = goal;
    data['activity'] = activity;
    data['macro_type'] = macroType;
    data['weight_in_kg'] = weightInKg;
    data['height_in_cm'] = heightInCm;
    data['bmr'] = bmr;
    data['kCal'] = kCal;
    data['kCal_from'] = kCalFrom;
    data['kCal_to'] = kCalTo;
    return data;
  }
}

class MacroTarget {
  num? target;
  num? from;
  num? to;

  MacroTarget({this.target, this.from, this.to});

  MacroTarget.fromJson(Map<String, dynamic> json) {
    target = json['target'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['target'] = target;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

class MealType {
  String? key;
  String? displayName;
  MealTotal? total;

  MealType({this.key, this.displayName, this.total});

  MealType.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    displayName = json['display_name'];
    total = json['total'] != null ? MealTotal.fromJson(json['total']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['display_name'] = displayName;
    if (total != null) {
      data['total'] = total!.toJson();
    }
    return data;
  }
}

class MealTotal {
  int? totalCalories;
  int? totalProtein;
  int? totalCarbs;
  int? totalFats;

  MealTotal({
    this.totalCalories,
    this.totalProtein,
    this.totalCarbs,
    this.totalFats,
  });

  MealTotal.fromJson(Map<String, dynamic> json) {
    totalCalories = json['total_calories'];
    totalProtein = json['total_protein'];
    totalCarbs = json['total_carbs'];
    totalFats = json['total_fats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_calories'] = totalCalories;
    data['total_protein'] = totalProtein;
    data['total_carbs'] = totalCarbs;
    data['total_fats'] = totalFats;
    return data;
  }
}

class DailyPlanRecipe {
  Map<String, List<DailyPlanRecipeItem>>? mealRecipes;

  DailyPlanRecipe({this.mealRecipes});

  DailyPlanRecipe.fromJson(Map<String, dynamic> json) {
    mealRecipes = {};
    json.forEach((String key, dynamic v) {
      if (v is List) {
        mealRecipes![key] = v
            .map((item) => DailyPlanRecipeItem.fromJson(item))
            .toList();
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    mealRecipes?.forEach((key, value) {
      data[key] = value.map((v) => v.toJson()).toList();
    });
    return data;
  }

  List<DailyPlanRecipeItem>? get breakfast => mealRecipes?['breakfast'];
  List<DailyPlanRecipeItem>? get lunch => mealRecipes?['lunch'];
  List<DailyPlanRecipeItem>? get dinner => mealRecipes?['dinner'];
  List<DailyPlanRecipeItem>? get snacks => mealRecipes?['snacks'];
}

class DailyPlanRecipeItem {
  int? id;
  int? dailyPlanId;
  int? recipeId;
  int? calories;
  int? protein;
  int? fats;
  int? carbs;
  String? mealType;
  Recipe? recipe;
  bool? isComplete;
  String? createdAt;
  String? updatedAt;

  DailyPlanRecipeItem({
    this.id,
    this.dailyPlanId,
    this.recipeId,
    this.calories,
    this.protein,
    this.fats,
    this.carbs,
    this.mealType,
    this.recipe,
    this.isComplete,
    this.createdAt,
    this.updatedAt,
  });

  DailyPlanRecipeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dailyPlanId = json['daily_plan_id'];
    recipeId = json['recipe_id'];
    calories = json['calories'];
    protein = json['protein'];
    fats = json['fats'];
    carbs = json['carbs'];
    mealType = json['meal_type'];
    recipe = json['recipe'] != null ? Recipe.fromJson(json['recipe']) : null;
    isComplete = json['is_complete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['daily_plan_id'] = dailyPlanId;
    data['recipe_id'] = recipeId;
    data['calories'] = calories;
    data['protein'] = protein;
    data['fats'] = fats;
    data['carbs'] = carbs;
    data['meal_type'] = mealType;
    if (recipe != null) {
      data['recipe'] = recipe!.toJson();
    }
    data['is_complete'] = isComplete;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Recipe {
  int? id;
  String? title;
  String? recipeImage;
  int? calories;
  int? protein;
  int? fats;
  int? carbs;

  Recipe({
    this.id,
    this.title,
    this.recipeImage,
    this.calories,
    this.protein,
    this.fats,
    this.carbs,
  });

  Recipe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    recipeImage = json['recipe_image'];
    calories = json['calories'];
    protein = json['protein'];
    fats = json['fats'];
    carbs = json['carbs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['recipe_image'] = recipeImage;
    data['calories'] = calories;
    data['protein'] = protein;
    data['fats'] = fats;
    data['carbs'] = carbs;
    return data;
  }
}
