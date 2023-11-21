import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/game_controller.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/widgets/library_widget.dart';
import 'package:sync_launcher/view/widgets/recently_played_widget.dart';

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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const CircularProgressIndicator(),
            ],
          );
        }

        final List<ReducedGameInfo> games = snapshot.data!;

        if (games.isEmpty) {
          return const Center(
            child: Text('No games found.'),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecentlyPlayedWidget(games: games.sublist(0, 5)),
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
