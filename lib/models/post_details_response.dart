import '../utils/shared_import.dart';

class PostList {
  Pagination? pagination;
  List<PostData>? data;

  PostList({this.pagination, this.data});

  PostList.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <PostData>[];
      json['data'].forEach((dynamic v) {
        data!.add(PostData.fromJson(v));
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

class PostData {
  int? id;
  String? description;
  String? status;
  int? userId;
  List<PostingMediaArray>? postingMediaArray;
  Users? users;
  int? postingLikeCount;
  int? postingCommentCount;
  bool? canEdit;
  bool? isLiked;
  bool? isBookmark;
  String? createdAt;

  PostData({
    this.id,
    this.description,
    this.status,
    this.userId,
    this.postingMediaArray,
    this.users,
    this.postingLikeCount,
    this.postingCommentCount,
    this.canEdit,
    this.isLiked,
    this.isBookmark,
    this.createdAt,
  });

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    status = json['status'];
    userId = json['user_id'];
    if (json['posting_media_array'] != null) {
      postingMediaArray = <PostingMediaArray>[];
      json['posting_media_array'].forEach((dynamic v) {
        postingMediaArray!.add(PostingMediaArray.fromJson(v));
      });
    }
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
    postingLikeCount = json['posting_like_count'];
    postingCommentCount = json['posting_comment_count'];
    canEdit = json['can_edit'];
    isLiked = json['is_liked'];
    isBookmark = json['is_bookmark'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['status'] = status;
    data['user_id'] = userId;
    if (postingMediaArray != null) {
      data['posting_media_array'] = postingMediaArray!
          .map((v) => v.toJson())
          .toList();
    }
    if (users != null) {
      data['users'] = users!.toJson();
    }
    data['posting_like_count'] = postingLikeCount;
    data['posting_comment_count'] = postingCommentCount;
    data['can_edit'] = canEdit;
    data['is_liked'] = isLiked;
    data['is_bookmark'] = isBookmark;
    data['created_at'] = createdAt;
    return data;
  }
}

class PostingMediaArray {
  int? id;
  String? url;
  String? mimeType;

  PostingMediaArray({this.id, this.url, this.mimeType});

  PostingMediaArray.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    mimeType = json['mime_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['mime_type'] = mimeType;
    return data;
  }
}

class Users {
  int? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? email;
  String? username;
  String? phoneNumber;
  String? profileImage;

  Users({
    this.id,
    this.firstName,
    this.lastName,
    this.displayName,
    this.email,
    this.username,
    this.phoneNumber,
    this.profileImage,
  });

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    email = json['email'];
    username = json['username'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['display_name'] = displayName;
    data['email'] = email;
    data['username'] = username;
    data['phone_number'] = phoneNumber;
    data['profile_image'] = profileImage;
    return data;
  }
}
