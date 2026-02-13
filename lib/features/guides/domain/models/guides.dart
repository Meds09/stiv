class Guide {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String type;
  final String imageUrl;
  final String url;
  final bool isActive;
  final String description;
  final List<String> steps;
  final List<String> tips;
  final String estimatedTime;

  Guide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.type,
    required this.imageUrl,
    required this.url,
    required this.isActive,
    this.description = '',
    this.steps = const [],
    this.tips = const [],
    this.estimatedTime = '',
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
      description: json['description'] ?? '',
      steps: json['steps'] != null ? List<String>.from(json['steps']) : [],
      tips: json['tips'] != null ? List<String>.from(json['tips']) : [],
      estimatedTime: json['estimatedTime'] ?? '',
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
      description: map['description'] ?? '',
      steps: map['steps'] != null ? List<String>.from(map['steps']) : [],
      tips: map['tips'] != null ? List<String>.from(map['tips']) : [],
      estimatedTime: map['estimatedTime'] ?? '',
    );
  }
}
