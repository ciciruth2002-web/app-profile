class PageModel {
  final int id;
  final String title;
  final String slug;
  final String? content;
  final String? imageUrl;
  final String status;
  final int sortOrder;
  final bool showInMenu;

  PageModel({
    required this.id,
    required this.title,
    required this.slug,
    this.content,
    this.imageUrl,
    required this.status,
    this.sortOrder = 0,
    this.showInMenu = false,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      content: json['content']?.toString(),
      imageUrl: json['image_url']?.toString(),
      status: json['status']?.toString() ?? 'draft',
      sortOrder: json['sort_order'] ?? 0,
      showInMenu: json['show_in_menu'] ?? false,
    );
  }
}

