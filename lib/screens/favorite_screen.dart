import 'package:app_papb/widgets/favorite_tile.dart';
import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../models/artikel.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Artikel> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoriteService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: _favorites.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final artikel = _favorites[index];
                return FavoriteTile(
                  artikel: artikel,
                  onRemove: () async {
                    FavoriteService.removeFavorite(artikel);
                    _loadFavorites(); // Refresh list
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${artikel.title} removed from favorites!')),
                    );
                  },
                );
              },
            ),
    );
  }
}
