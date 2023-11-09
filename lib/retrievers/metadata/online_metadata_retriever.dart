import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:sync_launcher/database/repositories/game_repository.dart';
import 'package:sync_launcher/database/repositories/launcher_repository.dart';
import 'package:sync_launcher/models/dlc_info.dart';
import 'package:sync_launcher/models/game_info.dart';

import 'package:http/http.dart' as http;

class OnlineMetadataRetriever {
  final String _serverUrl = 'localhost:8080';
  final String _steamEndpoint = '/steam';

  final GameRepository _gameRepository = GameRepository();
  final LauncherRepository _launcherRepository = LauncherRepository();

  Future<void> retrieveMetadata() async {
    List<GameInfo> games = await _getGamesWithMissingMetadata();

    while (games.isNotEmpty){
      List<GameInfo> retrieved = await _getMetadataFromServer(games: games);

      for (GameInfo element in retrieved) {
        games.removeWhere((game) => game.appId == element.appId && game.launcherInfo.id == element.launcherInfo.id);
      }

      await Future.delayed(const Duration(minutes: 2));
    }
  }

  Future<List<GameInfo>> _getGamesWithMissingMetadata() async {
    return await _gameRepository.getGamesWithMissingMetadata();
  }
  
  Future<List<GameInfo>> _getMetadataFromServer({required List<GameInfo> games}) async {
    List<String> steamAppIds = games.where((element) => element.launcherInfo.title == 'Steam').map((e) => e.appId).toList();

    List<GameInfo> foundGames = [];

    foundGames.addAll(await _getSteamMetadataFromServer(appIds: steamAppIds));

    await _gameRepository.updateMultiple(gameList: foundGames);

    return foundGames;
  }

  Future<List<GameInfo>> _getSteamMetadataFromServer({required List<String> appIds}) async {
    final Map<String, dynamic> queryParameters = {
      'app_ids': appIds
    };

    final Uri uri = Uri.http(_serverUrl, _steamEndpoint, queryParameters);

    final http.Response response = await http.get(uri);

    final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

    List<GameInfo> foundGames = [];

    for (dynamic element in body) {
      List<dynamic> dlc = element['dlc'] as List<dynamic>;
      List<DLCInfo> dlcInfo = dlc.map((e) => DLCInfo.fromMap(dlc: e)).toList();

      int launcherId = (await _launcherRepository.getLauncherByName(name: 'Steam'))!.id;

      element['launcher_id'] = launcherId;
      element['launcher_title'] = 'Steam';
      element['launcher_image_path'] = '';

      int? gameId = await _gameRepository.getGameIdByAppId(appId: element['app_id'] as String, launcherId: launcherId);

      if (gameId != null){
        GameInfo original = await _gameRepository.getSingleGameInfo(id: gameId);
        List<DLCInfo> ownedDLC = dlcInfo.where((element) => original.dlc.firstWhereOrNull((dlc) => dlc.appId == element.appId) != null).toList();

        foundGames.add(GameInfo.fromMap(game: element, dlc: ownedDLC));
      }
    }

    return foundGames;
  }
}