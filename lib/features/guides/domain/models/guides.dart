class Guide {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String type;
  final String imageUrl;
  final String url;
  final bool isActive;

  Guide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.type,
    required this.imageUrl,
    required this.url,
    required this.isActive,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      url: json['url'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  factory Guide.fromMap(String id, Map<String, dynamic> map) {
    return Guide(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      category: map['category'] ?? '',
      type: map['type'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      url: map['url'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }
}
