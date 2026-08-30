import '../utils/shared_import.dart';

class WaterResponseModel {
  final Pagination pagination;
  final List<WaterRecord>? data;

  WaterResponseModel({required this.pagination, required this.data});

  factory WaterResponseModel.fromJson(Map<String, dynamic> json) =>
      WaterResponseModel(
        pagination: Pagination.fromJson(json['pagination']),
          data: json['data'] != null
              ? (json['data'] as List)
                  .map((e) => WaterRecord.fromJson(e))
                  .toList()
            : null,
      );
}

class WaterRecord {
  final int id;
  final int value;
  final String date;
  final String time;
  final String createdAt;
  final String updatedAt;

  WaterRecord({
    required this.id,
    required this.value,
    required this.date,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WaterRecord.fromJson(Map<String, dynamic> json) => WaterRecord(
    id: json['id'] ?? 0,
    value: json['value'] ?? 0,
    date: json['date'] ?? '',
    time: json['time'] ?? '',
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
  );
}

class WaterGraph {
  List<WaterGraphData>? data;

  WaterGraph({this.data});

  WaterGraph.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WaterGraphData>[];
      json['data'].forEach((dynamic v) {
        data!.add(WaterGraphData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WaterGraphData {
  int? todayGoal;
  int? value;
  String? date;

  WaterGraphData({this.todayGoal, this.value, this.date});

  WaterGraphData.fromJson(Map<String, dynamic> json) {
    todayGoal = json['today_goal'];
    value = json['value'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['today_goal'] = todayGoal;
    data['value'] = value;
    data['date'] = date;
    return data;
  }
}
