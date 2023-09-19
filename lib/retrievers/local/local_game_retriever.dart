import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/retrievers/local/base_local_retriever.dart';
import 'package:sync_launcher/retrievers/local/epic_games/local_epic_games_retriever.dart';

class LocalGameRetriever {
  List<String> connectedLaunchers = ["Epic Games"];
  Map<String, BaseLocalRetriever> retrievers = {
    "Epic Games":LocalEpicGamesRetriever("TODO: have this variable set in the constructor from own manifest file?")
  };

  Future<List<GameInfo>> retrieveGames() async {
    List<GameInfo> foundGames = List.empty(growable: true);

    for (String launcher in connectedLaunchers) {
      BaseLocalRetriever retriever = retrievers[launcher]!;

      foundGames.addAll(await retriever.retrieve());
    }

    return foundGames;
  }
}