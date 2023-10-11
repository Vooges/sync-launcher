import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/game_controller.dart';
import 'package:sync_launcher/models/game_info.dart';

class GameView extends StatelessWidget {
  final GameController _gameController = GameController();
  final int gameId;

  GameView({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _gameController.get(id: gameId), 
      builder: ((context, AsyncSnapshot<GameInfo> snapshot){
        List<Widget> children = [const Text('Could not load data.')];

        if (snapshot.hasData){
          final GameInfo gameInfo = snapshot.data!;

          children = [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(gameInfo.imagePath ?? 'assets/images/games/default_cover.png'), // TODO: set default image.
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Blurred Background Filter
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.all(48.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      gameInfo.title,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      gameInfo.description ?? 'Unknown',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
              ),
            ),
          ];
        }

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: children,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      })
    );
  }
}
