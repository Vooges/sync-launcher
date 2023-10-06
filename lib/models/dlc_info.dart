class DLCInfo {
  int id;
  String title;
  String appId;
  int parentId;
  String parentAppId;
  String? imagePath;
  int installSize; // Size is in bytes.

  DLCInfo({
    required this.title,
    required this.appId,
    required this.parentAppId,
    int? id,
    int? parentId,
    String? imagePath,
    int? installSize
  }) : id = id ?? 0,
    parentId = parentId ?? 0, 
    installSize = installSize ?? 0;

  DLCInfo.fromMap({required Map<String, Object?> dlc}) :
  id = dlc['id'] as int,
  title = dlc['title'] as String,
  appId = dlc['app_id'] as String,
  parentId = dlc['parent_id'] as int,
  parentAppId = dlc['parent_app_id'] as String,
  imagePath = dlc['image_path'] as String?,
  installSize = dlc['installSize'] as int;

  Map toJson(){
    return {
      'id': id,
      'title': title,
      'app_id': appId,
      'parent_id': parentId,
      'parent_app_id': parentAppId,
      'image_path': imagePath,
      'install_size': installSize
    };
  }
}