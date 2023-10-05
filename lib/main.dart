
import 'package:flutter/material.dart';
import 'package:sync_launcher/view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sync',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const SyncScaffold(),
    );
  }
}

class SyncScaffold extends StatelessWidget {
  const SyncScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sync'),
      ),
      body: const SafeArea(
        child: HomeView(),
      ),
    );
  }
}
