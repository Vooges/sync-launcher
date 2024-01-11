import 'package:sync_launcher/database/repositories/base_repository.dart';

class AdminRepository extends BaseRepository {
  

  Future clearAllData() async {
    await super.sqliteHandler.rawQuery(query: 'DELETE FROM games;');
    await super.sqliteHandler.rawQuery(query: 'DELETE FROM dlc;');
    await super.sqliteHandler.rawQuery(query: 'DELETE FROM categories;');
    await super.sqliteHandler.rawQuery(query: 'DELETE FROM game_categories;');
    await super.sqliteHandler.rawQuery(query: 'UPDATE account_values SET value = NULL;');
    await super.sqliteHandler.rawQuery(query: 'UPDATE launchers SET install_path = NULL;');
  }
}