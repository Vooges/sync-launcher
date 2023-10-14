import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/retrievers/api/base_api_game_retriever.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

import 'package:sync_launcher/models/game_info.dart';

class APISteamRetriever extends BaseAPIGameRetriever {
  APISteamRetriever({required super.userId});

  @override
  Future<List<GameInfo>> retrieve() async {
    // TODO: Check if app is a game or DLC.
    final response = await http.get(Uri.parse(
        "https://steamcommunity.com/profiles/$userId/games?tab=all&xml=1"));

    if (response.statusCode == 200) {
      final xmlDoc = xml.XmlDocument.parse(response.body);

      // Steam returns a 200 aswell if the user can't be found. The response given in that case contains a response element with the error element inside.
      final responseElement = xmlDoc.findElements('response').firstOrNull;
      if (responseElement != null) {
        throw Exception(responseElement.findElements('error').firstOrNull ?? 'Unable to get data for user $userId');
      }

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
          iconImagePath: logo, // TODO: find the actual logo.
          gridImagePath: logo, // TODO: find the actual grid image.
          heroImagePath: logo, // TODO: find the actual hero image.
          version: 'Unknown', // TODO: Add version if available.
          installSize: 0, // TODO: Add install size if available.
          dlc: [], // TODO: Add DLC info if available.
        );

        gameInfoList.add(gameInfo);
      }

      return gameInfoList;
    } else {
      throw Exception('Failed to load game data');
    }
  }
}
