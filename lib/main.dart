import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sync_launcher/state/selected_view_state.dart';
import 'package:sync_launcher/view/widgets/status_bar_widget.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SelectedViewState(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData colorTheme = ThemeData(
        colorSchemeSeed: const Color.fromRGBO(116, 17, 178, 100),
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff222020));

    return MaterialApp(
      title: 'Sync',
      theme: colorTheme,
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
  @override
  Widget build(BuildContext context) {
    final selectedViewState = context.watch<SelectedViewState>();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: StatusBarWidget(),
      ),
      body: SafeArea(
        child: selectedViewState.view,
      ),
    );
  }
}
