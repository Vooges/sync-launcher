import 'package:flutter/material.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/view/game_view.dart';

class GameItemWidget extends StatelessWidget {
  final GameInfo gameInfo;

  const GameItemWidget({super.key, required this.gameInfo});

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
                gameInfo: gameInfo, // TODO: Needs to be call to gameController.get(id) to get the full game info.
              ),
            ),
          );
        },
        child: Column(
          children: [
            Image.network(gameInfo.imagePath ?? ''),
            const SizedBox(
              height: 15,
            ),
            Text(
              gameInfo.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              gameInfo.description ?? 'Unknown',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
