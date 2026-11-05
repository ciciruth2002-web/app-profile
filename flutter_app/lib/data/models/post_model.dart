import 'category_model.dart';

class PostModel {
  final int id;
  final String title;
  final String slug;
  final String? summary;
  final String? content;
  final String? imageUrl;
  final String status;
  final String? publishedAt;
  final int viewCount;
  final bool isFeatured;
  final CategoryModel? category;
  final String? authorName;
  final String? authorAvatar;

  PostModel({
    required this.id,
    required this.title,
    required this.slug,
    this.summary,
    this.content,
    this.imageUrl,
    required this.status,
    this.publishedAt,
    this.viewCount = 0,
    this.isFeatured = false,
    this.category,
    this.authorName,
    this.authorAvatar,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      summary: json['summary']?.toString(),
      content: json['content']?.toString(),
      imageUrl: json['image_url']?.toString(),
      status: json['status']?.toString() ?? 'draft',
      publishedAt: json['published_at']?.toString(),
      viewCount: json['view_count'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      authorName: json['author']?['name']?.toString(),
      authorAvatar: json['author']?['avatar_url']?.toString(),
    );
  }
}

