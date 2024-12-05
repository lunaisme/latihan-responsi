class ContentItem {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String summary;
  final String publishedAt;
  final String type; // 'news', 'blog', or 'report'

  ContentItem({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.summary,
    required this.publishedAt,
    required this.type,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json, String type) {
    return ContentItem(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      imageUrl: json['image_url'] ?? '',
      summary: json['summary'] ?? '',
      publishedAt: json['published_at'] ?? '',
      type: type,
    );
  }
}
