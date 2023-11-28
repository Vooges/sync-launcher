import 'package:flutter/material.dart';
import 'package:sync_launcher/helpers/image_resolver.dart';
import 'package:sync_launcher/models/dlc_info.dart';

class OwnedDLCWidget extends StatelessWidget {
  final List<DLCInfo> ownedDLC;

  const OwnedDLCWidget({super.key, required this.ownedDLC});
  
  @override
  Widget build(BuildContext context) {
    const double width = 230;
    const double height = width / 2;

    if (ownedDLC.isEmpty){
      return const Expanded(child: Column());
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Owned DLC',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              itemCount: ownedDLC.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                childAspectRatio: 2.1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10
              ), 
              itemBuilder: (context, i) {
                DLCInfo dlcInfo = ownedDLC[i];

                return ImageResolver.createImageWithTextOnFallback(
                  imageType: ImageType.header, 
                  path: dlcInfo.imagePath,
                  fallbackText: dlcInfo.title,
                  textStyle: Theme.of(context).textTheme.displaySmall
                );
              }
            )
          )
        ]
      )
    );
    
  }
}