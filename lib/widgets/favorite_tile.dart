// lib/widgets/favorite_tile.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/artikel.dart';
import '../screens/detail_screen.dart';

class FavoriteTile extends StatelessWidget {
  final Artikel artikel;
  final VoidCallback onRemove;

  const FavoriteTile({
    super.key,
    required this.artikel,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(artikel: artikel),
            ),
          ).then((_) {
            // Refresh jika diperlukan setelah kembali dari DetailScreen
          });
        },
        child: ListTile(
          title: Text(
            artikel.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              decoration: TextDecoration.underline,
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
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onRemove,
          ),
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
    final Uri? uri = Uri.tryParse(url);

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
