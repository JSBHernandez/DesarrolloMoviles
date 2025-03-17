class Article {
  final int id;
  final String title;
  final String seller;
  final double rating;
  final String imageUrl;
  bool isFavorite;

  Article({
    required this.id,
    required this.title,
    required this.seller,
    required this.rating,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      seller: json['seller'],
      rating: json['rating'],
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'seller': seller,
      'rating': rating,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}