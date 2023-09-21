import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

class LocalSteamMetadataRetriever {
  final String installPath;
  final String userId = '479840747';

  LocalSteamMetadataRetriever({required this.installPath});

  /// Attempts to get the description for the app.
  /// 
  /// If the cache file for the app cannot be found, null is returned. It also returns null if the descriptions object is missing.
  Future<String?> getDescription({required String appId}) async {
    final String fullPath = '$installPath\\userdata\\$userId\\config\\librarycache';

    final Directory libraryCacheDirectory = Directory(fullPath);
    final File? appCache = (await libraryCacheDirectory.list().toList()).whereType<File>().firstWhereOrNull((element) => element.path.contains(appId));

    if (appCache == null) return null; // Cache has not been found.

    dynamic jsonContents = jsonDecode(await appCache.readAsString());

    int key = 0;

    for (dynamic element in jsonContents as List<dynamic>) {
      if (element[0] == 'descriptions') key = jsonContents.indexOf(element);
    }

    return (((jsonContents[key])[1])['data'])['strFullDescription'];
  }

  Future<String?> getImagePath({required String appId}) async {
    // TODO: this.

    return '';
  }
}