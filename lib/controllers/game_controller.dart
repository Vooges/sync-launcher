import 'package:sync_launcher/database/repositories/game_repository.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';

class GameController {
    final GameRepository _gameRepository = GameRepository();

    Future<List<ReducedGameInfo>> index({
      String? search,
      bool? installed,
      List<int>? launcherIds,
      List<int>? categoryIds,
      int? offset
    }) async {
      // TODO: implement filters.
      return await _gameRepository.getReducedGames(offset: offset);
    }

    Future<GameInfo> get({required int id}) async {
      return await _gameRepository.getSingleGameInfo(id: id);
    }

    Future<void> insert({required GameInfo game}) async {
      await _gameRepository.insert(game: game);
    }

    Future<void> insertMultiple({required List<GameInfo> gameList}) async {
      await _gameRepository.insertMultiple(gameList: gameList);
    }
}