class LauncherInfo {
  String title;
  String imagePath;

  LauncherInfo({required this.title, required this.imagePath});

  Map toJson(){
    return {
      'title': title,
      'image_path': imagePath
    };
  }
}