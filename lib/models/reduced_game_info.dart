import 'package:sync_launcher/models/launcher_info.dart';

class ReducedGameInfo {
  int id;
  String title;
  String? imagePath;
  LauncherInfo launcherInfo;
  bool installed;

  ReducedGameInfo({
    required this.id, 
    required this.title,
    required this.launcherInfo, 
    this.imagePath,
    bool? installed
  }) : installed = installed ?? false;

  ReducedGameInfo.fromMap({required Map<String, Object?> game}) :
    id = game['id'] as int,
    title = game['title'] as String,
    launcherInfo = LauncherInfo(
      id: game['launcher_id'] as int,
      title: game['launcher_title'] as String, 
      imagePath: game['launcher_image_path'] as String
    ),
    imagePath = game['image_path'] as String?,
    installed = game['installed'] as int == 1;

    Map<String, Object?> toMap(){
      return {
        'id': id,
        'title': title,
        'image_path': imagePath,
        'launcher': launcherInfo.toMap(),
        'installed': installed
      };
    }
}