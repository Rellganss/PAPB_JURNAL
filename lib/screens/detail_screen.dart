import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/artikel.dart';

class DetailScreen extends StatelessWidget {
  final Artikel artikel;

  const DetailScreen({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Hero(
          tag: '${artikel.title}-${artikel.link}', // Unique Hero tag
          child: Material(
            color: Colors.transparent,
            child: Text(
              artikel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Authors Section
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

  // Section 1: Title, Authors, and Publication Info
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          artikel.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formatAuthors(artikel.authors),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          artikel.publicationSummary,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // Section 2: Snippet/Abstract Section
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              artikel.snippet,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Section 3: Links (View in Browser, PDF, etc.)
  Widget _buildLinksSection(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _launchURL(context, artikel.link),
          child: const Text('View at Source'),
        ),
        const SizedBox(height: 8),
        if (artikel.resources.isNotEmpty)
          ElevatedButton(
            onPressed: () => _launchURL(context, artikel.resources.first.link),
            child: Text('[PDF] ${artikel.resources.first.title}'),
          ),
      ],
    );
  }

  // Section 4: Metadata (Citations, Related Articles, Versions)
  Widget _buildMetadataSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.library_books),
          title: const Text('Cited by ${1234}'), // Example data
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _launchURL(
            context,
            'https://scholar.google.com/scholar?cites=${artikel.citedBy}',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text('Related Articles'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _launchURL(
            context,
            'https://scholar.google.com/scholar?q=related:${artikel.link}',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('All Versions'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _launchURL(
            context,
            'https://scholar.google.com/scholar?cluster=${artikel.link}',
          ),
        ),
      ],
    );
  }

  // Function to format authors list or show 'Unknown'
  String _formatAuthors(List<String> authors) {
    if (authors.isEmpty) {
      return 'Author: Unknown';
    } else {
      return authors.join(", ");
    }
  }

  // Function to open a URL with error handling
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
      final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        _showErrorDialog(context, 'Could not launch the URL.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Failed to launch URL: $e');
    }
  }

  // Function to display an error dialog
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
