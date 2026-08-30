import '../utils/shared_import.dart';

class CommentListResponse {
  Pagination? pagination;
  List<CommentData>? data;

  CommentListResponse({this.pagination, this.data});

  CommentListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <CommentData>[];
      json['data'].forEach((dynamic v) {
        data!.add(CommentData.fromJson(v));
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

class CommentData {
  int? id;
  String? comment;
  int? postingId;
  int? userId;
  Users? users;
  bool? canEdit;
  String? createdAt;
  int? commentReplyCount;
  List<CommentReply>? commentReply;

  CommentData({
    this.id,
    this.comment,
    this.postingId,
    this.userId,
    this.users,
    this.canEdit,
    this.createdAt,
    this.commentReplyCount,
    this.commentReply,
  });

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    postingId = json['posting_id'];
    userId = json['user_id'];
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
    canEdit = json['can_edit'];
    createdAt = json['created_at'];
    commentReplyCount = json['comment_reply_count'];
    if (json['comment_reply'] != null) {
      commentReply = <CommentReply>[];
      json['comment_reply'].forEach((dynamic v) {
        commentReply!.add(CommentReply.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['posting_id'] = postingId;
    data['user_id'] = userId;
    if (users != null) {
      data['users'] = users!.toJson();
    }
    data['can_edit'] = canEdit;
    data['created_at'] = createdAt;
    data['comment_reply_count'] = commentReplyCount;
    if (commentReply != null) {
      data['comment_reply'] = commentReply!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentReply {
  int? id;
  String? comment;
  int? userId;
  int? commentId;
  Users? users;
  bool? canEdit;
  String? createdAt;

  CommentReply({
    this.id,
    this.comment,
    this.userId,
    this.commentId,
    this.users,
    this.canEdit,
    this.createdAt,
  });

  CommentReply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userId = json['user_id'];
    commentId = json['comment_id'];
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
    canEdit = json['can_edit'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['user_id'] = userId;
    data['comment_id'] = commentId;
    if (users != null) {
      data['users'] = users!.toJson();
    }
    data['can_edit'] = canEdit;
    data['created_at'] = createdAt;
    return data;
  }
}
