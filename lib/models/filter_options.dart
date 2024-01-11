import 'package:sync_launcher/models/category.dart';
import 'package:sync_launcher/models/installed.dart';
import 'package:sync_launcher/models/launcher_info.dart';

class FilterOptions {
  final List<Category> categories;
  final List<LauncherInfo> launchers;
  final List<Installed> installed = [
    Installed(value: true, description: 'Yes'), 
    Installed(value: false, description: 'No')
  ];

  FilterOptions({
    required this.categories,
    required this.launchers
  });

  Map<String, Object?> toMap(){
    return {
      'categories': categories.map((e) => e.toMap()),
      'launchers': launchers.map((e) => e.toMap()),
      'installed': installed.map((e) => e.toMap())
    };
  }
}