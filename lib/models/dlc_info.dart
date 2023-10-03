class DLCInfo {
  String title;
  String appId;
  String parentAppId;
  String? imagePath;
  int installSize; // Size is in bytes.

  DLCInfo({
    required this.title,
    required this.appId,
    required this.parentAppId,
    String? imagePath,
    int? installSize
  }) : installSize = installSize ?? 0;

  Map toJson(){
    return {
      'title': title,
      'app_id': appId,
      'parent_app_id': parentAppId,
      'image_path': imagePath,
      'install_size': installSize
    };
  }
}