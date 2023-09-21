import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/retrievers/local/base_local_retriever.dart';
import 'package:sync_launcher/retrievers/local/epic_games/local_epic_games_retriever.dart';
import 'package:sync_launcher/retrievers/local/steam/local_steam_retriever.dart';

class GameRetriever {
  List<String> connectedLaunchers = ['Epic Games', 'Steam'];
  Map<String, BaseLocalGameRetriever> retrievers = {
    'Epic Games': LocalEpicGamesRetriever(),
    'Steam': LocalSteamRetriever()
  };

  /// Retrieves all games for the connected launchers.
  Future<List<GameInfo>> retrieveGames() async {
    List<GameInfo> foundGames = List.empty(growable: true);

    for (String launcher in connectedLaunchers) {
      BaseLocalGameRetriever retriever = retrievers[launcher]!;

      foundGames.addAll(await retriever.retrieve());
    }

    return foundGames;
  }
}