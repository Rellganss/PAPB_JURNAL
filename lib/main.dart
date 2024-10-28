// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/combined_search_screen.dart';
import 'services/favorite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoriteService.loadFavorites(); // Pastikan favorit dimuat sebelum aplikasi berjalan
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Articles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CombinedSearchScreen(), // Mulai dengan CombinedSearchScreen
    );
  }
}
