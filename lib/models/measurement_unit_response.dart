class MeasurementUnitResponse {
  List<MeasurementUnit>? data;

  MeasurementUnitResponse({this.data});

  MeasurementUnitResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MeasurementUnit>[];
      json['data'].forEach((v) {
        data!.add(MeasurementUnit.fromJson(v));
      });
    }
  }
}

class MeasurementUnit {
  int? id;
  String? title;
  String? symbol;
  String? slug;

  MeasurementUnit({this.id, this.title, this.symbol, this.slug});

  MeasurementUnit.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    title = json['title'];
    symbol = json['symbol'];
    slug = json['slug'];
  }
}
