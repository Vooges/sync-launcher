import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool darkTheme = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Path to Steam installation',
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Path to Epic installation',
          ),
        ),
        const SizedBox(height: 25),
        SwitchListTile(
          contentPadding: const EdgeInsets.only(left: 5.0, right: 5.0),
          title: const Row(
            children: [
              Icon(Icons.dark_mode),
              SizedBox(width: 12.5),
              Expanded(child: Text('Dark Theme')),
            ],
          ),
          value: darkTheme,
          onChanged: (bool value) {
            setState(() {
              darkTheme = !darkTheme;
            });
          },
        ),
        const SizedBox(height: 25),
        Text(
          'Connected controllers (0/0)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
