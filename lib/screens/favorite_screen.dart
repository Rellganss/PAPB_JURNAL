// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../models/artikel.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteService.getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final artikel = favorites[index]; // Menggunakan model Artikel langsung
                return ListTile(
                  title: Text(artikel.title),
                  onTap: () {
                    // Navigasi ke DetailScreen dengan data artikel yang sesuai
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          artikel: artikel, // Menggunakan objek Artikel
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removeFavorite(context, artikel);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _removeFavorite(BuildContext context, Artikel artikel) {
    FavoriteService.removeFavorite(artikel);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${artikel.title} removed from favorites!')),
    );
  }
}
