import 'package:flutter/material.dart';

class RelatedGamesWidget extends StatelessWidget {
  const RelatedGamesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Related games',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
