import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:sync_launcher/models/friends_playing.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/models/reduced_game_info.dart';

import '../../models/sync_user.dart';

class FriendsPlayingWidget extends StatelessWidget {
  const FriendsPlayingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsPlaying = <FriendsPlaying>[
      FriendsPlaying(
        user: SyncUser(
          username: 'idiidk',
          image: ImageResolver.createImage(imageType: ImageType.icon, width: 43, height: 43, path: 'https://avatars.cloudflare.steamstatic.com/c9d8da4f00f14080202a585fa922d62f0913d47a_full.jpg')
        ),
        gameInfo: ReducedGameInfo(
          id: 730,
          title: 'CSGO',
          launcherInfo: LauncherInfo(title: 'CSGO', imagePath: ''),
        ),
      ),
      FriendsPlaying(
        user: SyncUser(
          username: 'idiidk',
          image: ImageResolver.createImage(imageType: ImageType.icon, width: 43, height: 43, path: 'https://avatars.cloudflare.steamstatic.com/c9d8da4f00f14080202a585fa922d62f0913d47a_full.jpg')
        ),
        gameInfo: ReducedGameInfo(
          id: 730,
          title: 'CSGO',
          launcherInfo: LauncherInfo(title: 'CSGO', imagePath: ''),
        ),
      ),
      FriendsPlaying(
        user: SyncUser(
          username: 'idiidk',
          image: ImageResolver.createImage(imageType: ImageType.icon, width: 43, height: 43, path: 'https://avatars.cloudflare.steamstatic.com/c9d8da4f00f14080202a585fa922d62f0913d47a_full.jpg')
        ),
        gameInfo: ReducedGameInfo(
          id: 730,
          title: 'CSGO',
          launcherInfo: LauncherInfo(title: 'CSGO', imagePath: ''),
        ),
      ),
      FriendsPlaying(
        user: SyncUser(
          username: 'idiidk',
          image: ImageResolver.createImage(imageType: ImageType.icon, width: 43, height: 43, path: 'https://avatars.cloudflare.steamstatic.com/c9d8da4f00f14080202a585fa922d62f0913d47a_full.jpg')
        ),
        gameInfo: ReducedGameInfo(
          id: 730,
          title: 'CSGO',
          launcherInfo: LauncherInfo(title: 'CSGO', imagePath: ''),
        ),
      )
    ];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Friends also playing',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 36
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: friendsPlaying.length,
              itemBuilder: (context, i) {
                FriendsPlaying friend = friendsPlaying[i];

                return Row(
                  children: <Widget>[
                    friend.user.image,
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(friend.user.username),
                        Text('is playing ${friend.gameInfo.title}')
                      ],
                    )
                  ],
                );
              }
            )
          )
        ]
      ),
    );
  }
}
