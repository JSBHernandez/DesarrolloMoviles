import 'dart:convert';
import 'package:parcial/models/item.dart';

ItemsResponseModel itemsResponseJson(String str) =>
    ItemsResponseModel.fromJson(json.decode(str));

class ItemsResponseModel {
  ItemsResponseModel({
    required this.message,
    required this.data,
  });

  late final String message;
  late final DataResponse? data;

  ItemsResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? DataResponse.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data!.toJson();
    return _data;
  }
}

class DataResponse {
  DataResponse({
    required this.items,
  });

  late final List<Item> items;

  DataResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonItems = json['items'];
    items = jsonItems.map((item) => Item.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['items'] = items.map((item) => item.toJson()).toList();
    return _data;
  }
}

