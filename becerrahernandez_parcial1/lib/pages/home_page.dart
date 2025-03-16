import 'package:flutter/material.dart';
import 'package:parcial/helpers/drawer_navigation.dart';
import 'package:parcial/models/item.dart';
import 'package:parcial/models/items_request_model.dart';
import 'package:parcial/repositories/database_connection.dart';
import 'package:parcial/repositories/repository.dart';
import 'package:parcial/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _databaseConnection = DatabaseConnection();

  List<Item> _items = [];
  late Set<String> _favoriteItems;
  bool _showInTwoColumns = false;

  @override
  void initState() {
    super.initState();
    _favoriteItems = {};
    _loadFavoriteItems();
  }

  Future<void> _loadFavoriteItems() async {
    final favorites = await _databaseConnection.getFavorites();
    setState(() {
      _favoriteItems = favorites.map((favorite) => favorite.id).toSet();
    });
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final itemsRequest = ItemsRequestModel(username: '');

    try {
      final response = await APIService.items(itemsRequest);
      setState(() {
        _items = response.data?.items ?? [];
      });
    } catch (e) {
      print('Error al obtener los items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Artículos',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            letterSpacing: 0.1,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const DrawerNavigation(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showInTwoColumns = !_showInTwoColumns;
              });
            },
            child: Text(_showInTwoColumns ? 'Mostrar en una columna' : 'Mostrar en dos columnas'),
          ),
          Expanded(
            child: _showInTwoColumns
                ? GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.7, 
                    ),
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _items[index];
                      final isFavorite = _favoriteItems.contains(item.id);

                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 120, 
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  item.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                item.nombre,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Vendedor: ${item.vendedor}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Calificación: ${item.calificacion}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.star : Icons.star_border,
                                  color: isFavorite ? Colors.amber : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (isFavorite) {
                                      _favoriteItems.remove(item.id);
                                      _databaseConnection.removeFavorite(item);
                                    } else {
                                      _favoriteItems.add(item.id);
                                      _databaseConnection.insertFavorite(item);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _items[index];
                      final isFavorite = _favoriteItems.contains(item.id);

                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                item.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            item.nombre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vendedor: ${item.vendedor}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Calificación: ${item.calificacion}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: isFavorite ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () async {
                              setState(() {
                                if (isFavorite) {
                                  _favoriteItems.remove(item.id);
                                  _databaseConnection.removeFavorite(item);
                                } else {
                                  _favoriteItems.add(item.id);
                                  _databaseConnection.insertFavorite(item);
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
