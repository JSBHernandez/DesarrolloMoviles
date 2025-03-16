import 'package:becerrahernandez_parcial1/models/item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_parcial');
    var database = await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  Future<void> _onCreatingDatabase(Database database, int version) async {
    await database.execute("CREATE TABLE favoritos(id INTEGER PRIMARY KEY, nombre TEXT, vendedor TEXT, calificacion TEXT, image TEXT)");
    await database.execute("CREATE TABLE tokens(id INTEGER PRIMARY KEY, token TEXT, username TEXT)");

  }

  Future<void> insertFavorite(Item item) async {
    try {
    final Database db = await setDatabase();
    int result = await db.insert(
      'favoritos',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    if (result != -1) {
      print('El artículo se agregó a la base de datos correctamente');
      
    } else {
      print('Hubo un error al agregar el artículo a la base de datos');
      
    }
  } catch (e) {
    print('Error al insertar el artículo en la base de datos: $e');
  }
  }

  Future<void> printFavorites() async {
  try {
    final Database db = await setDatabase();
    final List<Map<String, dynamic>> favorites = await db.query('favoritos');
    
    if (favorites.isNotEmpty) {
      print('Artículos en la base de datos:');
      for (final favorite in favorites) {
        print('ID: ${favorite['id']}, Nombre: ${favorite['nombre']}, Vendedor: ${favorite['vendedor']}, Calificación: ${favorite['calificacion']}');
      }
    } else {
      print('No hay artículos en la base de datos');
    }
  } catch (e) {
    print('Error al consultar la base de datos: $e');
  }
}
Future<void> removeFavorite(Item item) async {
  try {
    final Database db = await setDatabase();
    int result = await db.delete(
      'favoritos',
      where: 'id = ?',
      whereArgs: [item.id],
    );

    if (result != 0) {
      print('El artículo se eliminó de la base de datos correctamente');
      
    } else {
      print('No se encontró el artículo en la base de datos');
      
    }
  } catch (e) {
    print('Error al eliminar el artículo de la base de datos: $e');
  }
}
Future<List<Item>> getFavorites() async {
  try {
    final Database db = await setDatabase();
    final List<Map<String, dynamic>> favorites = await db.query('favoritos');
    List<Item> favoriteItems = [];

    for (final favorite in favorites) {
      favoriteItems.add(Item(
        id: favorite['id'].toString(),
        nombre: favorite['nombre'],
        vendedor: favorite['vendedor'],
        calificacion: favorite['calificacion'],
        image: favorite['image'],
      ));
    }

    return favoriteItems;
  } catch (e) {
    print('Error al obtener los artículos favoritos de la base de datos: $e');
    return [];
  }
}
 Future<void> deleteAllFavorites() async {

    try {
      final Database db = await setDatabase();
      await db.delete('favoritos'); 
      print('Se eliminaron todos los favoritos de la base de datos');
    } catch (e) {
      print('Error al eliminar todos los favoritos de la base de datos: $e');
    }
  }
Future<void> insertTokenAndUsername(String token, String username) async {
  try {
    final Database db = await setDatabase();
    int result = await db.insert(
      'tokens',
      {'token': token, 'username': username},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (result != -1) {
      print('Token y nombre de usuario se agregaron a la base de datos correctamente');
    } else {
      print('Hubo un error al agregar el token y nombre de usuario a la base de datos');
    }
  } catch (e) {
    print('Error al insertar el token y nombre de usuario en la base de datos: $e');
  }
}


}