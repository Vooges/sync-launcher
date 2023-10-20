import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchGameButtonWidget extends StatelessWidget {
  final String launcherImagePath;
  final String gameLaunchURL;

  const LaunchGameButtonWidget({super.key, required this.gameLaunchURL, required this.launcherImagePath});

  Future<void> _launchGame() async {
    if (!await launchUrl(Uri.parse(gameLaunchURL))) {
      throw Exception('could not launch game');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xffD702FF), Color(0xff553DFE)])),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent
        ),
        onPressed: _launchGame, 
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Launch',
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