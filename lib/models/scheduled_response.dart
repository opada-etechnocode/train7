import '../utils/shared_import.dart';

class ScheduledResponse {
  Pagination? pagination;
  List<ScheduledModelData>? data;

  ScheduledResponse({this.pagination, this.data});

  ScheduledResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ScheduledModelData>[];
      json['data'].forEach((dynamic v) {
        data!.add(ScheduledModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScheduledModelData {
  int? id;
  String? className;
  int? workoutId;
  String? workout;
  String? workoutTitle;
  String? workoutType;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? name;
  String? link;
  String? isPaid;
  int? price;
  int? isClassSchedulePlan;
  String? createdAt;
  String? updatedAt;

  ScheduledModelData({
    this.id,
    this.className,
    this.workoutId,
    this.workout,
    this.workoutTitle,
    this.workoutType,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.name,
    this.link,
    this.isPaid,
    this.price,
    this.isClassSchedulePlan,
    this.createdAt,
    this.updatedAt,
  });

  ScheduledModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    className = json['class_name'];
    workoutId = json['workout_id'];
    workout = json['workout'];
    workoutTitle = json['workout_title'];
    workoutType = json['workout_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    name = json['name'];
    link = json['link'];
    isPaid = json['is_paid'];
    price = json['price'];
    isClassSchedulePlan = json['is_class_schedule_plan'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['class_name'] = className;
    data['workout_id'] = workoutId;
    data['workout'] = workout;
    data['workout_title'] = workoutTitle;
    data['workout_type'] = workoutType;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['name'] = name;
    data['link'] = link;
    data['is_paid'] = isPaid;
    data['price'] = price;
    data['is_class_schedule_plan'] = isClassSchedulePlan;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
