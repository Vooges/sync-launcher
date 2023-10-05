import 'package:flutter/material.dart';
import 'package:sync_launcher/models/game_info.dart';

class GameItem extends StatelessWidget {
  final GameInfo gameInfo;

  const GameItem({super.key, required this.gameInfo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: Image.network(gameInfo.launcherInfo.imagePath),
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
    );
  }
}
