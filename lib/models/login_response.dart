import '../utils/shared_import.dart';

class LoginResponse {
  UserModel? data;

  LoginResponse({this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserModel {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? emailVerifiedAt;
  String? userType;
  String? status;
  String? loginType;
  String? gender;
  String? displayName;
  String? playerId;
  int? isSubscribe;
  String? createdAt;
  String? updatedAt;
  String? apiToken;
  String? profileImage;

  String? uid;
  List<String>? caseSearch;
  bool? isPresence;
  int? lastSeen;
  List<DocumentReference>? blockedTo;
  Timestamp? firebaseCreatedAt;
  Timestamp? firebaseUpdatedAt;
  String? pin;

  UserModel({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.emailVerifiedAt,
    this.userType,
    this.status,
    this.loginType,
    this.gender,
    this.displayName,
    this.playerId,
    this.isSubscribe,
    this.createdAt,
    this.updatedAt,
    this.apiToken,
    this.profileImage,
    this.uid,
    this.caseSearch,
    this.isPresence,
    this.lastSeen,
    this.blockedTo,
    this.firebaseCreatedAt,
    this.firebaseUpdatedAt,
    this.pin,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    emailVerifiedAt = json['email_verified_at'];
    userType = json['user_type'];
    status = json['status'];
    loginType = json['login_type'];
    gender = json['gender'];
    displayName = json['display_name'];
    playerId = json['player_id'];
    isSubscribe = json['is_subscribe'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    apiToken = json['api_token'];
    profileImage = json['profile_image'];

    uid = json['uid'];
    caseSearch = json['case_search'] != null
        ? List<String>.from(json['case_search'])
        : [];
    isPresence = json['is_present'];
    lastSeen = json['last_seen'];
    blockedTo = json['blocked_to'] != null
        ? List<DocumentReference>.from(json['blocked_to'])
        : [];
    firebaseCreatedAt = json['firebase_created_at'];
    pin = json["pin"];
    firebaseUpdatedAt = json["firebase_updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['email_verified_at'] = emailVerifiedAt;
    data['user_type'] = userType;
    data['status'] = status;
    data['login_type'] = loginType;
    data['gender'] = gender;
    data['display_name'] = displayName;
    data['player_id'] = playerId;
    data['is_subscribe'] = isSubscribe;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['api_token'] = apiToken;
    data['profile_image'] = profileImage;

    data['uid'] = uid;
    data['case_search'] = caseSearch;
    data['is_present'] = isPresence;
    data['last_seen'] = lastSeen;
    data['blocked_to'] = blockedTo;
    data['firebase_created_at'] = firebaseCreatedAt;
    data['firebase_updated_at'] = firebaseUpdatedAt;
    data['pin'] = pin;
    return data;
  }
}
