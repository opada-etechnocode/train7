import '../utils/shared_import.dart';

class BookmarkPostModel {
  Pagination? pagination;
  List<BookmarkData>? data;

  BookmarkPostModel({this.pagination, this.data});

  BookmarkPostModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <BookmarkData>[];
      json['data'].forEach((dynamic v) {
        data!.add(BookmarkData.fromJson(v));
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

class BookmarkData {
  int? id;
  int? userId;
  int? postingId;
  String? displayName;
  PostData? posts;
  String? username;
  String? profileImage;
  Users? users;

  BookmarkData({
    this.id,
    this.userId,
    this.postingId,
    this.displayName,
    this.posts,
    this.username,
    this.users,
    this.profileImage,
  });

  BookmarkData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postingId = json['posting_id'];
    displayName = json['display_name'];
    posts = json['posts'] != null ? PostData.fromJson(json['posts']) : null;
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
    username = json['username'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['posting_id'] = postingId;
    data['display_name'] = displayName;
    if (posts != null) {
      data['posts'] = posts!.toJson();
    }
    if (users != null) {
      data['users'] = users!.toJson();
    }
    data['username'] = username;
    data['profile_image'] = profileImage;
    return data;
  }
}
