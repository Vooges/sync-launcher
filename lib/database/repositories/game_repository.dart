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

  Future<int?> getGameIdByAppId({required String appId, required int launcherId}) async {
    const String query = '''
      SELECT id 
      FROM games
      WHERE app_id LIKE ?
      AND launcher_id = ?;
    ''';

    final List<Object?> parameters = [appId, launcherId];

    final Map<String, Object?>? result = (await super.sqliteHandler.selectRaw(query: query, parameters: parameters)).firstOrNull;
    final int? gameId = (result == null) ? null : result['id'] as int;

    return gameId;
  }

  Future<int?> getGameIdByTitle({required String title, required int launcherId}) async {
    const String query = '''
      SELECT id 
      FROM games
      WHERE title LIKE ?
      AND launcher_id = ?;
    ''';

    final List<Object?> parameters = [title, launcherId];

    final Map<String, Object?>? result = (await super.sqliteHandler.selectRaw(query: query, parameters: parameters)).firstOrNull;
    final int? gameId = (result == null) ? null : result['id'] as int;

    return gameId;
  }

  Future<List<GameInfo>> getGamesWithMissingMetadata() async {
    const String query = '''
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
      WHERE g.description IS NULL
      OR g.app_id = 'appId'
      OR g.grid_image_path IS NULL
      OR g.icon_image_path IS NULL
      OR g.hero_image_path IS NULL;
    ''';

    final List<Map<String, Object?>> results = await super.sqliteHandler.selectRaw(query: query);

    return results.map((e) => GameInfo.fromMap(game: e)).toList();
  }

  Future<List<ReducedGameInfo>> getReducedGames({
    String? search,
    bool? installed,
    List<int>? launcherIds,
    List<int>? categoryIds,
  }) async {
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
      ON g.launcher_id = l.id;
    ''';

    List<String> whereClauses = [];
    List<Object?> whereParameters = [];

    if (search != null) {
      whereClauses.add('g.title LIKE \'%?%\'');
      whereParameters.add(search);
    }

    if (installed != null){
      String character = (installed) ? '>': '=';

      whereClauses.add('g.install_size $character 0');
    }

    if (launcherIds != null && launcherIds.isNotEmpty){
      whereClauses.add('l.id IN (?)');
      whereParameters.add(launcherIds.join(', '));
    }

    if (categoryIds != null && categoryIds.isNotEmpty){
      // TODO: Implement categories.
    }

    List<Map<String, Object?>> results = await super.sqliteHandler.selectRaw(query: query);

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
    gameMap.remove('categories');

    int launcherId = (await _launcherRepository.getLauncherByName(name: launcher.title))!.id;
    gameMap['launcher_id'] = launcherId;

    // Prevents primary key constraint failure.
    gameMap['id'] = null;

    int gameId = await super.sqliteHandler.insert(table: 'games', values: gameMap);

    if (dlc.isNotEmpty){
      for (DLCInfo dlcInfo in dlc) {
        dlcInfo.parentId = gameId;
      }

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

  Future<int> update({required GameInfo gameInfo}) async {
    const String query = '''
      UPDATE games 
      SET description = ?,
      
      version = ?
      WHERE id = ?;
    ''';

    //icon_image_path = ?,
    // grid_image_path = ?,
    // hero_image_path = ?,

    List<Object?> parameters = [
      gameInfo.description,
      // gameInfo.iconImagePath,
      // gameInfo.gridImagePath,
      // gameInfo.heroImagePath,
      gameInfo.version,
      gameInfo.id
    ];

    return await super.sqliteHandler.updateRaw(query: query, parameters: parameters);
  }
  
  Future<List<int>> updateMultiple({required List<GameInfo> gameList}) async {
    List<int> ids = [];

    for (GameInfo gameInfo in gameList){
      ids.add(await update(gameInfo: gameInfo));
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