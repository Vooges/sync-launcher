import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sync_launcher/database/repositories/game_repository.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/retrievers/api/steam/api_steam_retriever.dart';
import 'package:sync_launcher/retrievers/game_retriever.dart';
import 'package:sync_launcher/retrievers/local/epic_games/local_epic_games_retriever.dart';
import 'package:sync_launcher/retrievers/local/steam/local_steam_retriever.dart';
import 'package:sync_launcher/state/settings_state.dart';

class GameBootstrapper {
  final GameRepository _gameRepository = GameRepository();

  /// Retrieves all games for the connected launchers and adds the to the database.
  Future<void> bootstrap(BuildContext context) async {
    final List<ReducedGameInfo> results = await _gameRepository.getReducedGames();

    // Skip bootstrapping if the database is not empty. The bootstrapper is eventually going 
    // to be removed entirely and game retrieval is done on a per-launcher basis from the settings.
    if (results.isNotEmpty){
      //return;
    }

    final connectedLaunchers = ['Epic Games', 'Steam'];
    final retrievers = _getGameRetrievers(context);

    final List<GameInfo> foundGames = List.empty(growable: true);
    for (String launcher in connectedLaunchers) {
      GameRetriever? retriever = retrievers[launcher];
      if (retriever == null) continue;

      foundGames.addAll(await retriever.retrieveGames());
    }

    await _insertIntoDatabase(gameList: foundGames);
  }

  Map<String, GameRetriever> _getGameRetrievers(BuildContext context) {
    final settingsState = context.read<SettingsState>();
    Map<String, GameRetriever> retrievers = {};

    final epicBasePath = settingsState.epicBasePath;
    if(epicBasePath != null) {
      retrievers['Epic Games'] = GameRetriever(
        localRetriever: LocalEpicGamesRetriever(
          launcherBasePath: epicBasePath,
        ),
      );
    }

    final steamBasePath = settingsState.steamBasePath;
    if(steamBasePath != null) {
      retrievers['Steam'] = GameRetriever(
        apiRetriever: APISteamRetriever(userId: '76561198440106475'), // TODO: remove this hardcoded userId and use the actual user's userId.
        localRetriever: LocalSteamRetriever(
          launcherBasePath: steamBasePath,
        ),
      );
    }

    return retrievers;
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
