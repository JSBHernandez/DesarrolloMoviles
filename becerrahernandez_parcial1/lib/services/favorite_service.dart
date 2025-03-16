import 'package:parcial/models/item.dart';
import 'package:parcial/repositories/database_connection.dart';
import 'package:parcial/repositories/repository.dart';

class FavoriteService {
  Repository _repository = Repository();

  FavoriteService() {
    _repository = Repository();
  }

  Future<int> saveFavorite(Item item) async {
    Map<String, dynamic> itemData = {
      'id': item.id,
      'nombre': item.nombre,
      'vendedor': item.vendedor,
      'calificacion': item.calificacion,
    };

    return await _repository.insertData('favoritos', itemData);
  }
}