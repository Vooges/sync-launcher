import 'package:sync_launcher/database/repositories/base_repository.dart';
import 'package:sync_launcher/database/repositories/dlc_repository.dart';
import 'package:sync_launcher/models/dlc_info.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/models/launcher_info.dart';

class GameRepository extends BaseRepository{
  DLCRepository dlcRepository = DLCRepository();

  Future<GameInfo> getSingleGameInfo({required int id}) async{
    String query = '''
      SELECT 
        g.id, 
        g.title, 
        g.app_id,
        g.launch_url,
        l.id,
        l.value,
        l.image_path,
        g.description,
        g.install_size,
        g.version
      FROM games g
      INNER JOIN launchers l 
      ON l.id = g.launcher_id
      WHERE g.id = ?
    ''';

    Map<String, Object?> game = (await super.sqliteHandler.selectRaw(query: query, parameters: List.of([id])))[0];

    List<DLCInfo> dlc = await dlcRepository.getDLCInfoForGame(gameId: game['id'] as int);

    return GameInfo.fromMap(game: game, dlc: dlc);
  }

  Future<int> insert({required GameInfo game}) async {
    Map<String, Object?> gameMap = game.toMap();
    LauncherInfo launcher = gameMap['launcher'] as LauncherInfo;
    List<DLCInfo> dlc = gameMap['dlc'] as List<DLCInfo>;

    // TODO: Check if it is possible to map complex entities to the essential values needed for this insert statement.
    gameMap.remove('dlc');
    gameMap.remove('launcher');

    // TODO: Get this from the launcher repository for clean code's sake.
    int launcherId = (await super.sqliteHandler.selectRaw(query: 'SELECT id FROM launchers WHERE value LIKE ?', parameters:List.from([launcher.title])))[0]['id'] as int;
    gameMap['launcher_id'] = launcherId;

    int gameId = await super.sqliteHandler.insert(table: 'games', values: gameMap);

    dlcRepository.insertMultiple(dlcList: dlc);

    return gameId;
  }

  Future<List<int>> insertMultiple({required List<GameInfo> gameList}) async {
    List<int> ids = List.empty(growable: true);

    for (GameInfo game in gameList) {
      ids.add(await insert(game: game));
    }

    return ids;
  }
}