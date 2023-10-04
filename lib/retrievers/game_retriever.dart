import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/retrievers/base_game_retriever.dart';

import 'platforms/epic_games/local_epic_games_retriever.dart';
import 'platforms/steam/local_steam_retriever.dart';

class GameRetriever {
  List<String> connectedLaunchers = ['Epic Games', 'Steam'];
  Map<String, BaseGameRetriever> retrievers = {
    'Epic Games': LocalEpicGamesRetriever(),
    'Steam': LocalSteamRetriever()
  };

  /// Retrieves all games for the connected launchers.
  Future<List<GameInfo>> retrieveGames() async {
    List<GameInfo> foundGames = List.empty(growable: true);

    for (String launcher in connectedLaunchers) {
      BaseGameRetriever retriever = retrievers[launcher]!;

      foundGames.addAll(await retriever.retrieve());
    }

    return foundGames;
  }
}