import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artikel.dart';

class SerpApiService {
  static const String _apiKey = '3c7cb3509b88ef7c15664bab111c8eea55a30ce44481b7f06eac8a6f84b45f9c';
  static const String _baseUrl = 'https://serpapi.com/search.json';

  static Future<List<Artikel>> searchArticles(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl?engine=google_scholar&q=$query&api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final List articlesJson = json.decode(response.body)['organic_results'];
      return articlesJson.map((json) => Artikel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}