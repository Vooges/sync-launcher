import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchGameButtonWidget extends StatelessWidget {
  final String launcherImagePath;
  final String gameLaunchURL;
  final bool installed;
  final BuildContext context;

  const LaunchGameButtonWidget({super.key, required this.gameLaunchURL, required this.launcherImagePath, required this.installed, required this.context});

  Future<void> _launchGame() async {
    try {
      if (!await launchUrl(Uri.parse(gameLaunchURL))) {
        throw Exception('Could not launch game');
      }
    } catch (exception){
      // ignore: use_build_context_synchronously
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            backgroundColor: const Color.fromRGBO(43, 43, 43, 1),
            actionsAlignment: MainAxisAlignment.center,
            title: Center(
              child: Text(
                'Error',
                style: Theme.of(context).textTheme.displayMedium,
              )
            ),
            content: Text(
              exception.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: <Widget>[
              DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xffD702FF), 
                      Color(0xff553DFE)
                    ]
                  )
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context, 'Ok'), 
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  )
                )
              )
            ],
          );
        }
      );
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
        borderRadius: const BorderRadius.all(Radius.circular(5)),
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