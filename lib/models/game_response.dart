import '../utils/shared_import.dart';

class GameResponse {
  Pagination? pagination;
  List<GameResponseData>? data;

  GameResponse({this.pagination, this.data});

  GameResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <GameResponseData>[];
      json['data'].forEach((dynamic v) {
        data!.add(GameResponseData.fromJson(v));
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

class GameResponseData {
  int? userId;
  String? userName;
  int? score;
  String? countryCode;
  String? flagUrl;

  GameResponseData({
    this.userId,
    this.userName,
    this.score,
    this.countryCode,
    this.flagUrl,
  });

  GameResponseData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    score = json['score'];
    countryCode = json['country_code'];
    flagUrl = json['flag_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['score'] = score;
    data['country_code'] = countryCode;
    data['flag_url'] = flagUrl;
    return data;
  }
}
