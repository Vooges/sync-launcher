import 'dart:developer';

import 'package:sync_launcher/database/repositories/game_repository.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/retrievers/api/base_api_game_retriever.dart';
import 'package:sync_launcher/retrievers/local/base_local_game_retriever.dart';
import 'package:sync_launcher/retrievers/metadata/online_metadata_retriever.dart';

class GameRetriever {
  final GameRepository _gameRepository = GameRepository();

  BaseAPIGameRetriever? apiRetriever;
  BaseLocalGameRetriever localRetriever;

  final OnlineMetadataRetriever _onlineMetadataRetriever = OnlineMetadataRetriever();

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

    try {
      List<GameInfo> locallyFoundGames = await localRetriever.retrieve();

      if (locallyFoundGames.isNotEmpty){
        if (foundGames.isEmpty) {
          foundGames.addAll(locallyFoundGames);
        } else {
          for (GameInfo game in locallyFoundGames) {
            GameInfo? foundGame = foundGames.where((element) => element.appId == game.appId).firstOrNull;

            if (foundGame == null){
              foundGames.add(game);
            } else {
              foundGame.gridImagePath = game.gridImagePath;
              foundGame.heroImagePath = game.heroImagePath;
              foundGame.iconImagePath = game.iconImagePath;
              foundGame.installSize = game.installSize;
              foundGame.description = game.description;
              foundGame.dlc = game.dlc;
            }
          }
        }
      }
    } catch (exception) {
      log(exception.toString());
    }

    await _insertIntoDatabase(gameList: foundGames);
    
    _onlineMetadataRetriever.retrieveMetadata();
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