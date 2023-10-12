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

  /// Retrieves all games for the connected launchers and adds the to the database.
  Future<void> bootstrap() async {
    final connectedLaunchers = ['Epic Games', 'Steam'];
    final retrievers = _getGameRetrievers();

    final List<GameInfo> foundGames = List.empty(growable: true);
    for (String launcher in connectedLaunchers) {
      GameRetriever? retriever = retrievers[launcher];
      if(retriever == null) continue;

      foundGames.addAll(await retriever.retrieveGames());
    }

    await _insertIntoDatabase(gameList: foundGames);
  }

  Map<String, GameRetriever> _getGameRetrievers() {
    Map<String, GameRetriever> retrievers = {};

    try {
      retrievers['Epic Games'] = GameRetriever(
        localRetriever: LocalEpicGamesRetriever(
          launcherBasePath: _getEpicBasePath(),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      retrievers['Steam'] = GameRetriever(
        apiRetriever: APISteamRetriever(userId: '76561198440106475'),
        localRetriever: LocalSteamRetriever(
          launcherBasePath: _getSteamBasePath(),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return retrievers;
  }

  String _getSteamBasePath() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return "C:\\Program Files (x86)\\Steam";
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return "~/.steam/steam/";
    }

    throw Exception('steam not supported on $defaultTargetPlatform');
  }

  String _getEpicBasePath() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return "C:\\ProgramData\\Epic\\EpicGamesLauncher\\Data\\Manifests";
    }

    throw Exception('epic not supported on $defaultTargetPlatform');
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
