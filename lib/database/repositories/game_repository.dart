import 'package:sync_launcher/database/repositories/base_repository.dart';
import 'package:sync_launcher/database/repositories/dlc_repository.dart';
import 'package:sync_launcher/database/repositories/launcher_repository.dart';
import 'package:sync_launcher/models/dlc_info.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';

class GameRepository extends BaseRepository{
  final DLCRepository _dlcRepository = DLCRepository();
  final LauncherRepository _launcherRepository = LauncherRepository();
  final int _limit = 100;

  Future<List<ReducedGameInfo>> getReducedGames({int? offset}) async {
    offset = offset ?? 0;

    String query = '''
      SELECT 
        g.id, 
        g.title, 
        g.grid_image_path, 
        g.install_size > 0 as installed,
        l.id as launcher_id, 
        l.title as launcher_title, 
        l.image_path as launcher_image_path 
      FROM games g 
      INNER JOIN launchers l 
      ON g.launcher_id = l.id
      LIMIT ? OFFSET ?;
    ''';

    List<Map<String, Object?>> results = await super.sqliteHandler.selectRaw(query: query, parameters: [_limit, offset]);

    return results.map((e) => ReducedGameInfo.fromMap(game: e)).toList();
  }

  Future<GameInfo> getSingleGameInfo({required int id}) async {
    String query = '''
      SELECT 
        g.id, 
        g.title, 
        g.app_id, 
        g.launch_url, 
        g.grid_image_path,
        g.icon_image_path,
        g.hero_image_path,
        l.id as launcher_id, 
        l.title as launcher_title, 
        l.image_path as launcher_image_path, 
        l.install_path as launcher_install_path,
        g.description, 
        g.install_size, 
        g.version 
      FROM games g 
      INNER JOIN launchers l 
      ON l.id = g.launcher_id 
      WHERE g.id = ?;
    ''';

    Map<String, Object?> game = (await super.sqliteHandler.selectRaw(query: query, parameters: [id]))[0];

    List<DLCInfo> dlc = await _dlcRepository.getDLCInfoForGame(gameId: game['id'] as int);

    return GameInfo.fromMap(game: game, dlc: dlc);
  }

  Future<int> insert({required GameInfo game}) async {
    Map<String, Object?> gameMap = game.toMap();
    LauncherInfo launcher = LauncherInfo.fromMap(launcher: gameMap['launcher'] as Map<String, Object?>);
    List<DLCInfo> dlc = gameMap['dlc'] as List<DLCInfo>;

    // TODO: Check if it is possible to map complex entities to the essential values needed for this insert statement.
    gameMap.remove('dlc');
    gameMap.remove('launcher');

    int launcherId = (await _launcherRepository.getLauncherByName(name: launcher.title))!.id;
    gameMap['launcher_id'] = launcherId;

    // Prevents primary key constraint failure.
    gameMap['id'] = null;

    int gameId = await super.sqliteHandler.insert(table: 'games', values: gameMap);

    if (dlc.isNotEmpty){
      await _dlcRepository.insertMultiple(dlcList: dlc);
    }

    return gameId;
  }

  // TODO: optimize this by using a single query instead.
  Future<List<int>> insertMultiple({required List<GameInfo> gameList}) async {
    List<int> ids = List.empty(growable: true);

    for (GameInfo game in gameList) {
      ids.add(await insert(game: game));
    }

    return ids;
  }

  Future<int> deleteAllForLauncher({required int id}) async{
    String query = '''
      DELETE FROM games 
      WHERE launcher_id = ?;
    ''';

    return await super.sqliteHandler.deleteRaw(query: query, parameters: [id]);
  }
}