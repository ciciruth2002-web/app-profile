class SlideModel {
  final int id;
  final String title;
  final String? description;
  final String imageUrl;
  final String? linkUrl;
  final int sortOrder;

  SlideModel({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    this.linkUrl,
    required this.sortOrder,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString() ?? '',
      linkUrl: json['link_url']?.toString(),
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}

