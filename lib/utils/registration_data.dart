import 'dart:developer' show log;
import '../extensions/extension_util/string_extensions.dart';
import '../models/macro_nutrient_response.dart';
import '../network/rest_api.dart';

class RegistrationData {
  static Map<String, double>? activityLevelValue;
  static Map<String, double>? fitnessGoalValue;
  static Map<String, MacroRatio>? macroRatioValue;
  static List<String>? mealTypeValue;

  static const Map<String, String> activityLevel = {
    'bmr': 'Basal Metabolic Rate (BMR)',
    'sedentary': 'Sedentary|Little or no exercise',
    'lightly_active': 'Lightly active|Exercise 1-3 times per week',
    'moderate': 'Moderately active|Exercise 4-5 times per week',
    'active': 'Active|daily exercise or intense exercise 3-4 times per week',
    'very_active': 'Very active|intense exercise 6-7 times per week',
    'extra_active': 'Extra active|very intense exercise daily or physical job',
  };

  static const Map<String, String> fitnessGoal = {
    'm': 'Maintain weight|Maintain my current weight',
    'l': 'Mild weight loss|0.5 lb (0.25 kg) per week',
    'l1': 'Weight loss|1 lb (0.5 kg) per week',
    'l2': 'Extreme weight loss|2 lb (1 kg) per week',
    'l3': 'Extreme weight loss|4 lb (2 kg) per week',
    'g': 'Mild weight gain|0.5 lb (0.25 kg) per week',
    'g1': 'Weight gain|1 lb (0.5 kg) per week',
    'g2': 'Extreme weight gain|2 lb (1 kg) per week',
    'g3': 'Extreme weight gain|4 lb (2 kg) per week',
  };

  static const Map<String, String> mealType = {
    "breakfast": "Breakfast",
    "lunch": "Lunch",
    "dinner": "Dinner",
    "snacks": "Snacks",
    "snacks2": "Snacks2",
  };

  static const Map<String, Map<String, int>> macroRatio = {
    'balanced': {'carbs': 40, 'protein': 30, 'fat': 30},
    'low_fat': {'carbs': 40, 'protein': 40, 'fat': 20},
    'high_protein': {'carbs': 20, 'protein': 50, 'fat': 30},
    'high_carb': {'carbs': 55, 'protein': 25, 'fat': 20},
    'keto': {'carbs': 5, 'protein': 25, 'fat': 70},
  };

  static Map<String, Map<String, int>> getMacroRatios() {
    if (macroRatioValue != null) {
      final Map<String, Map<String, int>> result = {};
      macroRatioValue!.forEach((key, value) {
        result[key] = {
          'carbs': value.carbs ?? 0,
          'protein': value.protein ?? 0,
          'fat': value.fat ?? 0,
        };
      });
      return result;
    }
    return macroRatio;
  }

  static Map<String, String> getAvailableActivityLevels() {
    if (activityLevelValue == null) {
      return activityLevel;
    }

    final Map<String, String> result = {};
    activityLevelValue!.forEach((key, _) {
      if (activityLevel.containsKey(key)) {
        result[key] = activityLevel[key]!;
      } else {
        // Handle new keys from API dynamically
        final String formattedKey = key
            .replaceAll('_', ' ')
            .capitalizeFirstLetter();
        result[key] = formattedKey;
      }
    });

    return result;
  }

  static Map<String, String> getAvailableFitnessGoals() {
    if (fitnessGoalValue == null) {
      return fitnessGoal;
    }

    final Map<String, String> result = {};
    fitnessGoalValue!.forEach((key, _) {
      if (fitnessGoal.containsKey(key)) {
        result[key] = fitnessGoal[key]!;
      } else {
        // Handle new keys from API dynamically
        final String formattedKey = key
            .replaceAll('_', ' ')
            .capitalizeFirstLetter();
        result[key] = formattedKey;
      }
    });

    return result;
  }

  static List<String> getAvailableMealTypes() {
    if (mealTypeValue == null) {
      return mealType.values.toList();
    }
    return mealType.entries
        .where((entry) => mealTypeValue!.contains(entry.key))
        .map((entry) => entry.value)
        .toList();
  }

  static Map<String, String> getAvailableMealEntries() {
    if (mealTypeValue == null) return mealType;
    return Map.fromEntries(
      mealType.entries.where((entry) => mealTypeValue!.contains(entry.key)),
    );
  }

  static void updateFromResponse(MacroNutrientResponse response) {
    activityLevelValue = response.activityLevel;
    fitnessGoalValue = response.fitnessGoal;
    macroRatioValue = response.macroRatio;
    mealTypeValue = response.mealType;
  }

  static Future<void> fetchMacroNutrientData() async {
    try {
      final MacroNutrientResponse response = await getMacroNutrientApi();
      updateFromResponse(response);
    } on Exception catch (e) {
      log("Error fetching macro nutrient data: $e");
    }
  }
}
