import '../utils/shared_import.dart';

class SubscriptionPlanResponse {
  Pagination? pagination;
  List<SubscriptionPlan>? data;

  SubscriptionPlanResponse({this.pagination, this.data});

  SubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <SubscriptionPlan>[];
      json['data'].forEach((dynamic v) {
        data!.add(SubscriptionPlan.fromJson(v));
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

class SubscriptionPlan {
  int? id;
  int? userId;
  String? userName;
  int? programId;
  String? programName;
  num? totalAmount;
  String? paymentType;
  String? txnId;
  TransactionDetail? transactionDetail;
  String? paymentStatus;
  String? status;
  bool? isFollowUp;
  ProgramData? programData;
  int? foodRecognitionLimit;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  String? createdAt;
  String? updatedAt;

  SubscriptionPlan({
    this.id,
    this.userId,
    this.userName,
    this.programId,
    this.programName,
    this.totalAmount,
    this.paymentType,
    this.txnId,
    this.transactionDetail,
    this.paymentStatus,
    this.status,
    this.isFollowUp,
    this.programData,
    this.foodRecognitionLimit,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.createdAt,
    this.updatedAt,
  });

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    programId = json['package_id'];
    programName = json['package_name'];
    totalAmount = json['total_amount'];
    paymentType = json['payment_type'];
    txnId = json['txn_id'];
    transactionDetail = json['transaction_detail'] != null
        ? TransactionDetail.fromJson(json['transaction_detail'])
        : null;
    paymentStatus = json['payment_status'];
    status = json['status'];
    isFollowUp = json['is_follow_up'];
    programData = json['package_data'] != null
        ? ProgramData.fromJson(json['package_data'])
        : null;
    foodRecognitionLimit = json['food_recognition_limit'];
    subscriptionStartDate = json['subscription_start_date'];
    subscriptionEndDate = json['subscription_end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['package_id'] = programId;
    data['package_name'] = programName;
    data['total_amount'] = totalAmount;
    data['payment_type'] = paymentType;
    data['txn_id'] = txnId;
    if (transactionDetail != null) {
      data['transaction_detail'] = transactionDetail!.toJson();
    }
    data['payment_status'] = paymentStatus;
    data['status'] = status;
    data['is_follow_up'] = isFollowUp;
    if (programData != null) {
      data['package_data'] = programData!.toJson();
    }
    data['food_recognition_limit'] = foodRecognitionLimit;
    data['subscription_start_date'] = subscriptionStartDate;
    data['subscription_end_date'] = subscriptionEndDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ProgramData {
  int? id;
  String? name;
  num? price;
  String? status;
  int? duration;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? durationUnit;
  int? foodRecognitionLimit;
  num? followUpPrice;

  ProgramData({
    this.id,
    this.name,
    this.price,
    this.status,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.durationUnit,
    this.foodRecognitionLimit,
    this.followUpPrice,
  });

  ProgramData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    duration = json['duration'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    durationUnit = json['duration_unit'];
    foodRecognitionLimit = json['food_recognition_limit'];
    followUpPrice = json['follow_up_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['status'] = status;
    data['duration'] = duration;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['description'] = description;
    data['duration_unit'] = durationUnit;
    data['food_recognition_limit'] = foodRecognitionLimit;
    data['follow_up_price'] = followUpPrice;
    return data;
  }
}

class TransactionDetail {
  String? name;
  int? addedBy;

  TransactionDetail({this.name, this.addedBy});

  TransactionDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    addedBy = json['added_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['added_by'] = addedBy;
    return data;
  }
}
