import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/game_controller.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/widgets/game_item.dart';
import 'package:sync_launcher/view/widgets/library.dart';
import 'package:sync_launcher/view/widgets/recently_played.dart';

class HomeView extends StatelessWidget {
  final GameController _gameController = GameController();

  HomeView({super.key});

  Future<List<ReducedGameInfo>> _getGames(BuildContext context) async {
    return await _gameController.index();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getGames(context),
      //future: _gameController.index(),
      builder: (context, AsyncSnapshot<List<ReducedGameInfo>> snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: [
              Center(
                child: Text(
                  'Loading games...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const LinearProgressIndicator(),
            ],
          );
        }

        final List<ReducedGameInfo> games = snapshot.data!;

        if (games.isEmpty) {
          return const Text('No games found.');
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                RecentlyPlayedWidget(games: games.sublist(0, 10)),
                const SizedBox(height: 25),
                LibraryWidget(games: games),
              ],
            ),
          ),
        );
      },
    );
  }
}
