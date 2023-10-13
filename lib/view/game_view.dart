import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/game_controller.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/view/widgets/friends_playing.dart';
import 'package:sync_launcher/view/widgets/game_info.dart';
import 'package:sync_launcher/view/widgets/related_games.dart';

class GameView extends StatelessWidget {
  final GameController _gameController = GameController();
  final int gameId;

  GameView({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _gameController.get(id: gameId),
        builder: ((context, AsyncSnapshot<GameInfo> snapshot) {
          List<Widget> children = [const Text('Could not load data.')];

          if (snapshot.hasData) {
            final GameInfo gameInfo = snapshot.data!;

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

            children = [
              // Background Image
              backgroundContainer,
              // Blurred Background Filter
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GameInfoWidget(gameInfo: gameInfo),
                    const SizedBox(
                      height: 50,
                    ),
                    const Expanded(child: FriendsPlayingWidget()),
                    const SizedBox(
                      height: 50,
                    ),
                    const Expanded(child: RelatedGamesWidget())
                  ],
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
        }));
  }
}
