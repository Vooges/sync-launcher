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
  }) async {
    return await _gameRepository.getReducedGames(
      search: search,
      installed: installed,
      launcherIds: launcherIds,
      categoryIds: categoryIds
    );
  }

  Future<GameInfo> get({required int id}) async {
    return await _gameRepository.getSingleGameInfo(id: id);
  }
}