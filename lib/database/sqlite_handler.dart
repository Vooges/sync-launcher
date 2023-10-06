import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:sync_launcher/database/database_scripts.dart';

class SqliteHandler {
  static final SqliteHandler _instance = SqliteHandler._internal();
  final String _fileName = 'sync.db';

  SqliteHandler._internal(){
    sqfliteFfiInit();
  }

  factory SqliteHandler(){
    return _instance;
  }
  
  Future<List<Map<String, Object?>>> selectRaw({required String query, List<Object?>? parameters}) async{
    Database database = await _openDatabase();

    List<Map<String, Object?>> results = await database.rawQuery(query, parameters);

    database.close();

    return results;
  }

  Future<List<Map<String, Object?>>> select({
    required String table, 
    required List<String> columns, 
    String? where,
    List<Object>? whereArguments,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset
  }) async {
    Database database = await _openDatabase();

    List<Map<String, Object?>> result = await database.query(
      table, 
      columns: columns, 
      where: where, 
      whereArgs: whereArguments, 
      groupBy: groupBy, 
      having: having, 
      orderBy: orderBy,
      limit: limit,
      offset: offset
    );

    database.close();

    return result;
  }

  Future<Database> _openDatabase() async {
    return await databaseFactoryFfi.openDatabase(
      join(await getDatabasesPath(), _fileName),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database database, int version) async {
          await database.execute(DatabaseScripts.create);
        }
      )
    );
  }
}