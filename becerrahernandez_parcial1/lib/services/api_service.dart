import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parcial/config.dart';
import 'package:parcial/models/item.dart';
import 'package:parcial/models/items_request_model.dart';
import 'package:parcial/models/items_response_model.dart';
import 'package:parcial/models/login_request_model.dart';
import 'package:parcial/models/register_request_model.dart';
import 'package:parcial/models/register_response_model.dart';
import 'package:parcial/repositories/repository.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      var url = Uri.http(Config.apiUrl, Config.loginApi);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Manejar errores aquí
      print('Error en la solicitud de login: $e');
      return false;
    } finally {
   
    }
  }

  static Future<RegisterResponseModel> register(RegisterRequestModel model) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      var url = Uri.http(Config.apiUrl, Config.registerApi);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        return registerResponseJson(response.body);
      } else {
        throw Exception('Error en la solicitud de registro: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores aquí
      print('Error en la solicitud de registro: $e');
      rethrow;
    } finally {
      
    }
  }
  static Future<ItemsResponseModel> items(ItemsRequestModel model) async {
    try {
      
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      var url = Uri.http(Config.apiUrl, Config.items);

      var response = await client.get(
        url,
        headers: requestHeaders,
        
      );

      if (response.statusCode == 200) {
        return itemsResponseJson(response.body);
      } else {
        throw Exception('Error en la solicitud de items: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores aquí
      print('Error en la solicitud de items: $e');
      rethrow;
    } finally {
      
    }
  }static Future<void> getAndInsertFavorites(String username) async {
  try {
    var url = Uri.http(Config.apiUrl, '${Config.favoritos}/$username');
    var response = await client.get(url);

    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      final jsonResponse = jsonDecode(response.body);

      // Obtener la lista de favoritos del JSON
      final jsonList = jsonResponse['favoritos'] as List<dynamic>;

      // Mapear los datos JSON a objetos Item
      final favorites = jsonList.map((json) => Item.fromJson(json)).toList();

      // Insertar los favoritos en la base de datos local
      for (final favorite in favorites) {
        await DatabaseConnection().insertFavorite(favorite);
      }

      print('Favoritos insertados correctamente en la base de datos local');
    } else {
      throw Exception('Error en la solicitud de favoritos: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores aquí
    print('Error al obtener y insertar los favoritos desde la API: $e');
  }
}
static Future<void> sendFavoritesToServer() async {
    try {
      // Obtener todos los favoritos de la base de datos local
      final List<Item> favorites = await DatabaseConnection().getFavorites();

      // Formatear los favoritos en el formato requerido para el cuerpo de la solicitud
      final List<Map<String, dynamic>> favoritesData = favorites.map((favorite) => favorite.toJson()).toList();

      // Construir el cuerpo de la solicitud
      final Map<String, dynamic> requestBody = {
        'favoritos': favoritesData,
      };

      // Establecer los encabezados de la solicitud
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      // Construir la URL del endpoint
      var url = Uri.http(Config.apiUrl, Config.favoritos);

      // Realizar la solicitud POST al endpoint
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Favoritos enviados al servidor correctamente');
      } else {
        throw Exception('Error al enviar los favoritos al servidor: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores aquí
      print('Error al enviar los favoritos al servidor: $e');
    }
  }
}
