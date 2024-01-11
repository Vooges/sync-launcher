class Installed {
  final bool value;
  final String description;

  Installed({
    required this.value,
    required this.description
  });

  Map<String, Object?> toMap(){
    return {
      'value': value,
      'description': description
    };
  }
}