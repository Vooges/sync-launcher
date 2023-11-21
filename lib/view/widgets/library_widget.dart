import 'package:flutter/material.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/widgets/game_item_widget.dart';

class LibraryWidget extends StatelessWidget {
  final List<ReducedGameInfo> games;

  const LibraryWidget({super.key, required this.games});

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
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Library',
              style: Theme.of(context).textTheme.displaySmall,
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
