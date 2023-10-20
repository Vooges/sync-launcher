import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/view/widgets/additional_game_information.dart';
import 'package:sync_launcher/view/widgets/launch_game_button.dart';

class DetailedGameInformationWidget extends StatelessWidget {
  final GameInfo gameInfo;

  const DetailedGameInformationWidget({required super.key, required this.gameInfo});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double heroHeight = screenWidth / (1920 / 620); // Calculates the correct height for the hero image. These images are all 1920x620 in size.

    return Stack(
      children: <Widget>[
        Container( // Hero image container.
          width: screenWidth,
          height: heroHeight,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 52),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageResolver.createImage(
                imageType: ImageType.hero,
                path: gameInfo.heroImagePath,
                fit: BoxFit.fitWidth
              ).image
            )
          )
        ),
        Container( // Hero image gradient container.
          width: screenWidth,
          height: heroHeight,
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
                0.9
              ]
            )
          ),
        ),
        Column(
          children: <Widget>[
            Container( // Container containing the game data.
              width: screenWidth,
              height: heroHeight - 75,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 52),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          gameInfo.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: (Theme.of(context).textTheme.headlineLarge?.fontSize ?? 32) * 2
                          ),
                        ),
                        Text(
                          gameInfo.description ?? 'The description for the game has not been found. The metadata service will try to find the description online. This will be done as a background process and requires no user input. Retrieving the data might take a while.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) * 2
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            LaunchGameButtonWidget(
                              gameLaunchURL: gameInfo.launchURL, 
                              launcherImagePath: gameInfo.launcherInfo.imagePath
                            )
                          ]
                        )
                      ],
                    )
                  ),
                  const Expanded( // This limits the size of the information column.
                    flex: 3,
                    child: Column(),
                  )
                ]
              )
            ),
            AdditionalGameInformationWidget(gameInfo: gameInfo)
          ],
        )
      ]
    );
  }
}