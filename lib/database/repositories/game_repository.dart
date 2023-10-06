import 'package:sync_launcher/database/repositories/base_repository.dart';
import 'package:sync_launcher/models/game_info.dart';

class GameRepository extends BaseRepository{
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
    List<Map<String, Object?>> dlc = await super.sqliteHandler.select(table: 'dlc', columns: []);

    return GameInfo.fromMap(game: game, dlc: dlc);
  }

  
}