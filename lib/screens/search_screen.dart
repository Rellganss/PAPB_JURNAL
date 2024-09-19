import 'package:flutter/material.dart';
import '../services/serpapi_service.dart';
import '../widgets/artikel_tile.dart';
import '../models/artikel.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Artikel> _artikelList = [];
  bool _isLoading = false;

  final SerpApiService _serpApiService = SerpApiService();

  void _searchArtikel(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Artikel> artikelList = await _serpApiService.fetchArtikel(query);
      setState(() {
        _artikelList = artikelList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching articles: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pencarian Artikel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Masukkan kata kunci',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchArtikel(_searchController.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _artikelList.length,
                      itemBuilder: (context, index) {
                        return ArtikelTile(artikel: _artikelList[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
