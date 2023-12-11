import 'package:flutter/material.dart';
import 'package:sync_launcher/view/widgets/connected_launchers_widget.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsView>{
  final List<String> settingsCategories = [
    'Launchers',
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