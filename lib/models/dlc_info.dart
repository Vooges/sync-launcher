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
}