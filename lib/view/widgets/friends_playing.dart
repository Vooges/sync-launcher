import 'package:flutter/material.dart';
import 'package:sync_launcher/models/friends_playing.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/view/game_view.dart';
import 'package:sync_launcher/view/widgets/game_item.dart';

import '../../models/sync_user.dart';

class FriendsPlayingWidget extends StatelessWidget {
  const FriendsPlayingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsPlaying = [
      FriendsPlaying(
        user: SyncUser(
          username: 'idiidk',
          image: Image.network(
            'https://avatars.cloudflare.steamstatic.com/c9d8da4f00f14080202a585fa922d62f0913d47a_full.jpg',
          ),
        ),
        gameInfo: ReducedGameInfo(
          id: 730,
          title: 'CSGO',
          launcherInfo: LauncherInfo(title: 'CSGO', imagePath: ''),
        ),
      )
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your friends are playing',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 25,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: friendsPlaying.length,
            itemBuilder: (_, index) {
              final friendPlaying = friendsPlaying.elementAt(index);
              return ListTile(
                title: Text(friendPlaying.user.username),
                subtitle: Text('is playing ${friendPlaying.gameInfo.title}'),
                leading: friendPlaying.user.image,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameView(
                        gameId: friendPlaying.gameInfo.id,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
