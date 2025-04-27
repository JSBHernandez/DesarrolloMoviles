import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:becerrahernandez_quiz3/config.dart';
import 'package:becerrahernandez_quiz3/models/items_model.dart';
import 'package:becerrahernandez_quiz3/models/login_req_model.dart';

class APIService {
  static const _storage = FlutterSecureStorage();
  static var client = http.Client();

  static Future<Map<String, dynamic>> login(LoginReqModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var uri = Uri.http(Config.apiURL, Config.loginURL);

    var response = await client.post(
      uri,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      print('Login Valido');
      print(response.body.toString());
      final data = jsonDecode(response.body);

      return {'success': true, 'token': data['token']};
    } else {
      return {'success': false, 'message': 'Usuario o Contraseña inválidos'};
    }
  }

  static Future<bool> validateToken(String token) async {
    Map<String, String> requestHeaders = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    var uri = Uri.http(Config.apiURL, Config.validateURL);

    var response = await client.post(uri, headers: requestHeaders);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> saveLogin(LoginReqModel model, String token) async {
    Map<String, String> requestHeaders = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    var uri = Uri.http(Config.apiURL, Config.saveBiometricURL);

    var response = await client.post(
      uri,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      print('Login Valido');
      print(response.body.toString());

      String token = jsonDecode(response.body)['token'];
      await _storage.write(key: 'token', value: token);

      return true;
    } else {
      return false;
    }
  }

  static Future<Map<String, dynamic>> loginBiom(String token) async {
    Map<String, String> requestHeaders = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    var uri = Uri.http(Config.apiURL, Config.loginBiomURL);

    var response = await client.post(uri, headers: requestHeaders);

    if (response.statusCode == 200) {
      print('Login Valido');
      print(response.body.toString());
      final data = jsonDecode(response.body);

      return {'success': true, 'token': data['token']};
    } else {
      return {'success': false, 'message': 'Usuario o Contraseña inválidos'};
    }
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  static Future<List<ItemsModel>> getItems(String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var uri = Uri.http(Config.apiURL, Config.itemsURL);

    try {
      var response = await client
          .post(uri, headers: requestHeaders)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<ItemsModel> items =
            jsonList.map((item) => ItemsModel.fromJson(item)).toList();
        return items;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return [];
      } else {
        return [
          ItemsModel(
            articulo: 'n/a',
            descripcion: 'n/a',
            calificaciones: 0,
            valoracion: 0,
            urlimagen: 'https://via.placeholder.com/150',
            precio: 0,
            descuento: '0',
          ),
        ];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<List<ItemsModel>> getOnSaleItems(String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var uri = Uri.http(Config.apiURL, Config.itemsURL);

    try {
      var response = await client
          .post(uri, headers: requestHeaders)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<ItemsModel> items =
            jsonList.map((item) => ItemsModel.fromJson(item)).toList();
        List<ItemsModel> onSaleItems =
            items.where((item) => int.parse(item.descuento) > 0).toList();
        return onSaleItems;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return [];
      } else {
        return [
          ItemsModel(
            articulo: 'n/a',
            descripcion: 'n/a',
            calificaciones: 0,
            valoracion: 0,
            urlimagen: 'https://via.placeholder.com/150',
            precio: 0,
            descuento: '0',
          ),
        ];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
