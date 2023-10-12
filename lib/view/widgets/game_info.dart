import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/game_info.dart';

class GameInfoWidget extends StatelessWidget {
  final GameInfo gameInfo;

  const GameInfoWidget({super.key, required this.gameInfo});

  Future<void> _launchGame() async {
    if (!await launchUrl(Uri.parse(gameInfo.launchURL))) {
      throw Exception('could not launch game');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          gameInfo.title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Text(
          gameInfo.description ?? 'Unknown',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
            onPressed: _launchGame,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const Text('Launch'),
          ),
        )
      ],
    );
  }
}
