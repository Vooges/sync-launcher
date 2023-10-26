import 'package:sync_launcher/database/repositories/base_repository.dart';
import 'package:sync_launcher/models/account_value.dart';

class AccountValueRepository extends BaseRepository {
  Future<List<AccountValue>> getAccountValuesForLauncher({required int launcherId}) async {
    String query = '''
      SELECT 
        id,
        launcher_id,
        value,
        name
      FROM account_values
      WHERE launcher_id = ?;
    ''';

    List<Map<String, Object?>> results = await super.sqliteHandler.selectRaw(query: query, parameters: [launcherId]);

    return results.map((e) => AccountValue.fromMap(map: e)).toList();
  }

  Future<AccountValue?> getAccountValueByNameForLauncher({required String name, required int launcherId}) async {
    String query = '''
      SELECT 
        id,
        launcher_id,
        value,
        name
      FROM account_values
      WHERE name = ?
      AND launcher_id = ?;
    ''';

    List<Map<String, Object?>> results = await super.sqliteHandler.selectRaw(query: query, parameters: [name, launcherId]);

    return results.isEmpty ? null : AccountValue.fromMap(map: results[0]);
  }

  Future<int> updateAccountValueForLauncher({required AccountValue accountValue}) async {
    String query = '''
      UPDATE account_values
      SET value = ?
      WHERE id = ?;
    ''';

    return await super.sqliteHandler.updateRaw(query: query, parameters: [accountValue.value, accountValue.id]);
  }
}