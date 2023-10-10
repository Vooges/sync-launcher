import 'package:flutter/material.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/view/widgets/friends_playing.dart';
import 'package:sync_launcher/view/widgets/game_info.dart';
import 'package:sync_launcher/view/widgets/related_games.dart';

class GameView extends StatelessWidget {
  final GameInfo gameInfo;

  const GameView({super.key, required this.gameInfo});

  @override
  Widget build(BuildContext context) {
    final backgroundContainer = gameInfo.imagePath != null
        ? Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(gameInfo.imagePath ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          )
        : Container(
            color: Theme.of(context).colorScheme.background,
          );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            backgroundContainer,
            // Blurred Background Filter
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.all(48.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GameInfoWidget(gameInfo: gameInfo),
                    const FriendsPlayingWidget(),
                    const RelatedGamesWidget()
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
