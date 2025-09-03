class Article {
  int? id;
  String title;
  String content;
  String category;
  String? imageUrl;
  String author;
  DateTime? createdAt;
  DateTime? updatedAt;

  Article({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    required this.author,
    this.createdAt,
    this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      imageUrl: json['image_url'],
      author: json['author'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'image_url': imageUrl,
      'author': author,
    };
  }
}
