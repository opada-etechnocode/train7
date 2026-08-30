class NotificationResponse {
  List<NotificationData>? notificationData;
  int? allUnreadCount;

  NotificationResponse({this.notificationData, this.allUnreadCount});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    if (json['notification_data'] != null) {
      notificationData = <NotificationData>[];
      json['notification_data'].forEach((dynamic v) {
        notificationData!.add(NotificationData.fromJson(v));
      });
    }
    allUnreadCount = json['all_unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notificationData != null) {
      data['notification_data'] = notificationData!
          .map((v) => v.toJson())
          .toList();
    }
    data['all_unread_count'] = allUnreadCount;
    return data;
  }
}

class NotificationData {
  String? id;
  String? readAt;
  String? createdAt;
  NotificationModelData? data;
  String? image;
  bool select = false;

  NotificationData({
    this.id,
    this.readAt,
    this.createdAt,
    this.data,
    this.image,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    data = json['data'] != null
        ? NotificationModelData.fromJson(json['data'])
        : null;
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['image'] = image;
    return data;
  }
}

class NotificationModelData {
  int? id;
  int? pushNotificationId;
  String? type;
  String? subject;
  String? message;
  String? image;

  NotificationModelData({
    this.id,
    this.pushNotificationId,
    this.type,
    this.subject,
    this.message,
    this.image,
  });

  NotificationModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pushNotificationId = json['push_notification_id'];
    type = json['type'];
    subject = json['subject'];
    message = json['message'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['push_notification_id'] = pushNotificationId;
    data['type'] = type;
    data['subject'] = subject;
    data['message'] = message;
    data['image'] = image;
    return data;
  }
}
