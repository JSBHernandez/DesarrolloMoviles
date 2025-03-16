import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../widgets/article_item.dart';

class ArticlesScreen extends StatefulWidget {
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
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
      appBar: AppBar(title: Text('Articles')),
      body: ListView.builder(
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          return ArticleItem(article: _articles[index]);
        },
      ),
    );
  }
}