import '../utils/shared_import.dart';

class ShoppingListGenerateResponse {
  String? message;
  ShoppingListData? data;

  ShoppingListGenerateResponse({this.message, this.data});

  ShoppingListGenerateResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? ShoppingListData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
