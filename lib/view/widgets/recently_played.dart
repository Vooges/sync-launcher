import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/widgets/game_item.dart';

class RecentlyPlayedWidget extends StatelessWidget {
  final List<ReducedGameInfo> games;

  const RecentlyPlayedWidget({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently played',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12.5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: games
                .map((e) => [
                      GameItemWidget(reducedGameInfo: e),
                      const SizedBox(width: 15)
                    ])
                .flattened
                .toList(),
          ),
        ),
      ],
    );
  }
}
