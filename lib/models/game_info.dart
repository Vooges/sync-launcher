import 'package:sync_launcher/models/dlc_info.dart';

class GameInfo {
  String title;
  String? imagePath;
  String appId;
  String version;
  int installSize; // Size is in bytes
  List<DLCInfo> dlc;

  GameInfo({
    required this.title,
    required this.appId,
    this.imagePath,
    int? installSize,
    String? version,
    List<DLCInfo>? dlc
}) : installSize = installSize ?? 0,
    version = version ?? "Unknown", 
    dlc = dlc ?? List.empty(growable: true);
}