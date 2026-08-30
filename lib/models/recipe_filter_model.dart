class RecipeFilterModel {
  int? startCalories;
  int? endCalories;
  int? startProtein;
  int? endProtein;
  int? startCarbs;
  int? endCarbs;
  int? startFats;
  int? endFats;
  int? minPreparationTime;
  int? maxPreparationTime;
  List<int>? recipeCategoryIds;
  List<int>? recipeTagIds;
  List<String>? mealTypes;
  int? isFavourite;


  RecipeFilterModel({
    this.startCalories,
    this.endCalories,
    this.startProtein,
    this.endProtein,
    this.startCarbs,
    this.endCarbs,
    this.startFats,
    this.endFats,
    this.minPreparationTime,
    this.maxPreparationTime,
    this.recipeCategoryIds,
    this.recipeTagIds,
    this.mealTypes,
    this.isFavourite,

  });

  void clear() {
    startCalories = null;
    endCalories = null;
    startProtein = null;
    endProtein = null;
    startCarbs = null;
    endCarbs = null;
    startFats = null;
    endFats = null;
    minPreparationTime = null;
    maxPreparationTime = null;
    recipeCategoryIds = null;
    recipeTagIds = null;
    mealTypes = null;
    isFavourite = null;

  }

  bool get isAnyFilterApplied =>
      startCalories != null ||
      endCalories != null ||
      startProtein != null ||
      endProtein != null ||
      startCarbs != null ||
      endCarbs != null ||
      startFats != null ||
      endFats != null ||
      minPreparationTime != null ||
      maxPreparationTime != null ||
      (recipeCategoryIds?.isNotEmpty ?? false) ||
      (recipeTagIds?.isNotEmpty ?? false) ||
      isFavourite != null ||
      (mealTypes?.isNotEmpty ?? false);

}
