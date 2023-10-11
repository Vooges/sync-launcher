import 'package:flutter/material.dart';
import 'package:sync_launcher/view/home_view.dart';
import 'package:sync_launcher/view/settings_view.dart';
import 'package:sync_launcher/view/widgets/status_bar.dart';

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
        colorSchemeSeed: const Color.fromRGBO(116, 17, 178, 100),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const SyncScaffold(),
    );
  }
}

class SyncScaffold extends StatefulWidget {
  const SyncScaffold({super.key});

  @override
  State<SyncScaffold> createState() => _SyncScaffoldState();
}

class _SyncScaffoldState extends State<SyncScaffold> {
  int _selectedIndex = 0;

  final views = List.of([HomeView(), const SettingsView()]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: StatusBar()
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: views.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
