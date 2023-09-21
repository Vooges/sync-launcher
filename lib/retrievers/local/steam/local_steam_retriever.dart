import 'dart:convert';
import 'dart:io';

import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/retrievers/local/base_local_retriever.dart';

class LocalSteamRetriever extends BaseLocalGameRetriever {
  LocalSteamRetriever() : super(manifestLocation: 'C:\\Program Files (x86)\\Steam\\steamapps');

  @override
  Future<List<GameInfo>> retrieve() async {
    final Iterable<File> manifests = await _getManifests();

    final List<GameInfo> foundGames = List.empty(growable: true);

    for (File manifest in manifests) {
      String acfContents = await manifest.readAsString();

      // TODO: Check if other data is stored elsewhere.
      dynamic jsonContents = _acfToJson(acfContents);

      // TODO: Check if app is a game.
      if (jsonContents['appid'] == '491950' || jsonContents['appid'] == '203770') {
        foundGames.add(GameInfo(
          title: jsonContents['name'] as String, 
          appId: jsonContents['appid'] as String, 
          launchURL: _buildGameLaunchURL(appId: jsonContents['appid'] as String), 
          launcherInfo: LauncherInfo(
            title: 'Steam', 
            imagePath: 'assets/images/launchers/steam/logo.svg'
          ),
          imagePath: null,
          description: null,
          installSize: int.parse(jsonContents['SizeOnDisk'] as String),
          version: jsonContents['buildid'] as String,
          dlc: null
        ));
      } else {
        // TODO: Log "App with appId $appId is not a game."
      }
    }

    return foundGames;
  }

  /// Gets the manifest files.
  /// 
  /// Retrieves the manifest files for the installed apps.
  Future<Iterable<File>> _getManifests() async {
    final Directory manifestDirectory = Directory(super.manifestLocation);
    final Iterable<File> manifests = (await manifestDirectory.list().toList())
      .whereType<File>().where((element) => element.path.contains('appmanifest_'));

    return manifests;
  }

  /// Turns the provided acf string to valid JSON.
  dynamic _acfToJson(String acf){
    acf = acf.replaceAll(RegExp(r'(\r\n|\r|\n)'), ',');
    acf = acf.replaceAll('	', '');
    acf = acf.replaceAll('""','": "');
    acf = acf.replaceAll('{,', '{');
    acf = acf.replaceFirst('"AppState",', '');
    acf = acf.replaceAll('",{', '":{');
    acf = acf.replaceAll(',}', '}');
    acf = acf.replaceAll('},}', '}}');
    acf = acf.substring(0, acf.length - 1);

    return jsonDecode(acf);
  }

  /// Builds the launch URL for the game.
  String _buildGameLaunchURL({required String appId}){
    // TODO: Move these constants to be class properties.
    const String baseUrl = 'steam://rungameid/';

    return baseUrl + appId;
  }
}