import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/settings_controller.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:sync_launcher/models/launcher_info.dart';

class LaunchersWidget extends StatefulWidget{
  const LaunchersWidget({super.key});
  
  @override
  State<StatefulWidget> createState() => _LaunchersWidget();

}

class _LaunchersWidget extends State<LaunchersWidget>{
  final SettingsController _settingsController = SettingsController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _settingsController.getLaunchers(), 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (!snapshot.hasData){
          return const CircularProgressIndicator();
        }

        List<LauncherInfo> data = snapshot.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Connected Launchers',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            SizedBox(
              height: 60,
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index){
                    LauncherInfo launcherInfo = data[index];

                    return TextButton(
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: (selectedIndex == index) ? const Color.fromRGBO(63, 63, 63, 1) : const Color.fromRGBO(41, 41, 41, 1),
                      ),
                      onPressed: (){
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Row(
                        children: [
                          ImageResolver.createImage(
                            imageType: ImageType.icon,
                            height: 43,
                            width: 43,
                            path: launcherInfo.imagePath
                          ),
                          const SizedBox(width: 20),
                          Text(
                            launcherInfo.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                            
                          ),
                          const SizedBox(width: 20),
                          ImageResolver.createImage(
                            imageType: ImageType.icon,
                            height: 20,
                            width: 20,
                            path: (launcherInfo.installPath != null) ? 'assets/images/other/green_checkmark.png' : 'assets/images/other/red_cross.png'
                          )
                        ],
                      )
                    );
                  }
                )
              )
            ),
            FutureBuilder(
              future: _settingsController.getLauncherAccountValues(id: selectedIndex), 
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData){
                  return const Center(
                    child: Text('No launcher settings found.'),
                  );
                }

                return const Center(
                  child: Text('default')
                );
              }
            )
          ],
        ); 
      }
    );
  }
}