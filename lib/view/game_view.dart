import 'package:flutter/material.dart';
import 'package:sync_launcher/models/game_info.dart';

class GameView extends StatelessWidget {
  final GameInfo gameInfo;

  const GameView({super.key, required this.gameInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(gameInfo.imagePath ?? ''), // TODO: set default image.
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
