// lib/models/resource.dart

class Resource {
  final String title;
  final String fileFormat;
  final String link;

  Resource({
    required this.title,
    required this.fileFormat,
    required this.link,
  });

  // Factory method untuk membuat Resource dari JSON
  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      title: json['title'] ?? '',
      fileFormat: json['file_format'] ?? 'Unknown',
      link: json['link'] ?? '',
    );
  }

  // Method untuk mengubah Resource menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'file_format': fileFormat,
      'link': link,
    };
  }
}
