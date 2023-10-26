import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/settings_controller.dart';
import 'package:sync_launcher/models/account_value.dart';
import 'package:sync_launcher/models/launcher_info.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final SettingsController _settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget?>(
      future: _createLauncherInstallPathWidgets(), 
      builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot){
        if (snapshot.hasData){
          return snapshot.data!;
        } else {
          return ListView();
        }
      }
    );
  }

  Future<Widget?> _createLauncherInstallPathWidgets() async {
    List<Widget> widgets = List.empty(growable: true);

    List<LauncherInfo> launchers = await _settingsController.getLaunchers();

    for (LauncherInfo launcher in launchers) {
      List<AccountValue> accountValues = await _settingsController.getLauncherAccountValues(id: launcher.id);

      widgets.add(Text(launcher.title));

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
            // TODO: Show error on screen.
          }
        }, 
        child: const Text('Retrieve games')
      ));

      for (AccountValue accountValue in accountValues) {
        widgets.add(TextFormField(
          initialValue: accountValue.value,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: accountValue.name
          ),
          onChanged: (text) async {
            accountValue.value = text;
            try {
              await _settingsController.updateAccountValueForLauncher(value: accountValue);
            } catch (exception){
              // TODO: Show error on screen.
            }
          },
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(25),
      child: ListView(
        children: widgets,
      ),
    );
  }
}