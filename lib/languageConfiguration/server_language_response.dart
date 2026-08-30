class ServerLanguageResponse {
  bool? status;
  int? currentVersionNo;
  List<LanguageJsonData>? data;

  ServerLanguageResponse({this.status, this.data, this.currentVersionNo});

  ServerLanguageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    currentVersionNo = json['version_code'];
    if (json['data'] != null) {
      data = <LanguageJsonData>[];
      json['data'].forEach((dynamic v) {
        data!.add(LanguageJsonData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['version_code'] = currentVersionNo;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LanguageJsonData {
  int? id;
  String? languageName;
  String? languageCode;
  String? countryCode;
  String? languageImage;
  int? isRtl;
  int? isDefaultLanguage;
  List<ContentData>? contentData;
  String? createdAt;
  String? updatedAt;

  LanguageJsonData({
    this.id,
    this.languageName,
    this.isRtl,
    this.contentData,
    this.isDefaultLanguage,
    this.createdAt,
    this.updatedAt,
    this.languageCode,
    this.countryCode,
    this.languageImage,
  });

  LanguageJsonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageName = json['language_name'];
    isDefaultLanguage = json['id_default_language'];
    languageCode = json['language_code'] ?? "en";
    countryCode = json['country_code'];
    isRtl = json['is_rtl'];
    if (json['contentdata'] != null) {
      contentData = <ContentData>[];
      json['contentdata'].forEach((dynamic v) {
        contentData!.add(ContentData.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    languageImage = json['language_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['language_name'] = languageName;
    data['country_code'] = countryCode;
    data['language_code'] = languageCode;
    data['id_default_language'] = isDefaultLanguage;
    data['is_rtl'] = isRtl;
    if (contentData != null) {
      data['contentdata'] = contentData!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['language_image'] = languageImage;
    return data;
  }
}

class ContentData {
  int? keywordId;
  String? screenName;
  String? keywordName;
  String? keywordValue;

  ContentData({
    this.keywordId,
    this.screenName,
    this.keywordName,
    this.keywordValue,
  });

  ContentData.fromJson(Map<String, dynamic> json) {
    keywordId = json['keyword_id'];
    screenName = json['screen_name'];
    keywordName = json['keyword_name'];
    keywordValue = json['keyword_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keyword_id'] = keywordId;
    data['screen_name'] = screenName;
    data['keyword_name'] = keywordName;
    data['keyword_value'] = keywordValue;
    return data;
  }
}
