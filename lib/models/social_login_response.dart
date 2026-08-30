class SocialLoginResponse {
  bool? status;
  bool? isUserExist;
  String? message;
  Data? data;

  SocialLoginResponse({this.status, this.message, this.data, this.isUserExist});

  SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isUserExist = json['is_user_exist'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['is_user_exist'] = isUserExist;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? userType;
  String? status;
  String? loginType;
  String? gender;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? apiToken;
  String? profileImage;

  Data({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.userType,
    this.status,
    this.loginType,
    this.gender,
    this.displayName,
    this.createdAt,
    this.updatedAt,
    this.apiToken,
    this.profileImage,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    userType = json['user_type'];
    status = json['status'];
    loginType = json['login_type'];
    gender = json['gender'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    apiToken = json['api_token'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['user_type'] = userType;
    data['status'] = status;
    data['login_type'] = loginType;
    data['gender'] = gender;
    data['display_name'] = displayName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['api_token'] = apiToken;
    data['profile_image'] = profileImage;
    return data;
  }
}
