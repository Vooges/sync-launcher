import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/game_controller.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/widgets/game_item_widget.dart';
import 'package:sync_launcher/view/widgets/library_filter_button_widget.dart';

class LibraryWidget extends StatefulWidget {
  final List<ReducedGameInfo> games;
  const LibraryWidget({super.key, required this.games});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _LibraryWidget(games: games);
}

class _LibraryWidget extends State<LibraryWidget> {
  List<int>? filterCategoryIds;
  List<int>? filterLauncherIds;
  bool? filterInstalled;
  String? searchQuery;

  final GameController _gameController = GameController();
  List<ReducedGameInfo> games;

  _LibraryWidget({required this.games});

  Future filterLibrary({List<int>? categoryIds, List<int>? launcherIds, bool? installed}) async {
    List<ReducedGameInfo> filteredGames = await _gameController.index(
      search: searchQuery, 
      installed: installed, 
      launcherIds: launcherIds, 
      categoryIds: categoryIds
    );
    
    setState(() {
      filterCategoryIds = categoryIds;
      filterLauncherIds = launcherIds;
      filterInstalled = installed;

      games = filteredGames;
    });
  }

  Future searchLibrary({required String? searchQuery}) async {
    List<ReducedGameInfo> filteredGames = await _gameController.index(
      search: searchQuery, 
      installed: filterInstalled, 
      launcherIds: filterLauncherIds, 
      categoryIds: filterCategoryIds
    );

    setState(() {
      this.searchQuery = searchQuery;

      games = filteredGames;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 25; // * There is 25 padding on the parent widget aswell, so take that into account when calculating the available width.
    const double spacing = 15;
    const double cardWidth = 250;

    final Size screenSize = MediaQuery.of(context).size;
    final double availableWidth = screenSize.width - (padding * 4) - cardWidth; // Ignore the first item because it doesn't have margin.
    final int crossAxisCount = ((availableWidth / (cardWidth + spacing)) + 1).toInt(); // Add the first item back.

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Library',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                    ),
                    initialValue: null,
                    onChanged: (String text) async {
                      searchLibrary(searchQuery: text);
                    },
                  ),
                ),
                LibraryFilterButtonWidget(callback: filterLibrary)
              ],
            ),
            const SizedBox(height: 12.5),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: games.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.67,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing
              ),
              itemBuilder: (_, i) {
                // TODO: image doesn't fill the entire space available for the item.
                final current = games.elementAt(i);

                return GameItemWidget(reducedGameInfo: current);
              },
            ),
          ],
        ),
      ),
    );
  }
}
