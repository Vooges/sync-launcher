class Category {
  final int id;
  final String value;

  Category({
    required this.id,
    required this.value
  });

  Category.fromMap({required Map<String, Object?> map}): 
    id = map['id'] as int,
    value = map['value'] as String;

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'value': value
    };
  }
}