import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sync_launcher/state/settings_state.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsState>();

    return ListView(
      children: [
        TextFormField(
          initialValue: settingsState.steamBasePath ?? '',
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Path to Steam installation',
          ),
          onChanged: (text) {
            settingsState.steamBasePath = text;
            settingsState.save();
          },
        ),
        TextFormField(
          initialValue: settingsState.epicBasePath ?? '',
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Path to Epic installation',
          ),
          onChanged: (text) {
            settingsState.epicBasePath = text;
            settingsState.save();
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
