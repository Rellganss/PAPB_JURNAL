import 'package:app_papb/screens/favorite_screen.dart';
import 'package:flutter/material.dart';
import '../models/artikel.dart';
import '../services/serpapi_service.dart';
import '../widgets/artikel_tile.dart';



class CombinedSearchScreen extends StatefulWidget {
  const CombinedSearchScreen({super.key});

  @override
  _CombinedSearchScreenState createState() => _CombinedSearchScreenState();
}

class _CombinedSearchScreenState extends State<CombinedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Artikel> _results = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isAdvancedSearchVisible = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _searchArticles({bool isLoadMore = false}) async {
    if (_isLoading || _isLoadingMore) return;

    setState(() {
      if (isLoadMore) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
        _results.clear();
        _currentPage = 1;
      }
    });

    try {
      final articles = await SerpApiService.searchArticles(
        query: _searchController.text,
        page: _currentPage,
      );

      setState(() {
        if (isLoadMore) {
          _results.addAll(articles);
        } else {
          _results = articles;
        }
        _currentPage++;
      });
    } catch (e) {
      _showErrorDialog('Failed to load articles: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _searchArticles(isLoadMore: true);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paper Finder',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_results.isEmpty) _buildLogoAndName(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              if (_isAdvancedSearchVisible) _buildAdvancedSearchOptions(),
              const SizedBox(height: 16),
              _buildToggleAdvancedSearch(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: _buildResultList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndName() {
    return Column(
      children: [
        Image.asset(
          'images/ic_launcher_monochrome.png', // Replace with the path to your app logo
          height: 100,
        ),
        const SizedBox(height: 16),
        const Text(
          'Find Scholarly Articles Easily',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for articles...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _searchArticles(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _searchArticles(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(14.0),
            shape: const CircleBorder(),
          ),
          child: const Icon(Icons.search, size: 24),
        ),
      ],
    );
  }

  Widget _buildToggleAdvancedSearch() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isAdvancedSearchVisible = !_isAdvancedSearchVisible;
        });
      },
      child: Text(
        _isAdvancedSearchVisible ? 'Hide Advanced Search' : 'Show Advanced Search',
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _buildAdvancedSearchOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAdvancedSearchField('with all of the words'),
        _buildAdvancedSearchField('with the exact phrase'),
        _buildAdvancedSearchField('with at least one of the words'),
        _buildAdvancedSearchField('without the words'),
        _buildAdvancedSearchField('Return articles authored by'),
        _buildAdvancedSearchField('Return articles published in'),
      ],
    );
  }

  Widget _buildAdvancedSearchField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildResultList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_results.isEmpty && _searchController.text.isNotEmpty) {
      // Show 'No results found' only after a search has been made
      return const Center(child: Text('No results found.'));
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: _results.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _results.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return ArtikelTile(
            artikel: _results[index],
            index: index,
          );
        },
      );
    }
  }

}
