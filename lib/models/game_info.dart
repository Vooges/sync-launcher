import 'package:sync_launcher/models/dlc_info.dart';

class GameInfo {
  String title;
  String description;
  String launchURL;
  String? imagePath;
  String appId;
  String version;
  int installSize; // Size is in bytes
  List<DLCInfo> dlc;

  GameInfo({
    required this.title,
    required this.appId,
    required this.launchURL,
    this.imagePath,
    String? description,
    int? installSize,
    String? version,
    List<DLCInfo>? dlc
}) : description = description ?? 'Unknown',
    installSize = installSize ?? 0,
    version = version ?? "Unknown", 
    dlc = dlc ?? List.empty(growable: true);

    Map toJson(){
      return {
        'title': title,
        'description': description,
        'launchUrl': launchURL,
        'image_path': imagePath,
        'app_id': appId,
        'version': version,
        'install_size': installSize,
        'dlc': dlc
      };
    }
}