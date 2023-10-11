import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sync_launcher/database/repositories/game_repository.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/retrievers/api/steam/api_steam_retriever.dart';
import 'package:sync_launcher/retrievers/game_retriever.dart';
import 'package:sync_launcher/retrievers/local/epic_games/local_epic_games_retriever.dart';
import 'package:sync_launcher/retrievers/local/steam/local_steam_retriever.dart';

class GameBootstrapper {
  final GameRepository _gameRepository = GameRepository();

  String getSteamBasePath() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return "C:\\Program Files (x86)\\Steam";
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return "~/.steam/steam/";
    }

    throw Exception("platform not supported");
  }

  /// Retrieves all games for the connected launchers and adds the to the database.
  Future<void> bootstrap() async {
    List<String> connectedLaunchers = ['Epic Games', 'Steam'];
    Map<String, GameRetriever> retrievers = {
      'Epic Games': GameRetriever(localRetriever: LocalEpicGamesRetriever()),
      'Steam': GameRetriever(
        apiRetriever: APISteamRetriever(userId: '76561198440106475'),
        localRetriever: LocalSteamRetriever(steamBasePath: getSteamBasePath()),
      )
    };

    final List<GameInfo> foundGames = List.empty(growable: true);
    for (String launcher in connectedLaunchers) {
      GameRetriever retriever = retrievers[launcher]!;
      foundGames.addAll(await retriever.retrieveGames());
    }

    await _insertIntoDatabase(gameList: foundGames);
  }

  /// Inserts the provided list of games into the database.
  Future<void> _insertIntoDatabase({required List<GameInfo> gameList}) async {
    try {
      _gameRepository.insertMultiple(gameList: gameList);
    } catch (exception) {
      log(exception.toString());
    }
  }
}
