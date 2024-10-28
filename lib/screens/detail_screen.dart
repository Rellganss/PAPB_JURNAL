// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/artikel.dart';
import '../services/favorite_service.dart';

class DetailScreen extends StatefulWidget {
  final Artikel artikel;

  const DetailScreen({super.key, required this.artikel});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorited = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final favorites = await FavoriteService.getFavorites();
    setState(() {
      isFavorited =
          favorites.any((favorite) => favorite.title == widget.artikel.title);
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    if (isFavorited) {
      await FavoriteService.removeFavorite(widget.artikel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites!')),
      );
    } else {
      await FavoriteService.addFavorite(widget.artikel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favorites!')),
      );
    }
    // Perbarui status favorit
    await _checkIfFavorited();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Hero(
          tag: 'Article or Journal',
          child: Material(
            color: Colors.transparent,
            child: Text(
              widget.artikel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: isFavorited
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_border),
            onPressed: _isLoading ? null : _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            const SizedBox(height: 16),
            _buildSnippetSection(),
            const SizedBox(height: 16),
            _buildLinksSection(context),
            const Divider(thickness: 1),
            _buildMetadataSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.artikel.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _formatAuthors(widget.artikel.authors),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          widget.artikel.publicationSummary,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSnippetSection() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Abstract',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              widget.artikel.snippet,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tombol View at Source
        Expanded(
          child: ElevatedButton(
            onPressed: () => _launchURL(context, widget.artikel.link),
            child: const Text('View at Source'),
          ),
        ),
        const SizedBox(width: 8), // Spasi antar tombol
        // Tombol PDF (jika ada resources)
        if (widget.artikel.resources.isNotEmpty)
          Expanded(
            child: ElevatedButton(
              onPressed: () =>
                  _launchURL(context, widget.artikel.resources.first.link),
              child: Text('[PDF] ${widget.artikel.resources.first.title}'),
            ),
          ),
      ],
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.library_books),
          title: Text('Cited by ${widget.artikel.citedBy}'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _launchURL(
            context,
            widget.artikel.citedByLink ??
                'https://scholar.google.com/scholar?cites=${widget.artikel.citedBy}',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text('Related Articles'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _launchURL(
            context,
            'https://scholar.google.com/scholar?q=related:${widget.artikel.link}',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('All Versions'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _launchURL(
            context,
            'https://scholar.google.com/scholar?cluster=${widget.artikel.link}',
          ),
        ),
      ],
    );
  }

  // Fungsi untuk memformat daftar penulis
  String _formatAuthors(List<String> authors) {
    if (authors.isEmpty) {
      return 'Author: Unknown';
    } else {
      return authors.join(", ");
    }
  }

  // Fungsi untuk membuka URL dengan penanganan kesalahan
  Future<void> _launchURL(BuildContext context, String url) async {
    if (url.isEmpty) {
      _showErrorDialog(context, 'URL is empty.');
      return;
    }

    final Uri? uri = Uri.tryParse(url);

    if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      _showErrorDialog(context, 'Invalid URL: $url');
      return;
    }

    try {
      final bool launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        _showErrorDialog(context, 'Could not launch the URL.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Failed to launch URL: $e');
    }
  }

  // Fungsi untuk menampilkan dialog kesalahan
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
