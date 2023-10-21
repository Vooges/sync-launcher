import 'package:flutter/material.dart';
import 'package:sync_launcher/models/achievement.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/view/widgets/achievements_widget.dart';
import 'package:sync_launcher/view/widgets/friends_playing.dart';
import 'package:sync_launcher/view/widgets/owned_dlc_widget.dart';

class AdditionalGameInformationWidget extends StatelessWidget {
  final GameInfo gameInfo;

  const AdditionalGameInformationWidget({super.key, required this.gameInfo});
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 52, right: 52, top: 0, bottom: 41),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const FriendsPlayingWidget(),
            const AchievementsWidget(achievements: [Achievement(name: 'Achievement name', description: 'Achievement description')]),
            OwnedDLCWidget(ownedDLC: gameInfo.dlc)
          ]
        )
      )
    );
  }
}