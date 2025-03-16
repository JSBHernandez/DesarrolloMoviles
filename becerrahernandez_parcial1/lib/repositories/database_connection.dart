import 'package:http/retry.dart';
import 'package:becerrahernandez_parcial1/repositories/database_connection.dart';
import 'package:becerrahernandez_parcial1/repositories/repository.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static late Database _database;

  Future<Database> getDatabase() async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

 Future<int> insertData(String table, Map<String, dynamic> data) async {
    var connection = await getDatabase(); 
    return await connection.insert(table, data);
  }
}
