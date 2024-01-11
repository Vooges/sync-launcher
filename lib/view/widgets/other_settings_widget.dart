import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/settings_controller.dart';

class OtherSettingsWidget extends StatelessWidget {
  final SettingsController _settingsController = SettingsController();

  OtherSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SizedBox(
        width: screenSize.width - 204,
        height: screenSize.height,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: buildOtherSettingsListItems(context: context),
          ),
        ),
      )
    );
  }

  List<Widget> buildOtherSettingsListItems({required BuildContext context}){
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This will remove all data from Sync. This cannot be undone.',
            style: Theme.of(context).textTheme.titleMedium,
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
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Clear data',
                  style: Theme.of(context).textTheme.titleMedium
                ),
              ),
              onPressed: () async {
                await _settingsController.clearAllData();
              },
            )
          )
        ],
      )
    ];
  }
}