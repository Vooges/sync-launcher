import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

class LocalSteamMetadataRetriever {
  final String steamBasePath;
  final String userId = '479840747';

  LocalSteamMetadataRetriever({required this.steamBasePath});

  /// Attempts to get the description for the app.
  /// 
  /// If the cache file for the app cannot be found, null is returned. 
  /// It also returns null if the descriptions object is missing.
  Future<String?> getDescription({required String appId}) async {
    final String fullPath = '$steamBasePath/userdata/$userId/config/librarycache';

    final Directory libraryCacheDirectory = Directory(fullPath);
    final File? appCache = (await libraryCacheDirectory.list().toList()).whereType<File>()
      .firstWhereOrNull((element) => element.path.contains(appId));

    if (appCache == null) return null; // Cache has not been found.

    dynamic jsonContents = jsonDecode(await appCache.readAsString());

    int key = -1;

    for (dynamic element in jsonContents as List<dynamic>) {
      if (element[0] == 'descriptions') key = jsonContents.indexOf(element);
    }

    if (key == -1) return null; // Could not find descriptions object.

    return (((jsonContents[key])[1])['data'])['strFullDescription']; // Description is in the language set in Steam.
  }

  /// Builds the icon image path.
  String getIconImagePath({required String appId}) {
    return '$steamBasePath/appcache/librarycache/${appId}_icon.jpg';
  }

  /// Builds the grid image path.
  String getGridImagePath({required String appId}) {
    return '$steamBasePath/appcache/librarycache/${appId}_library_600x900.jpg';
  }

  /// Builds the hero image path.
  String getHeroImagePath({required String appId}) {
    return '$steamBasePath/appcache/librarycache/${appId}_library_hero.jpg';
  }

  /// Builds the header image path.
  String getHeaderImagePath({required String appId}) {
    return '$steamBasePath/appcache/librarycache/${appId}_header.jpg';
  }
}