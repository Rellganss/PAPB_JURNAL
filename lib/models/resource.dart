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

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      title: json['title'] ?? '',
      fileFormat: json['file_format'] ?? 'Unknown',
      link: json['link'] ?? '',
    );
  }
}
