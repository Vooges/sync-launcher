import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/game_controller.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/view/widgets/detailed_game_information.dart';
import 'package:sync_launcher/view/widgets/status_bar.dart';

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

            return Scaffold(
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(70), 
                child: StatusBarWidget()
              ),
              backgroundColor: const Color(0xff222020),
              body: SafeArea(
                child: DetailedGameInformationWidget(key: key, gameInfo: gameInfo)
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
            );
          }

          return const Text('Could not load data.');
        }
      )
    );
  }
}
