import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/settings_controller.dart';
import 'package:sync_launcher/models/account_value.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/view/widgets/connected_launchers_widget.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key});

  final SettingsController _settingsController = SettingsController();

  @override
  State<StatefulWidget> createState() => _SettingsState();

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
      widgets.add(Text(launcher.title));

      List<AccountValue> accountValues = await _settingsController.getLauncherAccountValues(id: launcher.id);
      for (AccountValue accountValue in accountValues) {
        widgets.add(Text(accountValue.name));
        widgets.add(TextFormField(
          initialValue: accountValue.value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
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

      widgets.add(Text('Path to ${launcher.title} installation'));
      widgets.add(TextFormField(
        initialValue: launcher.installPath,
        decoration: const InputDecoration(
          border: OutlineInputBorder()
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

    }

    return Padding(
      padding: const EdgeInsets.all(25),
      child: ListView(
        children: widgets,
      ),
    );
  }
}

class _SettingsState extends State<SettingsView>{
  final List<String> settingsCategories = [
    'Launchers',
    'Test'
  ];

  final List<Widget> categories = [
    const LaunchersWidget()
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.black,
                width: 4.0
              )
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildSidebarChildren(),
          ),
        ),
        categories[selectedIndex]
      ],
    );
  }

  List<Widget> _buildSidebarChildren(){
    List<Widget> children = [];

    for(int i = 0; i < settingsCategories.length; i++){
      children.add(
        TextButton(
          onPressed: (){
            setState(() {
              selectedIndex = i;
            });
          }, 
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero
            ),
            backgroundColor: (selectedIndex != i) ? null : const Color.fromRGBO(63, 63, 63, 1)
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              settingsCategories[i], 
              style: Theme.of(context).textTheme.headlineSmall,
            )
          )
        )
      );
    }

    return children;
  }
}