import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:sync_launcher/database/database_scripts.dart';

class SqliteHandler {
  final String _fileName = 'sync.db';

  SqliteHandler(){
    sqfliteFfiInit();
  }

  Future<void> setup() async{
    Database database = await databaseFactoryFfi.openDatabase(
      join(await getDatabasesPath(), _fileName),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database database, int version) async {
          await database.execute(DatabaseScripts.create);
        }
      )
    );

    await database.close();
  }


}