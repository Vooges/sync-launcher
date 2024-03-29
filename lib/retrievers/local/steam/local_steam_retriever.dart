import 'dart:io';

import 'package:sync_launcher/helpers/acf_converter.dart';
import 'package:sync_launcher/models/dlc_info.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/retrievers/local/base_local_game_retriever.dart';
import 'package:sync_launcher/retrievers/metadata/steam/local_steam_metadata_retriever.dart';

class LocalSteamRetriever extends BaseLocalGameRetriever {
  static const baseURL = 'steam://rungameid/';

  late final LocalSteamMetadataRetriever metadataRetriever;

  LocalSteamRetriever({required super.launcherBasePath, required String steam32Id}) {
    metadataRetriever = LocalSteamMetadataRetriever(steamBasePath: launcherBasePath, steam32Id: steam32Id);
  }

  @override
  Future<List<GameInfo>> retrieve() async {
    final Iterable<File> manifests = await _getManifests();

    final List<GameInfo> foundGames = List.empty(growable: true);

    for (File manifest in manifests) {
      String acfContents = await manifest.readAsString();

      dynamic jsonContents = ACFConverter.acfToJson(acfContents);

      foundGames.add(GameInfo(
        title: jsonContents['name'] as String, 
        appId: jsonContents['appid'] as String, 
        launchURL: _buildGameLaunchURL(appId: jsonContents['appid'] as String), 
        launcherInfo: LauncherInfo(
          title: 'Steam', 
          imagePath: 'assets/images/launchers/steam/logo.svg'
        ),
        iconImagePath: metadataRetriever.getIconImagePath(appId: jsonContents['appid'] as String),
        gridImagePath: metadataRetriever.getGridImagePath(appId: jsonContents['appid'] as String),
        heroImagePath: metadataRetriever.getHeroImagePath(appId: jsonContents['appid'] as String),
        description: await metadataRetriever.getDescription(appId: jsonContents['appid'] as String),
        installSize: int.parse(jsonContents['SizeOnDisk'] as String),
        version: jsonContents['buildid'] as String,
        dlc: _getDLCInfo(
          installedDepots: jsonContents['InstalledDepots'] as Map<String, dynamic>, 
          parentAppId: jsonContents['appid'] as String
        )
      ));
    }

    return foundGames;
  }

  /// Gets the manifest files.
  /// 
  /// Retrieves the manifest files for the installed apps.
  Future<Iterable<File>> _getManifests() async {
    final Directory manifestDirectory = Directory('${super.launcherBasePath}/steamapps');
    final Iterable<File> manifests = (await manifestDirectory.list().toList())
      .whereType<File>().where((element) => element.path.contains('appmanifest_'));

    return manifests;
  }

  /// Finds the dlc for the game.
  List<DLCInfo> _getDLCInfo({required Map<String, dynamic> installedDepots, required String parentAppId}){
    List<DLCInfo> foundDLC = List.empty(growable: true);

    for (dynamic installedDepot in installedDepots.values) {
      if (installedDepot.containsKey('dlcappid')){
        foundDLC.add(DLCInfo(
          title: 'Unknown', // TODO: find this out via the Steam API, or find a way to get this locally (preferred).
          appId: installedDepot['dlcappid'] as String, 
          parentAppId: parentAppId,
          imagePath: metadataRetriever.getHeaderImagePath(appId: installedDepot['dlcappid'] as String)
        ));
      }
    }

    return foundDLC;
  }

  /// Builds the launch URL for the game.
  String _buildGameLaunchURL({required String appId}){
    return LocalSteamRetriever.baseURL + appId;
  }
}