import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/state/selected_view_state.dart';
import 'package:sync_launcher/view/game_view.dart';

class GameItemWidget extends StatelessWidget {
  final ReducedGameInfo reducedGameInfo;

  const GameItemWidget({super.key, required this.reducedGameInfo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<SelectedViewState>().setView(GameView(gameId: reducedGameInfo.id));
      },
      child: ImageResolver.createImage(
        imageType: ImageType.grid,
        path: reducedGameInfo.gridImagePath,
        width: 250,
        height: 350,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
