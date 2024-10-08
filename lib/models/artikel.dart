class Artikel {
  final String title;
  final String author;
  final String summary;
  final String url;

  Artikel({required this.title, required this.author, required this.summary, required this.url});

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      title: json['title'],
      author: json['author'],
      summary: json['summary'],
      url: json['url'],
    );
  }
}