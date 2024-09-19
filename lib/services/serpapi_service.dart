import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artikel.dart';

class SerpApiService {
  static const String _apiKey = '3c7cb3509b88ef7c15664bab111c8eea55a30ce44481b7f06eac8a6f84b45f9c'; // Ganti dengan API key-mu
  static const String _baseUrl = 'https://serpapi.com/search.json';

  Future<List<Artikel>> fetchArtikel(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?engine=google_scholar&q=$query&api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> articles = data['organic_results'];

      return articles.map((article) => Artikel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
