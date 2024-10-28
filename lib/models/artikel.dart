// lib/models/artikel.dart

import 'resource.dart';

class Artikel {
  final String title;
  final String snippet;
  final String link;
  final String publicationSummary;
  final List<String> authors;
  final List<Resource> resources;
  final int citedBy;
  final String? citedByLink;
  final String? relatedLink;

  // Atribut untuk menandai artikel sebagai favorit
  bool isFavorite; // Menandakan apakah artikel ini ditandai sebagai favorit

  Artikel({
    required this.title,
    required this.snippet,
    required this.link,
    required this.publicationSummary,
    required this.authors,
    required this.resources,
    required this.citedBy,
    required this.citedByLink,
    required this.relatedLink,
    this.isFavorite = false, // Default tidak favorit
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      title: json['title'] ?? '',
      snippet: json['snippet'] ?? '',
      link: json['link'] ?? '',
      publicationSummary: json['publication_info']?['summary'] ?? '',
      authors: (json['publication_info']?['authors'] as List<dynamic>?)
              ?.map((author) => author['name'].toString())
              .toList() ?? [],
      resources: (json['resources'] as List<dynamic>?)
              ?.map((resource) => Resource.fromJson(resource))
              .toList() ?? [],
      citedBy: json['inline_links']?['cited_by']?['total'] ?? 0,
      citedByLink: json['inline_links']?['cited_by']?['link'],
      relatedLink: json['inline_links']?['related_pages_link'],
    );
  }
}
