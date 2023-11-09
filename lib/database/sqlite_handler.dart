import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sync_launcher/database/database_scripts.dart';

class SqliteHandler {
  static SqliteHandler? _instance;
  static Database? _database;
  
  final String _fileName = 'sync.db';

  SqliteHandler._internal(){
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
  }

  factory SqliteHandler(){
    _instance ??= SqliteHandler._internal();
    return _instance!;
  }
  
  Future<List<Map<String, Object?>>> selectRaw({required String query, List<Object?>? parameters}) async{
    await _openDatabase();

    List<Map<String, Object?>> results = await _database!.rawQuery(query, parameters);

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
    await _openDatabase();

    List<Map<String, Object?>> result = await _database!.query(
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

    return result;
  }

  Future<int> insert({required String table, required Map<String, Object?> values}) async {
    await _openDatabase();

    int id = await _database!.insert(table, values);

    return id;
  }

  Future<int> insertRaw({required String query}) async {
    await _openDatabase();

    int id = await _database!.rawInsert(query);

    return id;
  }

  Future<int> updateRaw({required String query, List<Object?>? parameters}) async {
    await _openDatabase();

    int id = await _database!.rawUpdate(query, parameters);

    return id;
  }

  Future<int> deleteRaw({required String query, List<Object?>? parameters}) async {
    await _openDatabase();

    int count = await _database!.rawDelete(query, parameters);

    return count;
  }

  Future _openDatabase() async {
    if (_database == null){
      _database = await databaseFactoryFfi.openDatabase(
        _fileName,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (Database database, int version) async {
            await database.execute(DatabaseScripts.create);
            await database.execute(DatabaseScripts.insertLaunchers);
            await database.execute(DatabaseScripts.insertAccountValues);
          }
        )
      );
    }
  }
}