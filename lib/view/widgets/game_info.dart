import 'package:flutter/material.dart';

import '../../models/game_info.dart';

class GameInfoWidget extends StatelessWidget {
  final GameInfo gameInfo;

  const GameInfoWidget({super.key, required this.gameInfo});

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
          height: 50,
        ),
        ElevatedButton(
          onPressed: () => {},
          child: const Text('Launch'),
        )
      ],
    );
  }
}
