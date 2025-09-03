import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Artikel')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              Image.network(
                article.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
            Text(
              article.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(article.category),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(width: 8),
                Text(
                  'Oleh: ${article.author}',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(article.content, style: TextStyle(fontSize: 16, height: 1.5)),
            SizedBox(height: 16),
            if (article.createdAt != null)
              Text(
                'Dibuat: ${article.createdAt!.toString().split(' ')[0]}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
