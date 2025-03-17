import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import 'favorites_screen.dart'; // Importa la pantalla de favoritos

class ArticlesScreen extends StatefulWidget {
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  List<Article> _articles = [];
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  void _fetchArticles() async {
    final articles = await ApiService.getArticles();
    setState(() {
      _articles = articles;
    });
  }

  void _toggleFavorite(Article article) async {
    setState(() {
      article.isFavorite = !article.isFavorite;
    });
    if (article.isFavorite) {
      await DatabaseHelper().insertFavorite(article);
    } else {
      await DatabaseHelper().deleteFavorite(article.id);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await DatabaseHelper().deleteFavorite;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final articlesToShow = _showFavoritesOnly
        ? _articles.where((article) => article.isFavorite).toList()
        : _articles;

    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
        actions: [
          IconButton(
            icon: Icon(_showFavoritesOnly ? Icons.list : Icons.star),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: articlesToShow.length,
        itemBuilder: (context, index) {
          final article = articlesToShow[index];
          return ListTile(
            leading: Image.network(
              article.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(article.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.seller),
                Text('Rating: ${article.rating}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                article.isFavorite ? Icons.star : Icons.star_border,
                color: article.isFavorite ? Colors.yellow : null,
              ),
              onPressed: () => _toggleFavorite(article),
            ),
          );
        },
      ),
    );
  }
}