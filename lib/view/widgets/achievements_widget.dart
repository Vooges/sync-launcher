import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:sync_launcher/models/achievement.dart';

class AchievementsWidget extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsWidget({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty){
      return const Expanded(child: Column());
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Achievements',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 36
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: achievements.length,
              itemBuilder: (context, i) {
                final Achievement achievement = achievements[i];

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: (i != achievements.length) ? 10 : 0
                  ),
                  child: Row(
                    children: <Widget>[
                      ImageResolver.createImage(imageType: ImageType.icon, path: achievement.imagePath, height: 43, width: 43),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            achievement.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(achievement.description ?? '')
                        ],
                      )
                    ]
                  )
                );
              }
            )
          )
        ]
      )
    );
  }
}