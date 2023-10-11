import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/game_controller.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/retrievers/game_bootstrapper.dart';
import 'package:sync_launcher/view/widgets/game_item.dart';

class HomeView extends StatelessWidget {
  final GameController _gameController = GameController();
  final GameBootstrapper _gameBootstrapper = GameBootstrapper();

  HomeView({super.key});

  Future<List<ReducedGameInfo>> _future() async {
    await _gameBootstrapper.bootstrap();

    return await _gameController.index();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 200).floor(); // Assuming each game item has a width of 200, adjust this value according to your item width

    return FutureBuilder(
      future: _future(),
      //future: _gameController.index(), 
      builder: (context, AsyncSnapshot<List<ReducedGameInfo>> snapshot) {
        if (!snapshot.hasData) {
          return const Text('Loading games...');
        }

        final List<ReducedGameInfo> games = snapshot.data!;

        if (games.isEmpty){
          return const Text('No games found.');
        }

        return GridView.builder(
          itemCount: games.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.5,
          ),
          itemBuilder: (_, i) {
            final current = games.elementAt(i);

            return GameItem(
              reducedGameInfo: current,
            );
          },
        );
      }
    );
  }
}
