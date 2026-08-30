class MacroNutrientResponse {
  Map<String, double>? activityLevel;
  Map<String, double>? fitnessGoal;
  Map<String, MacroRatio>? macroRatio;
  List<String>? mealType;

  MacroNutrientResponse({
    this.activityLevel,
    this.fitnessGoal,
    this.macroRatio,
    this.mealType,
  });

  MacroNutrientResponse.fromJson(Map<String, dynamic> json) {
    if (json['ACTIVITY_LEVEL'] != null) {
      activityLevel = <String, double>{};
      json['ACTIVITY_LEVEL'].forEach((dynamic k, dynamic v) {
        activityLevel![k] = (v as num).toDouble();
      });
    }
    if (json['FITNESS_GOAL'] != null) {
      fitnessGoal = <String, double>{};
      json['FITNESS_GOAL'].forEach((dynamic k, dynamic v) {
        fitnessGoal![k] = (v as num).toDouble();
      });
    }
    if (json['MACRO_RATIO'] != null) {
      macroRatio = <String, MacroRatio>{};
      json['MACRO_RATIO'].forEach((dynamic k, dynamic v) {
        macroRatio![k] = MacroRatio.fromJson(v);
      });
    }
    mealType = json['MEAL_TYPE']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (activityLevel != null) {
      data['ACTIVITY_LEVEL'] = activityLevel;
    }
    if (fitnessGoal != null) {
      data['FITNESS_GOAL'] = fitnessGoal;
    }
    if (macroRatio != null) {
      data['MACRO_RATIO'] = macroRatio!.map((k, v) => MapEntry(k, v.toJson()));
    }
    data['MEAL_TYPE'] = mealType;
    return data;
  }
}

class MacroRatio {
  int? carbs;
  int? protein;
  int? fat;

  MacroRatio({this.carbs, this.protein, this.fat});

  MacroRatio.fromJson(Map<String, dynamic> json) {
    carbs = json['carbs'];
    protein = json['protein'];
    fat = json['fat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['carbs'] = carbs;
    data['protein'] = protein;
    data['fat'] = fat;
    return data;
  }
}
