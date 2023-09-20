import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart'; // https://stackoverflow.com/questions/26504074/adding-orelse-function-to-firstwhere-method#answer-66956466

import 'package:sync_launcher/models/dlc_info.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/retrievers/local/base_local_retriever.dart';

class LocalEpicGamesRetriever extends BaseLocalGameRetriever {
  LocalEpicGamesRetriever() : super(manifestLocation: 'C:\\ProgramData\\Epic\\EpicGamesLauncher\\Data\\Manifests');

  @override
  Future<List<GameInfo>> retrieve() async {
    final Iterable<File> manifests = await _getManifests();
    
    List<GameInfo> foundGames = List.empty(growable: true);
    List<DLCInfo> foundDLC = List.empty(growable: true);

    for (File manifest in manifests) {
      String contents = await manifest.readAsString();

      dynamic jsonContents = jsonDecode(contents); // Epic Games .ITEM manifest files are written in valid JSON.
      List<String> appCategories = List.from(jsonContents['AppCategories']);

      if (appCategories.contains('games')) {
        foundGames.add(GameInfo(
          title: jsonContents['DisplayName'] as String, 
          appId: jsonContents['CatalogItemId'] as String, 
          launchURL: _buildGameLaunchURL(mainGameCatalogNamespace: jsonContents['MainGameCatalogNamespace'], catalogItemId: jsonContents['CatalogItemId'], mainGameAppName: jsonContents['MainGameAppName']),
          description: '', // TODO: try to download it. If all fails, leave null. 
          imagePath: '', // TODO: try to download it. If all fails, leave null. 
          installSize: jsonContents['InstallSize'] as int, 
          version: jsonContents['AppVersionString'] as String
          ));
      } else if (appCategories.contains('addons')) {
        foundDLC.add(DLCInfo(
          title: jsonContents['DisplayName'] as String, 
          appId: jsonContents['CatalogItemId'] as String,
          parentAppId: jsonContents['MainGameCatalogItemId'] as String,
          imagePath: '', // TODO: try to download it. If all fails, leave null. 
          installSize: jsonContents['InstallSize'] as int
        ));
      } else { // Manifest doesn't belong to a game or DLC.
        // TODO: Log "Sync can't do anything with non-game or -DLC manifest files, AppCategories are $appCategories".
      }
    }

    return _matchDLCToGames(dlcInfo: foundDLC, gameInfo: foundGames);
  }

  /// Gets the manifest files.
  /// 
  /// Retrieves the manifest files for the installed apps.
  Future<Iterable<File>> _getManifests() async {
    final Directory manifestDirectory = Directory(super.manifestLocation);
    final Iterable<File> manifests = (await manifestDirectory.list().toList()).whereType<File>();

    return manifests;
  }

  /// Matches the DLC to their respective games.
  /// 
  /// Add DLC after all the games have been found to prevent possibility of trying to add DLC to a game 
  /// before the game's manifest file has been processed.
  List<GameInfo> _matchDLCToGames({required List<DLCInfo> dlcInfo, required List<GameInfo> gameInfo}){
    for (DLCInfo dlc in dlcInfo) {
      GameInfo? game = gameInfo.firstWhereOrNull((element) => element.appId == dlc.parentAppId);

      if (game == null){
        // TODO: log "Couldn't find base game with appId $dlc.parentAppId for DLC $dlc.title".

        continue;
      }

      game.dlc.add(dlc);
    }

    return gameInfo;
  }

  /// Builds the launch URL for the game.
  String _buildGameLaunchURL({required String mainGameCatalogNamespace, required String catalogItemId, required String mainGameAppName}){
    // TODO: Move these constants to be class properties.
    const String baseUrl = 'com.epicgames.launcher://apps/';
    const String separator = '%3A';
    const String launchOptions = '?action=launch&silent=true';

    return baseUrl + mainGameCatalogNamespace + separator + catalogItemId + separator + mainGameAppName + launchOptions;
  }
}