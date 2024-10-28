// lib/services/favorite_service.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/artikel.dart';

class FavoriteService {
  // Membuat instance FlutterSecureStorage
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Key untuk menyimpan daftar favorit
  static const String _favoritesKey = 'favorites';

  // Mendapatkan daftar favorit dari secure storage
  static Future<List<Artikel>> getFavorites() async {
    try {
      final String? favoritesJson = await _storage.read(key: _favoritesKey);
      if (favoritesJson != null) {
        final List<dynamic> decodedData = jsonDecode(favoritesJson);
        return decodedData.map((json) => Artikel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      // Handle error jika diperlukan
      print('Error reading favorites: $e');
      return [];
    }
  }

  // Menyimpan daftar favorit ke secure storage
  static Future<void> _saveFavorites(List<Artikel> favorites) async {
    try {
      final String encodedData =
          jsonEncode(favorites.map((artikel) => artikel.toJson()).toList());
      await _storage.write(key: _favoritesKey, value: encodedData);
    } catch (e) {
      // Handle error jika diperlukan
      print('Error saving favorites: $e');
    }
  }

  // Menambahkan artikel ke daftar favorit
  static Future<void> addFavorite(Artikel artikel) async {
    try {
      List<Artikel> currentFavorites = await getFavorites();
      if (!currentFavorites.any((item) => item.title == artikel.title)) {
        artikel.isFavorite = true;
        currentFavorites.add(artikel);
        await _saveFavorites(currentFavorites);
      }
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // Menghapus artikel dari daftar favorit
  static Future<void> removeFavorite(Artikel artikel) async {
    try {
      List<Artikel> currentFavorites = await getFavorites();
      artikel.isFavorite = false;
      currentFavorites.removeWhere((item) => item.title == artikel.title);
      await _saveFavorites(currentFavorites);
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  // Memuat favorit saat inisialisasi (jika diperlukan)
  static Future<void> loadFavorites() async {
    await getFavorites(); // Memanggil getFavorites untuk memastikan data dimuat
  }
}
