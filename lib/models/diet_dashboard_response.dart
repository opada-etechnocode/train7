import '../utils/shared_import.dart';

class DietDashboardResponse {
  List<CategoryDietModel>? categoryDiet;
  List<DietModel>? bestDiet;
  List<DietModel>? diet;
  List<DietModel>? assignDiet;

  DietDashboardResponse({
    this.categoryDiet,
    this.bestDiet,
    this.diet,
    this.assignDiet,
  });

  DietDashboardResponse.fromJson(Map<String, dynamic> json) {
    if (json['category_diet'] != null) {
      categoryDiet = <CategoryDietModel>[];
      json['category_diet'].forEach((dynamic v) {
        categoryDiet!.add(CategoryDietModel.fromJson(v));
      });
    }
    if (json['best_diet'] != null) {
      bestDiet = <DietModel>[];
      json['best_diet'].forEach((dynamic v) {
        bestDiet!.add(DietModel.fromJson(v));
      });
    }
    if (json['diet'] != null) {
      diet = <DietModel>[];
      json['diet'].forEach((dynamic v) {
        diet!.add(DietModel.fromJson(v));
      });
    }
    if (json['assign_diet'] != null) {
      assignDiet = <DietModel>[];
      json['assign_diet'].forEach((dynamic v) {
        assignDiet!.add(DietModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categoryDiet != null) {
      data['category_diet'] = categoryDiet!.map((dynamic v) => v.toJson()).toList();
    }
    if (bestDiet != null) {
      data['best_diet'] = bestDiet!.map((dynamic v) => v.toJson()).toList();
    }
    if (diet != null) {
      data['diet'] = diet!.map((dynamic v) => v.toJson()).toList();
    }
    if (assignDiet != null) {
      data['assign_diet'] = assignDiet!.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}
