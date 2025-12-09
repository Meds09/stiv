class Category {
  final int id;
  final String name;
  final String emoji;


  const Category({
    required this.id,
    required this.name,
    required this.emoji,
   
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
     
    );
  }
}

