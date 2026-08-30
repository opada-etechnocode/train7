class FitnessBaseResponse {
  String? message;

  FitnessBaseResponse({this.message});

  FitnessBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}

class FitnessErrorBaseResponse {
  String? message;
  String? error;

  FitnessErrorBaseResponse({this.message, this.error});

  FitnessErrorBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    return data;
  }
}
