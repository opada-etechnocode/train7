import '../utils/shared_import.dart';

class BlogDetailResponse {
  BlogModel? data;

  BlogDetailResponse({this.data});

  BlogDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? BlogModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
