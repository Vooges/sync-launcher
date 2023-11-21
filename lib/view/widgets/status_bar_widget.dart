import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sync_launcher/state/selected_view_state.dart';
import 'package:sync_launcher/view/home_view.dart';
import 'package:sync_launcher/view/settings_view.dart';

class StatusBarWidget extends StatelessWidget {
  const StatusBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff1D1A1A),
        child: Row(
          children: <Widget>[
            IconButton(
              // Logo
              onPressed: () {
                context.read<SelectedViewState>().setView(HomeView());
              },
              icon: Image.asset(
                'assets/images/logo/small_rounded.png',
                height: 60,
                width: 60,
              ),
            ),
            const Spacer(),
            IconButton(
              // Settings icon
              onPressed: () {
                context.read<SelectedViewState>().setView(SettingsView());
              },
              icon: const Icon(Icons.settings),
              color: Colors.white,
              iconSize: 25,
            ),
            IconButton(
              // Network icon
              onPressed: () {
                // TODO: Check if this actually needs to do anything, or if it is just an informative thing.
              },
              icon: const Icon(Icons.network_wifi),
              color: Colors.white,
              iconSize: 25,
            ),
            IconButton(
              // Notification icon
              onPressed: () {
                // TODO: Go to the chat page.
              },
              icon: const Icon(Icons.chat),
              color: Colors.white,
              iconSize: 25,
            ),
            StreamBuilder(
              // Clock
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Text(
                  DateFormat('HH:mm').format(DateTime.now()),
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            IconButton(
                // Account image
                onPressed: () {
                  // TODO: Go to account page.
                },
                icon: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset('assets/images/profile/garf.jpg',
                        height: 60, width: 60)))
          ],
        ));
  }
}
