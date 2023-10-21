import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchGameButtonWidget extends StatelessWidget {
  final String launcherImagePath;
  final String gameLaunchURL;
  final bool installed;

  const LaunchGameButtonWidget({super.key, required this.gameLaunchURL, required this.launcherImagePath, required this.installed});

  Future<void> _launchGame() async {
    if (!await launchUrl(Uri.parse(gameLaunchURL))) {
      throw Exception('Could not launch game');
    }
  }

  Future<void> _installGame() async {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = (installed) ? 'Launch' : 'Install';
    Function() onPressed = (installed) ? _launchGame : _installGame;
    final List<Color> buttonColors = (installed) 
    ? <Color>[
      const Color(0xffD702FF), 
      const Color(0xff553DFE)
    ]
    : <Color>[
      const Color.fromARGB(255, 43, 184, 62),
      const Color.fromARGB(255, 0, 153, 33)
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: buttonColors
        )
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent
        ),
        onPressed: onPressed, 
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (Theme.of(context).textTheme.titleMedium?.fontSize ?? 15) * 2,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(
                width: 20
              ),
              ImageResolver.createImage(
                imageType: ImageType.icon,
                path: launcherImagePath,
              )
            ],
          )
        )
      ),
    );
  }
}