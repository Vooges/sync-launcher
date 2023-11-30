import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sync_launcher/controllers/game_controller.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/state/selected_view_state.dart';
import 'package:sync_launcher/view/settings_view.dart';
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
      builder: (context, AsyncSnapshot<List<ReducedGameInfo>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Loading games...',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                  const SizedBox(
                  height: 25,
                ),
                const CircularProgressIndicator(),
              ],
            ),
          );
        }

        final List<ReducedGameInfo> games = snapshot.data!;

        if (games.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'No games found',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextButton(
                  onPressed: () {
                    context.read<SelectedViewState>().setView(SettingsView());
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.purple)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Try adding launchers via the settings',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              ],
            ) 
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
