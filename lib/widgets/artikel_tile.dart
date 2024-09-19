import 'package:flutter/material.dart';
import '../models/artikel.dart';
import '../screens/detail_screen.dart';

class ArtikelTile extends StatelessWidget {
  final Artikel artikel;

  ArtikelTile({required this.artikel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(artikel.title),
      subtitle: Text(artikel.publicationInfo),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(artikel: artikel),
          ),
        );
      },
    );
  }
}
