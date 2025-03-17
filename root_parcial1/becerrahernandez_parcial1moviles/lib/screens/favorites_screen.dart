// filepath: c:\Users\sebas\OneDrive\Documentos\GitHub\DesarrolloMoviles\root_parcial1\becerrahernandez_parcial1moviles\lib\screens\favorites_screen.dart
import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Article> _articles = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _articles.isEmpty
          ? Center(child: Text('No articles available'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        article.imageUrl,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(article.seller),
                            SizedBox(height: 4),
                            Text('Rating: ${article.rating}'),
                            SizedBox(height: 4),
                            IconButton(
                              icon: Icon(
                                article.isFavorite ? Icons.star : Icons.star_border,
                                color: article.isFavorite ? Colors.yellow : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  article.isFavorite = !article.isFavorite;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}