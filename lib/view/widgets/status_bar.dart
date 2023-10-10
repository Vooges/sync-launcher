import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
        IconButton(
          onPressed: (){
            // TODO: Check what this should do: go to home screen, go to settings or open a side menu?
          }, 
          icon: Image.asset(
            'assets/images/logo/small_rounded.png', 
            height: 60, 
            width: 60)
        ),
        const Spacer(),
        IconButton(
          onPressed: (){
            // TODO: Check if this actually needs to do anything, or if it is just an informative thing.
          }, 
          icon: const Icon(Icons.network_wifi_3_bar), 
          color: Colors.white,
          iconSize: 25,
        ),
        IconButton(
          onPressed: (){
            // TODO: Go to the chat page.
          }, 
          icon: const Icon(Icons.chat), 
          color: Colors.white,
          iconSize: 25,
        ),
        StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Text(
              DateFormat('HH:mm').format(DateTime.now()),
              style: const TextStyle(fontSize: 18),
            );
          },
        ),
        IconButton(
          onPressed: (){
            // TODO: Go to account page.
          }, 
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/profile/garf.jpg', 
              height: 60, 
              width: 60
            )
          )
        )
      ],
    );
  }
}