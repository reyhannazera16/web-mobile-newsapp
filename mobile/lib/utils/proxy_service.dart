import 'dart:convert';
import 'package:http/http.dart' as http;

class ProxyService {
  static const String proxyUrl = 'https://cors-anywhere.herokuapp.com/';
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<http.Response> proxyRequest(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = Uri.parse('$proxyUrl$baseUrl$endpoint');

    try {
      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      throw Exception('Proxy error: $e');
    }
  }
}
