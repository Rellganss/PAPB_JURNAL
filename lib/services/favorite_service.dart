// lib/services/favorite_service.dart

import '../models/artikel.dart';

class FavoriteService {
  // Daftar untuk menyimpan artikel favorit
  static final List<Artikel> _favorites = [];

  // Mendapatkan daftar favorit
  static List<Artikel> getFavorites() {
    return _favorites;
  }

  // Menambahkan artikel ke daftar favorit
  static void addFavorite(Artikel artikel) {
    // Cek apakah sudah ada favorit yang sama
    if (!_favorites.any((item) => item.title == artikel.title)) {
      artikel.isFavorite = true; // Tandai sebagai favorit
      _favorites.add(artikel);
    }
  }

  // Menghapus artikel dari daftar favorit
  static void removeFavorite(Artikel artikel) {
    artikel.isFavorite = false; // Hapus tanda favorit
    _favorites.removeWhere((item) => item.title == artikel.title);
  }
}
