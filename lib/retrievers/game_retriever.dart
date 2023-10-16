import 'dart:developer';

import 'package:sync_launcher/database/repositories/game_repository.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/retrievers/api/base_api_game_retriever.dart';
import 'package:sync_launcher/retrievers/local/base_local_game_retriever.dart';

class GameRetriever {
  final GameRepository _gameRepository = GameRepository();

  BaseAPIGameRetriever? apiRetriever;
  BaseLocalGameRetriever localRetriever;

  GameRetriever({this.apiRetriever, required this.localRetriever});

  Future<void> retrieveGames() async {
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