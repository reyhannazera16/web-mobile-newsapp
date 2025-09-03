import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../screens/article_form_screen.dart';
import '../screens/article_detail_screen.dart';
import '../models/article.dart';

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArticleProvider>(context, listen: false).fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita App'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Provider.of<ArticleProvider>(
                context,
                listen: false,
              ).fetchArticles();
            },
          ),
        ],
      ),
      body: Consumer<ArticleProvider>(
        builder: (context, articleProvider, child) {
          if (articleProvider.isLoading && articleProvider.articles.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (articleProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${articleProvider.error}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => articleProvider.fetchArticles(),
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (articleProvider.articles.isEmpty) {
            return Center(child: Text('Tidak ada artikel'));
          }

          return ListView.builder(
            itemCount: articleProvider.articles.length,
            itemBuilder: (context, index) {
              final article = articleProvider.articles[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: article.imageUrl != null
                      ? Image.network(
                          article.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.article, size: 40),
                  title: Text(article.title),
                  subtitle: Text(
                    '${article.category} - ${article.author}',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleFormScreen(article: article),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () {
                          _showDeleteDialog(context, article);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArticleFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Article article) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus Artikel'),
        content: Text('Yakin ingin menghapus "${article.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await Provider.of<ArticleProvider>(
                  context,
                  listen: false,
                ).deleteArticle(article.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Artikel berhasil dihapus')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menghapus artikel: $e')),
                );
              }
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
