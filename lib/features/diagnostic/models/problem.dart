class Problem {
  final int id;
  final String title;
  final String description;

  // Para UI
  final Set<int> appliedCategoryIds;


  const Problem({
    required this.id,
    required this.title,
    required this.description,
    required this.appliedCategoryIds,
 
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      appliedCategoryIds:
          Set<int>.from(json['appliedCategoryIds'] ?? []),
   
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'appliedCategoryIds': appliedCategoryIds.toList(),
    };
  }
}

