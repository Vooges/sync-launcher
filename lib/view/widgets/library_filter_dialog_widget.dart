import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/filter_controller.dart';
import 'package:sync_launcher/models/category.dart';
import 'package:sync_launcher/models/filter_options.dart';
import 'package:sync_launcher/models/installed.dart';
import 'package:sync_launcher/models/launcher_info.dart';

class LibraryFilterDialogWidget extends StatefulWidget {
  final Function callback;

  const LibraryFilterDialogWidget({super.key, required this.callback});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _LibraryFilterDialogWidget(callback: callback);

}

class _LibraryFilterDialogWidget extends State<LibraryFilterDialogWidget> {
  final FilterController _filterController = FilterController();
  final Function callback;

  static Map<String, List<Object>> filters = {};

  _LibraryFilterDialogWidget({required this.callback});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _filterController.getFilters(), 
      builder: (BuildContext context, AsyncSnapshot<FilterOptions> snapshot) {
        if (!snapshot.hasData){
          return const CircularProgressIndicator();
        }

        FilterOptions data = snapshot.data!;

        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          backgroundColor: const Color.fromARGB(255, 20, 20, 20),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            width: MediaQuery.of(context).size.width - 400,
            height: MediaQuery.of(context).size.height - 400,
            child: Row(
              children: [
                _createCategoryFilters(categories: data.categories),
                const SizedBox(width: 40),
                _createLauncherFilters(launchers: data.launchers),
                const SizedBox(width: 40),
                _createInstalledFilters(installed: data.installed),
              ],
            ),
          ),
          
          actions: <Widget>[
            DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xffD702FF), 
                    Color(0xff553DFE)
                  ]
                )
              ),
              child: TextButton(
                onPressed: () async {
                  List<int>? filteredCategoryIds = filters['categories']?.map((e) => e as int).toList() ?? [];
                  List<int>? filteredLauncherIds = filters['launchers']?.map((e) => e as int).toList() ?? [];
                  bool? filteredInstalled = filters['installed']?.map((e) => e as bool).firstOrNull;

                  await callback(categoryIds: filteredCategoryIds, launcherIds: filteredLauncherIds, installed: filteredInstalled);

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }, 
                child: const Text('Filter')
              )
            )
          ],
        );
      }
    );
  }

  Widget _createCategoryFilters({required List<Category> categories}){
    List<Widget> children = [
      Text(
        'Categories',
        style: Theme.of(context).textTheme.displaySmall,
      )
    ];

    children.addAll(categories.map((e) => _createFilterOption(filter: 'categories', identifier: e.id, description: e.value)).toList());

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      )
    );
  }

  Widget _createLauncherFilters({required List<LauncherInfo> launchers}){
    List<Widget> children = [
      Text(
        'Launchers',
        style: Theme.of(context).textTheme.displaySmall
      )
    ];

    children.addAll(launchers.map((e) => _createFilterOption(filter: 'launchers', identifier: e.id, description: e.title)).toList());
    
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      )
    );
  }

  Widget _createInstalledFilters({required List<Installed> installed}){
    List<Widget> children = [
      Text(
        'Installed',
        style: Theme.of(context).textTheme.displaySmall
      )
    ];

    children.addAll(installed.map((e) => _createFilterOption(filter: 'installed', identifier: e.value, description: e.description)).toList());

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      )
    );
  }

  Widget _createFilterOption({required String filter, required Object identifier, required String description}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge
        ),
        Checkbox(
          value: filters[filter] != null && filters[filter]!.contains(identifier),
          onChanged: (bool? value) {
            setState(() {
              if (filters[filter] == null){
                filters[filter] = [];
              }

              filters[filter]!.contains(identifier) ? filters[filter]!.remove(identifier) : filters[filter]!.add(identifier);
            });
          }
        )
      ],
    );
  }
}