import 'package:sync_launcher/database/repositories/base_repository.dart';
import 'package:sync_launcher/models/category.dart';

class CategoryRepository extends BaseRepository {
  Future<List<Category>> getAll() async {
    const String query = '''
      SELECT 
        id,
        value
      FROM categories;
    ''';

    final List<Map<String, Object?>> results = await super.sqliteHandler.selectRaw(query: query);

    return results.map((e) => Category.fromMap(map: e)).toList();
  }
}