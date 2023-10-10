import 'package:sync_launcher/database/repositories/base_repository.dart';
import 'package:sync_launcher/models/dlc_info.dart';

class DLCRepository extends BaseRepository {
  Future<DLCInfo> getSingleDLCInfo({required int id}) async {
    String query = '''
      SELECT 
        id, 
        title, 
        app_id,
        parent_id,
        parent_app_id,
        image_path,
        install_size
      FROM dlc
      WHERE id = ?
    ''';

    Map<String, Object?> dlcMap = (await super.sqliteHandler.selectRaw(query: query, parameters: [id]))[0];

    return DLCInfo.fromMap(dlc: dlcMap);
  }

  Future<List<DLCInfo>> getDLCInfoForGame({required int gameId}) async {
    String query = '''
      SELECT 
        id, 
        title, 
        app_id,
        parent_id,
        parent_app_id,
        image_path,
        install_size
      FROM dlc
      WHERE parent_id = ?
    ''';

    List<Map<String, Object?>> dlcMap = (await super.sqliteHandler.selectRaw(query: query, parameters: [gameId]));

    return dlcMap.map((e) => DLCInfo.fromMap(dlc: e)).toList();
  }

  Future<int> insert({required DLCInfo dlcInfo}) async {
    Map<String, Object?> dlcMap = dlcInfo.toMap();

    dlcMap['id'] = null;

    return await super.sqliteHandler.insert(table: 'dlc', values: dlcMap);
  }

  Future<List<int>> insertMultiple({required List<DLCInfo> dlcList}) async {
    List<int> ids = List.empty(growable: true);

    for (DLCInfo dlc in dlcList) {
      ids.add(await insert(dlcInfo: dlc));
    }

    return ids;
  }
}