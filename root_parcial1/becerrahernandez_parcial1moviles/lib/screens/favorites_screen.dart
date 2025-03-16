import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../widgets/favorite_item.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Article> _favorites = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() async {
    final favorites = await ApiService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          return FavoriteItem(article: _favorites[index]);
        },
      ),
    );
  }
}