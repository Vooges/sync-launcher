import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
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

    return Stack(
      children: [
        Container( // Hero image container.
          width: screenSize.width,
          height: screenSize.height / 1.632,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: ImageResolver.createImage(
                imageType: ImageType.hero,
                path: gameInfo.heroImagePath,
              ).image
            )
          )
        ),
        Container( // Hero image gradient container.
          width: screenSize.width,
          height: screenSize.height / 1.632,
          decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: <Color>[
                const Color(0xff222020).withOpacity(0.3),
                const Color(0xff222020).withOpacity(1.0),
              ],
              stops: const <double>[
                0.0,
                0.85
              ]
            )
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenSize.height / 1.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      gameInfo.title,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: screenSize.width / 2),
                      child: Text(
                        gameInfo.description ??
                            'The description for the game has not been found. The metadata service will try to find the description online. This will be done as a background process and requires no user input. Retrieving the data might take a while.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const Spacer(),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 250),
                      child: LaunchGameButtonWidget(
                        gameLaunchURL: gameInfo.launchURL,
                        launcherImagePath: gameInfo.launcherInfo.imagePath,
                        installed: gameInfo.installSize > 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AdditionalGameInformationWidget(gameInfo: gameInfo),
          ],
        ),
      ]
    );
  }
}
