import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
        IconButton(
          onPressed: (){}, 
          icon: Image.asset(
            'assets/images/logo/small_rounded.png', 
            height: 60, 
            width: 60)
        ),
        const Spacer(),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.network_wifi_3_bar), 
          color: Colors.white
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.chat), 
          color: Colors.white
        ),
        StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Text(DateFormat('HH:mm').format(DateTime.now()));
          },
        ),
        IconButton(
          onPressed: (){}, 
          icon: Image.asset(
            'assets/images/profile/garf.jpg', 
            height: 60, 
            width: 60
          )
        )
      ],
    );

    return AppBar(
      leading: IconButton(
        onPressed: (){}, 
        icon: Image.asset('assets/images/logo/small_rounded.png')
      ),
      leadingWidth: 80,
      toolbarHeight: 70,
      //title: Image.asset('assets/images/logo/small_rounded.png', height: 60, width: 60),
      actions: <Widget>[
        IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.network_wifi_3_bar), 
          color: Colors.white
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.chat), 
          color: Colors.white
        ),
        StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Text(DateFormat('HH:mm').format(DateTime.now()));
          },
        ),
        IconButton(
          onPressed: (){}, 
          icon: Image.asset('assets/images/profile/garf.jpg', 
            height: 60, 
            width: 60
          )
        )
      ],
      backgroundColor: Colors.black,
    );
  }

}