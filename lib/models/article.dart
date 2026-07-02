class Article {
  final int id;
  final String title;
  final String? summary;
  final String? image;
  final String category;
  final String? source;
  final String? contentUrl;
  final DateTime? publishedAt;
  final DateTime? createdAt;

  Article({
    required this.id,
    required this.title,
    this.summary,
    this.image,
    required this.category,
    this.source,
    this.contentUrl,
    this.publishedAt,
    this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      summary: json['summary'] ?? json['description'],
      image: json['image'] ?? json['cover'],
      category: json['category'] ?? json['type'] ?? 'gsxw',
      source: json['source'],
      contentUrl: json['content_url'] ?? json['contentUrl'] ?? json['url'],
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}

class ArticleListResponse {
  final List<Article> items;
  final int total;
  final int page;
  final int pageSize;

  ArticleListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory ArticleListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ArticleListResponse(
      items: (data['data'] as List<dynamic>?)
              ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      pageSize: data['page_size'] ?? data['pageSize'] ?? 20,
    );
  }
}
