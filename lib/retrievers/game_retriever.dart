import 'dart:developer';

import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/retrievers/api/base_api_game_retriever.dart';
import 'package:sync_launcher/retrievers/local/base_local_game_retriever.dart';

class GameRetriever {
  BaseAPIGameRetriever? apiRetriever;
  BaseLocalGameRetriever localRetriever;

  GameRetriever({this.apiRetriever, required this.localRetriever});

  Future<List<GameInfo>> retrieveGames() async {
    List<GameInfo> foundGames = List.empty(growable: true);

    if (apiRetriever != null){
      try {
        foundGames.addAll(await apiRetriever!.retrieve());
      } catch (exception){
        log(exception.toString());
      }
    }

    if (foundGames.isEmpty){
      try {
        foundGames.addAll(await localRetriever.retrieve());
      } catch (exception) {
        log(exception.toString());
      }
    }

    return foundGames;
  }
}