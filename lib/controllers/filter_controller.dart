import 'package:sync_launcher/database/repositories/category_repository.dart';
import 'package:sync_launcher/database/repositories/launcher_repository.dart';
import 'package:sync_launcher/models/category.dart';
import 'package:sync_launcher/models/filter_options.dart';
import 'package:sync_launcher/models/launcher_info.dart';

class FilterController {
  final CategoryRepository _categoryRepository = CategoryRepository();
  final LauncherRepository _launcherRepository = LauncherRepository();

  Future<FilterOptions> getFilters() async {
    final List<Category> categories = await _categoryRepository.getAll();
    final List<LauncherInfo> launchers = await _launcherRepository.getLaunchers();

    return FilterOptions(
      categories: categories, 
      launchers: launchers
    );
  }
}