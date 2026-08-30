import '../utils/shared_import.dart';

class UserResponse {
  UserData? data;
  SubscriptionDetail? subscriptionDetail;

  UserResponse({this.data, this.subscriptionDetail});

  UserResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    subscriptionDetail = json['subscription_detail'] != null
        ? SubscriptionDetail.fromJson(json['subscription_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (subscriptionDetail != null) {
      data['subscription_detail'] = subscriptionDetail!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? email;
  String? username;
  String? gender;
  String? status;
  String? userType;
  String? phoneNumber;
  String? playerId;
  String? profileImage;
  String? loginType;
  String? createdAt;
  String? updatedAt;
  UserProfile? userProfile;
  int? isSubscribe;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.displayName,
    this.email,
    this.username,
    this.gender,
    this.status,
    this.userType,
    this.phoneNumber,
    this.playerId,
    this.profileImage,
    this.loginType,
    this.createdAt,
    this.updatedAt,
    this.userProfile,
    this.isSubscribe,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    email = json['email'];
    username = json['username'];
    gender = json['gender'];
    status = json['status'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    playerId = json['player_id'];
    profileImage = json['profile_image'];
    loginType = json['login_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userProfile = json['user_profile'] != null
        ? UserProfile.fromJson(json['user_profile'])
        : null;
    isSubscribe = json['is_subscribe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['display_name'] = displayName;
    data['email'] = email;
    data['username'] = username;
    data['gender'] = gender;
    data['status'] = status;
    data['user_type'] = userType;
    data['phone_number'] = phoneNumber;
    data['player_id'] = playerId;
    data['profile_image'] = profileImage;
    data['login_type'] = loginType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (userProfile != null) {
      data['user_profile'] = userProfile!.toJson();
    }
    data['is_subscribe'] = isSubscribe;
    return data;
  }
}

class UserProfile {
  int? id;
  String? age;
  String? weight;
  String? weightUnit;
  String? height;
  String? heightUnit;
  String? address;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? activity;
  String? goal;
  String? macroType;
  int? carbs;
  int? protein;
  int? fat;
  WaterReminderSettings? waterReminderSettings;
  MealReminderSettings? mealReminderSettings;

  UserProfile({
    this.id,
    this.age,
    this.weight,
    this.weightUnit,
    this.height,
    this.heightUnit,
    this.address,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.activity,
    this.goal,
    this.macroType,
    this.carbs,
    this.protein,
    this.fat,
    this.waterReminderSettings,
    this.mealReminderSettings,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    age = json['age'];
    weight = json['weight'];
    weightUnit = json['weight_unit'];
    height = json['height'];
    heightUnit = json['height_unit'];
    address = json['address'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    activity = json['activity'];
    goal = json['goal'];
    macroType = json['macro_type'];
    carbs = json['carbs_pct'];
    protein = json['protein_pct'];
    fat = json['fat_pct'];
    waterReminderSettings = json['water_reminder_settings'] != null
        ? WaterReminderSettings.fromJson(json['water_reminder_settings'])
        : null;
    mealReminderSettings = json['meal_reminder_settings'] != null
        ? MealReminderSettings.fromJson(json['meal_reminder_settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['age'] = age;
    data['weight'] = weight;
    data['weight_unit'] = weightUnit;
    data['height'] = height;
    data['height_unit'] = heightUnit;
    data['address'] = address;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['activity'] = activity;
    data['goal'] = goal;
    data['macro_type'] = macroType;
    data['carbs_pct'] = carbs;
    data['protein_pct'] = protein;
    data['fat_pct'] = fat;
    if (waterReminderSettings != null) {
      data['water_reminder_settings'] = waterReminderSettings!.toJson();
    }
    if (mealReminderSettings != null) {
      data['meal_reminder_settings'] = mealReminderSettings!.toJson();
    }
    return data;
  }
}

class WaterReminderSettings {
  bool? enabled;
  String? start;
  String? end;
  int? interval;

  /// When interval is 24 hours, single daily time (e.g. "09:00"). API may return as at_time.
  String? atTime;

  WaterReminderSettings({
    this.enabled,
    this.start,
    this.end,
    this.interval,
    this.atTime,
  });

  WaterReminderSettings.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    start = json['start'];
    end = json['end'];
    interval = json['interval'];
    atTime = json['at_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enabled'] = enabled;
    data['start'] = start;
    data['end'] = end;
    data['interval'] = interval;
    if (atTime != null) {
      data['at_time'] = atTime;
    }
    return data;
  }
}

class MealReminderSettings {
  MealSetting? breakfast;
  MealSetting? lunch;
  MealSetting? snacks;
  MealSetting? dinner;

  MealReminderSettings({this.breakfast, this.lunch, this.snacks, this.dinner});

  MealReminderSettings.fromJson(Map<String, dynamic> json) {
    breakfast = json['breakfast'] != null
        ? MealSetting.fromJson(json['breakfast'])
        : null;
    lunch = json['lunch'] != null ? MealSetting.fromJson(json['lunch']) : null;
    snacks = json['snacks'] != null
        ? MealSetting.fromJson(json['snacks'])
        : null;
    dinner = json['dinner'] != null
        ? MealSetting.fromJson(json['dinner'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (breakfast != null) {
      data['breakfast'] = breakfast!.toJson();
    }
    if (lunch != null) {
      data['lunch'] = lunch!.toJson();
    }
    if (snacks != null) {
      data['snacks'] = snacks!.toJson();
    }
    if (dinner != null) {
      data['dinner'] = dinner!.toJson();
    }
    return data;
  }
}

class MealSetting {
  bool? enabled;
  String? time;

  MealSetting({this.enabled, this.time});

  MealSetting.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enabled'] = enabled;
    data['time'] = time;
    return data;
  }
}

class SubscriptionDetail {
  int? isSubscribe;
  SubscriptionPlan? subscriptionPlan;

  SubscriptionDetail({this.isSubscribe, this.subscriptionPlan});

  SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    isSubscribe = json['is_subscribe'];
    subscriptionPlan = json['subscription_plan'] != null
        ? SubscriptionPlan.fromJson(json['subscription_plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_subscribe'] = isSubscribe;
    if (subscriptionPlan != null) {
      data['subscription_plan'] = subscriptionPlan!.toJson();
    }
    return data;
  }
}
