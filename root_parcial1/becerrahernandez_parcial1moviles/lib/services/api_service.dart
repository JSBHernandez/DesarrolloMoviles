import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    }
    return null;
  }

  static Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse('$baseUrl/articles'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    }
    return [];
  }

  static Future<List<Article>> getFavorites() async {
    final response = await http.get(Uri.parse('$baseUrl/favorites'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    }
    return [];
  }
}