class Artikel {
  final String title;
  final String link;
  final String snippet;
  final String publicationInfo;

  Artikel({
    required this.title,
    required this.link,
    required this.snippet,
    required this.publicationInfo,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      title: json['title'] ?? 'No Title',
      link: json['link'] ?? '',
      snippet: json['snippet'] ?? 'No Snippet Available',
      publicationInfo: json['publication_info'] ?? 'No Publication Info',
    );
  }
}
