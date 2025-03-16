import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleItem extends StatelessWidget {
  final Article article;

  ArticleItem({required this.article});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(article.imageUrl),
      title: Text(article.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Seller: ${article.seller}'),
          Text('Rating: ${article.rating}'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.star_border),
        onPressed: () {
          // Add to favorites
        },
      ),
    );
  }
}