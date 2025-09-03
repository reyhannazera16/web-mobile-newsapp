import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;
  String _error = '';

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners();

    try {
      _articles = await ApiService.getArticles();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addArticle(Article article) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newArticle = await ApiService.createArticle(article);
      _articles.add(newArticle);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateArticle(int id, Article article) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedArticle = await ApiService.updateArticle(id, article);
      final index = _articles.indexWhere((a) => a.id == id);
      if (index != -1) {
        _articles[index] = updatedArticle;
      }
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteArticle(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.deleteArticle(id);
      _articles.removeWhere((a) => a.id == id);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
