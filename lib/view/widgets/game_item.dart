import 'package:flutter/material.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/game_view.dart';

class GameItem extends StatelessWidget {
  final ReducedGameInfo reducedGameInfo;

  const GameItem({super.key, required this.reducedGameInfo});

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
                gameId: reducedGameInfo.id
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // FadeInImage.assetNetwork(
            //   placeholder: 'assets/images/games/default_cover.png', 
            //   image: reducedGameInfo.imagePath ?? 'assets/images/games/default_cover.png',
            //   height: 300,
            //   fit: BoxFit.fitWidth,
            // ),
            Image.network(
              reducedGameInfo.imagePath ?? '',
              height: 300,
              fit: BoxFit.fitWidth,
              errorBuilder: ((context, error, stackTrace) {
                return Image.asset(
                  'assets/images/games/default_cover.png',
                  height: 300,
                  fit: BoxFit.fitWidth,
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                reducedGameInfo.title,
                style: Theme.of(context).textTheme.titleMedium,
              )
            )
          ],
        ),
      ),
    );
  }
}
