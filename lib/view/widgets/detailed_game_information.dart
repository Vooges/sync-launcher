import 'package:flutter/material.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/view/widgets/additional_game_information.dart';
import 'package:sync_launcher/view/widgets/launch_game_button.dart';

class DetailedGameInformationWidget extends StatelessWidget {
  final GameInfo gameInfo;

  const DetailedGameInformationWidget({
    required super.key,
    required this.gameInfo,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          gameInfo.title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: screenSize.width / 2),
          child: Text(
            gameInfo.description ??
                'The description for the game has not been found. The metadata service will try to find the description online. This will be done as a background process and requires no user input. Retrieving the data might take a while.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 25),
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 250),
          child: LaunchGameButtonWidget(
            gameLaunchURL: gameInfo.launchURL,
            launcherImagePath: gameInfo.launcherInfo.imagePath,
            installed: gameInfo.installSize > 0,
          ),
        ),
        const SizedBox(height: 25),
        AdditionalGameInformationWidget(gameInfo: gameInfo)
      ],
    );
  }
}
