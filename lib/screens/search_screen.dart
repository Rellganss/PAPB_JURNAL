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
  final TextEditingController _allWordsController = TextEditingController();
  final TextEditingController _exactPhraseController = TextEditingController();
  final TextEditingController _atLeastOneController = TextEditingController();
  final TextEditingController _withoutWordsController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publishedInController = TextEditingController();
  final TextEditingController _startYearController = TextEditingController();
  final TextEditingController _endYearController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Artikel> _results = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isAdvancedSearchVisible = false;
  int _currentPage = 1;

  String _wordsOccur = 'anywhere';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _allWordsController.dispose();
    _exactPhraseController.dispose();
    _atLeastOneController.dispose();
    _withoutWordsController.dispose();
    _authorController.dispose();
    _publishedInController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
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
        _results.clear(); // Clear results for a new search
      }
    });

    try {
      final articles = await SerpApiService.searchArticles(
        query: _searchController.text,
        author: _authorController.text.isEmpty ? null : _authorController.text,
        sortBy: 'relevance',
        dateRange: null,
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
        title: const Text('Search Articles'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchArticles,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            if (_isAdvancedSearchVisible) ...[
              const SizedBox(height: 16),
              _buildAdvancedSearchOptions(),
            ],
            const SizedBox(height: 16),
            Expanded(child: _buildResultList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Column(
      children: [
        Row(
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
              onPressed: _searchArticles,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(14.0),
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.search, size: 24),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isAdvancedSearchVisible = !_isAdvancedSearchVisible;
            });
          },
          child: Text(_isAdvancedSearchVisible ? 'Hide Advanced Search' : 'Show Advanced Search'),
        ),
      ],
    );
  }

  Widget _buildAdvancedSearchOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(_allWordsController, 'with all of the words'),
        const SizedBox(height: 16),
        _buildTextField(_exactPhraseController, 'with the exact phrase'),
        const SizedBox(height: 16),
        _buildTextField(_atLeastOneController, 'with at least one of the words'),
        const SizedBox(height: 16),
        _buildTextField(_withoutWordsController, 'without the words'),
        const SizedBox(height: 16),
        _buildTextField(_authorController, 'Return articles authored by'),
        const SizedBox(height: 16),
        _buildTextField(_publishedInController, 'Return articles published in'),
        const SizedBox(height: 16),
        _buildDateRangeFields(),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateRangeFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(_startYearController, 'Start Year'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField(_endYearController, 'End Year'),
        ),
      ],
    );
  }

  Widget _buildResultList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ic_launcher_monochrome.png', // Replace with the path to your app logo
              height: 100,
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
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
