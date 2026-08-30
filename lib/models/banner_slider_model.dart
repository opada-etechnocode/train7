class BannerSliderModel {
  int? id;
  String? title;
  String? slug;
  String? type;
  int? workoutId;
  String? url;
  String? bannersliderImage;
  String? createdAt;
  String? updatedAt;

  BannerSliderModel({
    this.id,
    this.title,
    this.slug,
    this.type,
    this.workoutId,
    this.url,
    this.bannersliderImage,
    this.createdAt,
    this.updatedAt,
  });

  BannerSliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    type = json['type'];
    workoutId = json['workout_id'];
    url = json['url'];
    bannersliderImage = json['bannerslider_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['type'] = type;
    data['workout_id'] = workoutId;
    data['url'] = url;
    data['bannerslider_image'] = bannersliderImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
