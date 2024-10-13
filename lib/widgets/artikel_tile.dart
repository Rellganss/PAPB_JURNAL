import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/artikel.dart';
import '../screens/detail_screen.dart';

class ArtikelTile extends StatelessWidget {
  final Artikel artikel;
  final int index; // Tetap ada untuk identifikasi internal (Hero Animation)

  const ArtikelTile({
    super.key,
    required this.artikel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(artikel: artikel),
            ),
          );
        },
        child: ListTile(
          // Menghapus CircleAvatar dan angka urut di sini
          title: Hero(
            tag:
                '${artikel.title}-$index', // Hero Animation tetap dengan kombinasi unik
            child: Text(
              artikel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                artikel.snippet,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                artikel.publicationSummary,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (artikel.citedBy > 0)
                    _buildCitedBy(artikel.citedBy, artikel.citedByLink),
                  const SizedBox(width: 16),
                  if (artikel.relatedLink != null)
                    _buildRelatedLink(artikel.relatedLink!),
                ],
              ),
            ],
          ),
          trailing: artikel.resources.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  onPressed: () => _launchURL(artikel.resources.first.link),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildCitedBy(int citedBy, String? citedByLink) {
    return InkWell(
      onTap: citedByLink != null ? () => _launchURL(citedByLink) : null,
      child: Row(
        children: [
          const Icon(Icons.book, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text('Cited by $citedBy', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRelatedLink(String relatedLink) {
    return InkWell(
      onTap: () => _launchURL(relatedLink),
      child: Row(
        children: [
          const Icon(Icons.link, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          const Text('Related articles', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri? uri = Uri.tryParse(url); // Safely parse the URL

    if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      throw 'Invalid URL: $url';
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
