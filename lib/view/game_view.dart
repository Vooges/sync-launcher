import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/game_controller.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/view/widgets/detailed_game_information_widget.dart';

class GameView extends StatelessWidget {
  final GameController _gameController = GameController();
  final int gameId;

  GameView({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _gameController.get(id: gameId),
        builder: ((context, AsyncSnapshot<GameInfo> snapshot) {
          if (snapshot.hasData) {
            final GameInfo gameInfo = snapshot.data!;

            final screenSize = MediaQuery.of(context).size;

            return SingleChildScrollView(
              child: SizedBox(
                width: screenSize.width,
                height: screenSize.height,
                child: DetailedGameInformationWidget(key: key, gameInfo: gameInfo)
              )
            );
          }

          return const Center(
            child: Text('Could not load data.'),
          );
        }
      )
    );
  }
}
