import 'package:flutter/material.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/widgets/game_item.dart';

class FriendsPlayingWidget extends StatelessWidget {
  const FriendsPlayingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your friends are playing',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GameItemWidget(
                reducedGameInfo: ReducedGameInfo(
                  id: 730,
                  title: 'CSGO',
                  launcherInfo: LauncherInfo(title: 'CSGO', imagePath: ''),
                ),
              ),
            ),
            Expanded(
              child: GameItemWidget(
                reducedGameInfo: ReducedGameInfo(
                  id: 730,
                  title: 'CSGO',
                  launcherInfo: LauncherInfo(title: 'CSGO', imagePath: ''),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
