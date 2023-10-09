import 'dart:developer';

import 'package:sync_launcher/database/repositories/game_repository.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/retrievers/api/steam/api_steam_retriever.dart';
import 'package:sync_launcher/retrievers/game_retriever.dart';
import 'package:sync_launcher/retrievers/local/epic_games/local_epic_games_retriever.dart';
import 'package:sync_launcher/retrievers/local/steam/local_steam_retriever.dart';

class GameBootstrapper {
  List<String> connectedLaunchers = ['Epic Games', 'Steam'];
  Map<String, GameRetriever> retrievers = {
    'Epic Games': GameRetriever(localRetriever: LocalEpicGamesRetriever()),
    'Steam': GameRetriever(apiRetriever: APISteamRetriever(userId: '76561198440106475'), localRetriever: LocalSteamRetriever())
  };

  final GameRepository _gameRepository = GameRepository();

  /// Retrieves all games for the connected launchers.
  Future<void> bootstrap() async {
    final List<GameInfo> foundGames = List.empty(growable: true);

    for (String launcher in connectedLaunchers) {
      GameRetriever retriever = retrievers[launcher]!;

      foundGames.addAll(await retriever.retrieveGames());
    }

    try {
      _gameRepository.insertMultiple(gameList: foundGames);
    } catch (exception){
      log(exception.toString());
    }
  }
}