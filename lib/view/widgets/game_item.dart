import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/game_view.dart';

class GameItemWidget extends StatelessWidget {
  final ReducedGameInfo reducedGameInfo;

  const GameItemWidget({super.key, required this.reducedGameInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameView(gameId: reducedGameInfo.id),
            ),
          );
        },
        child: ImageResolver.createImage(
          imageType: ImageType.grid,
          path: reducedGameInfo.gridImagePath,
          height: 300,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
