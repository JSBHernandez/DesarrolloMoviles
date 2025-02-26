import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class ApiService {
  final String apiUrl = "https://api.npoint.io/5cb393746e518d1d8880";

  Future<List<Person>> fetchPersons() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List elementos = jsonResponse['elementos'];
      return elementos.map((person) => Person.fromJson(person)).toList();
    } else {
      throw Exception('Failed to load persons');
    }
  }
}