import 'package:flutter/material.dart';
import '../models/artikel.dart';
import '../services/serpapi_service.dart';
import '../widgets/artikel_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Artikel> _results = [];

  void _searchArticles() async {
    final articles = await SerpApiService.searchArticles(_controller.text);
    setState(() {
      _results = articles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Articles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter search term...',
              ),
              onSubmitted: (_) => _searchArticles(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  return ArtikelTile(artikel: _results[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}