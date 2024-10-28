import 'package:flutter/material.dart';
import 'screens/combined_search_screen.dart'; // Import the main search screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Articles',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CombinedSearchScreen(), // Start with the SearchScreen
    );
  }
}
