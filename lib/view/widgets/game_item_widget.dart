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
    Widget image = ImageResolver.createImageWithTextOnFallback(
      imageType: ImageType.grid,
      fallbackText: reducedGameInfo.title,
      context: context,
      path: reducedGameInfo.gridImagePath,
      fit: BoxFit.cover,
    );

    Widget item = Stack(
      children: [
        image,
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomRight,
            child: ImageResolver.createImage(imageType: ImageType.icon, path: reducedGameInfo.launcherInfo.imagePath, width: 43, height: 43),
          )
        )
      ],
    );

    Widget child = (reducedGameInfo.installed) 
      ? item
      : ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.grey.shade700,
            BlendMode.modulate,
          ),
          child: item
        );

    return InkWell(
        onTap: () {
          context.read<SelectedViewState>().setView(GameView(gameId: reducedGameInfo.id));
        },
        child: child
      );
  }
}
