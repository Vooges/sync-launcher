import 'package:flutter/material.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/widgets/game_item.dart';

class LibraryWidget extends StatelessWidget {
  final List<ReducedGameInfo> games;

  const LibraryWidget({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Library',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12.5),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: games.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 0.5,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15
              ),
              itemBuilder: (_, i) {
                final current = games.elementAt(i);

                return GameItemWidget(
                  reducedGameInfo: current,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
