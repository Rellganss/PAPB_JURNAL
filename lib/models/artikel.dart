class Artikel {
  final String title;
  final String snippet;
  final String link;
  final String publicationSummary;
  final List<String> authors; // Extract authors correctly
  final List<Resource> resources;
  final int citedBy;
  final String? citedByLink;
  final String? relatedLink;

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
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      title: json['title'] ?? '',
      snippet: json['snippet'] ?? '',
      link: json['link'] ?? '',
      publicationSummary: json['publication_info']?['summary'] ?? '',

      // Extract authors from the nested 'publication_info' field
      authors: (json['publication_info']?['authors'] as List<dynamic>?)
              ?.map((author) => author['name'].toString())
              .toList() ??
          [],

      resources: (json['resources'] as List<dynamic>?)
              ?.map((resource) => Resource.fromJson(resource))
              .toList() ??
          [],
      citedBy: json['inline_links']?['cited_by']?['total'] ?? 0,
      citedByLink: json['inline_links']?['cited_by']?['link'],
      relatedLink: json['inline_links']?['related_pages_link'],
    );
  }
}

class Resource {
  final String title;
  final String fileFormat;
  final String link;

  Resource({
    required this.title,
    required this.fileFormat,
    required this.link,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      title: json['title'] ?? '',
      fileFormat: json['file_format'] ?? 'Unknown',
      link: json['link'] ?? '',
    );
  }
}
