import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';

class ArticleFormScreen extends StatefulWidget {
  final Article? article;

  ArticleFormScreen({this.article});

  @override
  _ArticleFormScreenState createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends State<ArticleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _titleController.text = widget.article!.title;
      _contentController.text = widget.article!.content;
      _categoryController.text = widget.article!.category;
      _imageUrlController.text = widget.article!.imageUrl ?? '';
      _authorController.text = widget.article!.author;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article == null ? 'Tambah Artikel' : 'Edit Artikel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Konten',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konten harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL Gambar (opsional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Penulis',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penulis harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Consumer<ArticleProvider>(
                builder: (context, articleProvider, child) {
                  return ElevatedButton(
                    onPressed: articleProvider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final article = Article(
                                id: widget.article?.id,
                                title: _titleController.text,
                                content: _contentController.text,
                                category: _categoryController.text,
                                imageUrl: _imageUrlController.text.isNotEmpty
                                    ? _imageUrlController.text
                                    : null,
                                author: _authorController.text,
                              );

                              try {
                                if (widget.article == null) {
                                  await articleProvider.addArticle(article);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Artikel berhasil ditambah',
                                      ),
                                    ),
                                  );
                                } else {
                                  await articleProvider.updateArticle(
                                    widget.article!.id!,
                                    article,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Artikel berhasil diupdate',
                                      ),
                                    ),
                                  );
                                }
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                    child: articleProvider.isLoading
                        ? CircularProgressIndicator()
                        : Text(widget.article == null ? 'Tambah' : 'Update'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
