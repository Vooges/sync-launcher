class LauncherInfo {
  int id;
  String title;
  String imagePath;

  LauncherInfo({
    required this.title, 
    required this.imagePath, 
    int? id
  }) : id = id ?? 0;

  LauncherInfo.fromMap({required Map<String, Object?> launcher}) :
    id = launcher['id'] as int,
    title = launcher['value'] as String,
    imagePath = launcher['image_path'] as String;

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'title': title,
      'image_path': imagePath
    };
  }
}