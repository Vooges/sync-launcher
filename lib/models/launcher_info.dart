class LauncherInfo {
  int id;
  String title;
  String imagePath;

  LauncherInfo({
    required this.title, 
    required this.imagePath, 
    int? id
  }) : id = id ?? 0;

  Map toJson(){
    return {
      'id': id,
      'title': title,
      'image_path': imagePath
    };
  }
}