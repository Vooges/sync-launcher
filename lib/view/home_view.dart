import 'package:flutter/material.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/view/widgets/game_item.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final csgo = GameInfo(
      title: 'CSGO',
      appId: '730',
      launchURL: 'steam://rungameid:730',
      launcherInfo: LauncherInfo(
        title: 'Counter Strike: Global Offensive',
        imagePath:
            'https://upload.wikimedia.org/wikipedia/en/6/6e/CSGOcoverMarch2020.jpg',
      ),
    );

    final games = List.of([csgo, csgo, csgo, csgo, csgo, csgo, csgo, csgo]);

    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 150).floor(); // Assuming each game item has a width of 150, adjust this value according to your item width

    return GridView.builder(
      itemCount: games.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.5,
      ),
      itemBuilder: (_, i) {
        final current = games.elementAt(i);

        return GameItem(
          gameInfo: current,
        );
      },
    );
  }
}
