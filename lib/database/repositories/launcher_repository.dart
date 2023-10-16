import 'package:sync_launcher/database/repositories/base_repository.dart';
import 'package:sync_launcher/models/launcher_info.dart';

class LauncherRepository extends BaseRepository {
  Future<LauncherInfo?> getLauncherById({required int id}) async {
    String query = '''
      SELECT 
        l.id,
        l.image_path,
        l.title,
        l.install_path
      FROM launchers l
      WHERE l.id = ?;
    ''';

    List<Map<String, Object?>> results = await super.sqliteHandler.selectRaw(query: query, parameters: [id]);

    if (results.isEmpty) {
      return null;
    }

    return LauncherInfo.fromMap(launcher: results[0]);
  }

  Future<LauncherInfo?> getLauncherByName({required String name}) async {
    String query = '''
      SELECT 
        l.id,
        l.image_path,
        l.title,
        l.install_path
      FROM launchers l
      WHERE l.title LIKE ?;
    ''';

    List<Map<String, Object?>> results = await super.sqliteHandler.selectRaw(query: query, parameters: [name]);

    if (results.isEmpty) {
      return null;
    }

    return LauncherInfo.fromMap(launcher: results[0]);
  }

  Future<List<LauncherInfo>> getLaunchers() async {
    String query = '''
      SELECT 
        l.id,
        l.image_path,
        l.title,
        l.install_path
      FROM launchers l
    ''';

    List<Map<String, Object?>> results = await super.sqliteHandler.selectRaw(query: query);

    return results.map((e) => LauncherInfo.fromMap(launcher: e)).toList();
  }

  Future<void> setInstallPath({required int id, String? installPath}) async {
    String query = '''
      UPDATE launchers
      SET install_path = ?
      WHERE id = ?;
    ''';

    await super.sqliteHandler.updateRaw(query: query, parameters: [installPath, id]);
  }
}