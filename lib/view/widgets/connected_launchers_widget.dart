import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/settings_controller.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:sync_launcher/models/account_value.dart';
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
      future: _settingsController.getLauncherAccountValues(id: selectedIndex + 1), 
      builder: (BuildContext context, AsyncSnapshot<List<AccountValue>> snapshot){
        if (!snapshot.hasData){
          return const CircularProgressIndicator();
        }

        Size screenSize = MediaQuery.of(context).size;

        List<Widget> children = _createListItems(accountValues: snapshot.data!);

        return SingleChildScrollView(
          child: SizedBox(
            width: screenSize.width - 204, // 204 is the width of the sidebar + the divider line.
            height: screenSize.height,
            child: ListView(
              children: children,
            )
          )
        );
      }
    );
  }

  List<Widget> _createListItems({required List<AccountValue> accountValues}){
    List<Widget> items = [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          'Connected Launchers',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      SizedBox(
        height: 60,
        child: FutureBuilder(
          future: _settingsController.getLaunchers(), 
          builder: (BuildContext context, AsyncSnapshot<List<LauncherInfo>> snapshot){
            if (snapshot.data != null && snapshot.data!.isNotEmpty){
              return _createLauncherButtons(launchers: snapshot.data!);
            }

            return const CircularProgressIndicator();
          }
        )
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: _settingsController.getLauncher(id: selectedIndex + 1), 
          builder: (BuildContext context, AsyncSnapshot<LauncherInfo?> snapshot){
            if (snapshot.data == null){
              return const CircularProgressIndicator();
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  key: Key(snapshot.data!.title), // Hack to trick flutter into actually updating the initial value when switching between launchers.
                  decoration: const InputDecoration(
                    labelText: 'Install path',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  initialValue: snapshot.data!.installPath,
                  onChanged: (String text) async {
                    final bool exists = await Directory(text).exists();

                    if (exists){
                      _settingsController.setLauncherInstallPath(launcherId: selectedIndex + 1, installPath: text);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
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
                    onPressed: () async {
                      try {
                        await _settingsController.runGameRetriever(launcherId: selectedIndex + 1);
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
                    }, 
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Retrieve games',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  )
                )
              ]
            );
          }
        )
      ),
    ];

    for (AccountValue accountValue in accountValues){
      items.add(_createInputItem(accountValue: accountValue));
    }

    return items;
  }

  Widget _createInputItem({required AccountValue accountValue}){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: accountValue.name,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
              )
            ),
            initialValue: accountValue.value,
            onChanged: (String text){
              accountValue.value = text;
              _settingsController.updateAccountValueForLauncher(value: accountValue);
            },
          )
        ],
      ),
    );
  }

  Widget _createLauncherButtons({required List<LauncherInfo> launchers}){
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: launchers.length,
      itemBuilder: (BuildContext context, int index){
        LauncherInfo launcherInfo = launchers[index];

        return TextButton(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
            ),
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
                path: (launcherInfo.installPath != null && launcherInfo.installPath!.isNotEmpty) 
                  ? 'assets/images/other/green_checkmark.png' 
                  : 'assets/images/other/red_cross.png'
              )
            ],
          )
        );
      }
    );
  }
}