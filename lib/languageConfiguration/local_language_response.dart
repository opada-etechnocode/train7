import '../../utils/shared_import.dart';

class LocalLanguageResponse {
  String? screenID;
  String? screenName;
  List<ContentData>? keywordData;

  LocalLanguageResponse({this.screenID, this.screenName, this.keywordData});

  LocalLanguageResponse.fromJson(Map<String, dynamic> json) {
    screenID = json['screenID'];
    screenName = json['ScreenName'];
    if (json['keyword_data'] != null) {
      keywordData = <ContentData>[];
      json['keyword_data'].forEach((dynamic v) {
        keywordData!.add(ContentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['screenID'] = screenID;
    data['ScreenName'] = screenName;
    if (keywordData != null) {
      data['keyword_data'] = keywordData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
