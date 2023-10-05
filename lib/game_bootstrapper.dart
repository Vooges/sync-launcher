import 'package:sync_launcher/retrievers/api/steam/api_steam_retriever.dart';
import 'package:sync_launcher/retrievers/game_retriever.dart';
import 'package:sync_launcher/retrievers/local/steam/local_steam_retriever.dart';

import 'retrievers/local/epic_games/local_epic_games_retriever.dart';

class GameBootstrapper {
  List<String> connectedLaunchers = ['Epic Games', 'Steam'];
  Map<String, GameRetriever> retrievers = {
    'Epic Games': GameRetriever(localRetriever: LocalEpicGamesRetriever()),
    'Steam': GameRetriever(apiRetriever: APISteamRetriever(userId: ''), localRetriever: LocalSteamRetriever())
  };

  /// Retrieves all games for the connected launchers.
  Future<void> bootstrap() async {
    for (String launcher in connectedLaunchers) {
      GameRetriever retriever = retrievers[launcher]!;

      retriever.retrieveGames();
    }
  }
}