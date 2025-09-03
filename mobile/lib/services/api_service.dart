import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/article.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    } else {
      return 'http://10.0.2.2:8000/api';
    }
  }

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Generic request method dengan error handling
  static Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final encodedBody = body != null ? json.encode(body) : null;

      switch (method) {
        case 'GET':
          return await http.get(uri, headers: headers);
        case 'POST':
          return await http.post(uri, headers: headers, body: encodedBody);
        case 'PUT':
          return await http.put(uri, headers: headers, body: encodedBody);
        case 'DELETE':
          return await http.delete(uri, headers: headers);
        default:
          throw Exception('Unsupported HTTP method');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get all articles
  static Future<List<Article>> getArticles() async {
    final response = await _makeRequest('GET', '/articles');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articlesData = data['data'];
      return articlesData.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load articles. Status code: ${response.statusCode}',
      );
    }
  }

  // Create article
  static Future<Article> createArticle(Article article) async {
    final response = await _makeRequest(
      'POST',
      '/articles',
      body: article.toJson(),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Article.fromJson(data['data']);
    } else {
      final Map<String, dynamic> error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to create article');
    }
  }

  // Update article
  static Future<Article> updateArticle(int id, Article article) async {
    final response = await _makeRequest(
      'PUT',
      '/articles/$id',
      body: article.toJson(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Article.fromJson(data['data']);
    } else {
      final Map<String, dynamic> error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to update article');
    }
  }

  // Delete article
  static Future<void> deleteArticle(int id) async {
    final response = await _makeRequest('DELETE', '/articles/$id');

    if (response.statusCode != 200) {
      final Map<String, dynamic> error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to delete article');
    }
  }
}
