import 'package:sync_launcher/models/dlc_info.dart';
import 'package:sync_launcher/models/launcher_info.dart';

class GameInfo {
  int id;
  String title;
  String? description;
  String launchURL;
  String? imagePath;
  String appId;
  String version;
  int installSize; // Size is in bytes
  List<DLCInfo> dlc;
  LauncherInfo launcherInfo;

  GameInfo({
    required this.title,
    required this.appId,
    required this.launchURL,
    required this.launcherInfo,
    this.imagePath,
    int? id,
    String? description,
    int? installSize,
    String? version,
    List<DLCInfo>? dlc
}) : id = id ?? 0,
    installSize = installSize ?? 0,
    version = version ?? 'Unknown', 
    dlc = dlc ?? List.empty(growable: true);

    GameInfo.fromMap({required Map<String, Object?> game, List<DLCInfo>? dlc}) :
      id = game['id'] as int,
      title = game['title'] as String,
      appId = game['app_id'] as String,
      imagePath = game['image_path'] as String?,
      launchURL = game['launch_url'] as String,
      launcherInfo = LauncherInfo(id: game['launcher_id'] as int, title: game['launcher_title'] as String, imagePath: game['launcher_image_path'] as String),
      description = game['description'] as String?,
      dlc = dlc ?? List.empty(growable: true),
      installSize = game['install_size'] as int,
      version = game['version'] as String;

    Map<String, Object?> toMap(){
      return {
        'id': id,
        'title': title,
        'description': description,
        'launch_url': launchURL,
        'image_path': imagePath,
        'app_id': appId,
        'version': version,
        'install_size': installSize,
        'dlc': dlc,
        'launcher': launcherInfo.toMap()
      };
    }
}