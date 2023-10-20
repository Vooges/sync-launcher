import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:sync_launcher/models/dlc_info.dart';

class OwnedDLCWidget extends StatelessWidget {
  final List<DLCInfo> ownedDLC;

  const OwnedDLCWidget({super.key, required this.ownedDLC});
  
  @override
  Widget build(BuildContext context) {
    if (ownedDLC.isEmpty){
      return const Expanded(child: Column());
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Owned DLC',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 36
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: ownedDLC.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
              itemBuilder: (context, i) {
                DLCInfo dlcInfo = ownedDLC[i];

                return ImageResolver.createImage(imageType: ImageType.header, height: 230, width: 125, path: dlcInfo.imagePath);
              }
            )
          )
        ]
      )
    );
    
  }
}