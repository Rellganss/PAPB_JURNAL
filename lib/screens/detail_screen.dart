import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/artikel.dart';

class DetailScreen extends StatelessWidget {
  final Artikel artikel;

  const DetailScreen({Key? key, required this.artikel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artikel.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artikel.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('By ${artikel.author}'),
            const SizedBox(height: 16),
            Text(artikel.summary),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _launchURL(artikel.url),
              child: const Text('Read Full Article'),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}