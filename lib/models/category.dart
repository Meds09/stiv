class Category {
  final int id;
  final String name;
  final String emoji;
  final String description;

  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
      description: json['description'],
    );
  }
}

final List<Category> categoriesData = [
  Category(id: 1, name: 'Camaras', emoji: '📷', description: 'Categoría de cámaras'),
  Category(id: 2, name: 'Control de acceso', emoji: '🔐', description: 'Categoría de control de acceso'),
  Category(id: 3, name: 'Soporte Electrico', emoji: '⚡', description: 'Categoría de soporte eléctrico'),
  Category(id: 4, name: 'Redes', emoji: '🌐', description: 'Categoría de redes'),
];
