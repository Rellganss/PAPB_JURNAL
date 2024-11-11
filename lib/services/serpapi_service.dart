import 'dart:convert';
import 'package:flutter/src/material/date.dart';
import 'package:http/http.dart' as http;
import '../models/artikel.dart';

class SerpApiService {
  static const String _apiKey = 'bc956eb4c0aad6d5aa09871185cad6bfa4bec7b19d7e9f0510f6159d9372b11a';
  static const String _baseUrl = 'https://serpapi.com/search.json';

  static Future<List<Artikel>> searchArticles({
    required String query,
    int page = 1,
    String? author,
    String? sortBy,
    DateTimeRange? dateRange,
  }) async {
    String url = '$_baseUrl?engine=google_scholar&q=$query&api_key=$_apiKey&start=${(page - 1) * 10}';

    // Add optional parameters if they are not null
    if (author != null && author.isNotEmpty) {
      url += '&author=$author';
    }
    if (sortBy != null && sortBy.isNotEmpty) {
      url += '&sort_by=$sortBy';
    }
    if (dateRange != null) {
      final String startDate = dateRange.start.toIso8601String();
      final String endDate = dateRange.end.toIso8601String();
      url += '&date_from=$startDate&date_to=$endDate';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List articlesJson = json.decode(response.body)['organic_results'];
      return articlesJson.map((json) => Artikel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
