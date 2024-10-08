import 'package:flutter/material.dart';
import '../models/artikel.dart';
import '../screens/detail_screen.dart';

class ArtikelTile extends StatelessWidget {
  final Artikel artikel;

  const ArtikelTile({Key? key, required this.artikel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(artikel.title),
      subtitle: Text(artikel.author),
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