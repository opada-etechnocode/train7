class GetSettingResponse {
  List<SettingList>? data;
  CurrencySetting? currencySetting;

  GetSettingResponse({this.data, this.currencySetting});

  GetSettingResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SettingList>[];
      json['data'].forEach((dynamic v) {
        data!.add(SettingList.fromJson(v));
      });
    }
    currencySetting = json['currency_setting'] != null
        ? CurrencySetting.fromJson(json['currency_setting'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (currencySetting != null) {
      data['currency_setting'] = currencySetting!.toJson();
    }
    return data;
  }
}

class SettingList {
  int? id;
  String? key;
  String? type;
  String? value;

  SettingList({this.id, this.key, this.type, this.value});

  SettingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}

class CurrencySetting {
  String? name;
  String? symbol;
  String? code;
  String? position;

  CurrencySetting({this.name, this.symbol, this.code, this.position});

  CurrencySetting.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    symbol = json['symbol'];
    code = json['code'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['symbol'] = symbol;
    data['code'] = code;
    data['position'] = position;
    return data;
  }
}
