import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/retrievers/base_api_game_retriever.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

import 'package:sync_launcher/models/game_info.dart';

class APISteamRetriever extends BaseAPIGameRetriever {
  APISteamRetriever({required super.userId});

  @override
  Future<List<GameInfo>> retrieve() async {
    final response = await http.get(Uri.parse(
        "https://steamcommunity.com/profiles/$userId/games?tab=all&xml=1"));

    if (response.statusCode == 200) {
      final xmlDoc = xml.XmlDocument.parse(response.body);

      final games = xmlDoc.findAllElements('game');
      final gameInfoList = <GameInfo>[];

      for (final game in games) {
        final appId = game.findElements('appID').first.innerText;
        final title = game.findElements('name').first.innerText;
        final logo = game.findElements('logo').first.innerText;
        final storeLink = game.findElements('storeLink').first.innerText;
        final hoursOnRecord = game.findElements('hoursOnRecord').isNotEmpty
            ? double.parse(game.findElements('hoursOnRecord').first.innerText)
            : 0.0;

        final gameInfo = GameInfo(
          title: title,
          appId: appId,
          launchURL: storeLink,
          launcherInfo: LauncherInfo(
            title:  'Steam',
            imagePath: 'assets/launchers/steam/logo.svg',
          ),
          imagePath: logo,
          version: 'Unknown',
          // Add version if available.
          installSize: 0,
          // Add install size if available.
          dlc: [], // Add DLC info if available.
        );

        gameInfoList.add(gameInfo);
      }

      return gameInfoList;
    } else {
      throw Exception('Failed to load game data');
    }
  }
}
