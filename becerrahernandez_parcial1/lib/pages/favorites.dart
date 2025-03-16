import 'package:flutter/material.dart';
import 'package:parcial/helpers/drawer_navigation.dart';
import 'package:parcial/models/item.dart';
import 'package:parcial/repositories/database_connection.dart';
import 'package:parcial/repositories/repository.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<Favorites> {
  final _databaseConnection = DatabaseConnection();

  late List<Item> _favoriteItems;

  @override
  void initState() {
    super.initState();
    _loadFavoriteItems();
  }

  Future<void> _loadFavoriteItems() async {
    final favorites = await _databaseConnection.getFavorites();
    setState(() {
      _favoriteItems = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Artículos Favoritos',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
             
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
            },
          ),
        ],
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _favoriteItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _favoriteItems[index];
          return ListTile(
             leading: Image.network(
              item.image,
              width: 50, 
              height: 50, 
              fit: BoxFit.cover,
            ),
            title: Text(item.nombre),
            subtitle:
                Text('Vendedor: ${item.vendedor} - Calificación: ${item.calificacion}'),
            trailing: IconButton(
              icon: Icon(
                Icons.star,
                color: Colors.amber, 
              ),
             onPressed: () async {
                setState(() {
                   _favoriteItems.remove(item); 
                });
                await _databaseConnection.removeFavorite(item); 
                _loadFavoriteItems(); 
              },
            ),
          );
        },
      ),
    );
  }
}
