class Category {
  final int id;
  final String description;

  Category({
    required this.id,
    required this.description
  });

  Category.fromMap(Map<String, dynamic> map):
    id = map['id'] as int,
    description = map['description'] as String;

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'description': description
    };
  }
}