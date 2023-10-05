import 'package:flutter/material.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/view/game_view.dart';

class GameItem extends StatelessWidget {
  final GameInfo gameInfo;

  const GameItem({super.key, required this.gameInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameView(
                gameInfo: gameInfo,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Image.network(gameInfo.launcherInfo.imagePath),
            const SizedBox(
              height: 15,
            ),
            Text(
              gameInfo.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              gameInfo.description,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
