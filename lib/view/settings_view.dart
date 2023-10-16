import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/settings_controller.dart';
import 'package:sync_launcher/models/launcher_info.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final SettingsController _settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ListView>(
      future: _createLauncherInstallPathWidgets(), 
      builder: (BuildContext context, AsyncSnapshot<ListView> snapshot){
        if (snapshot.hasData){
          return snapshot.data!;
        } else {
          return ListView();
        }
      }
    );
  }

  Future<ListView> _createLauncherInstallPathWidgets() async{
    List<Widget> widgets = List.empty(growable: true);

    List<LauncherInfo> launchers = await _settingsController.getLaunchers();

    for (LauncherInfo launcher in launchers) {
      widgets.add(TextFormField(
        initialValue: launcher.installPath,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: 'Path to ${launcher.title} installation',
        ),
        onChanged: (text) async {
          await _settingsController.setLauncherInstallPath(launcherId: launcher.id, installPath: text);
        }));
      widgets.add(TextButton(
        onPressed: () async {
          try {
            await _settingsController.runGameRetriever(launcherId: launcher.id);
          } catch (exception){
            //
          }
        }, 
        child: const Text('Retrieve games')
      ));
    }

    return ListView(
      children: widgets,
    );
  }
}