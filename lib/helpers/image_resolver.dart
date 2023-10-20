import 'dart:io';

import 'package:flutter/widgets.dart';

class ImageResolver {
  /// Creates an image widget from a path.
  /// 
  /// If the supplied path is an url, it will produce a NetworkImage. If the supplied
  /// path is an actual path, it will create a FileImage. Finally, if no path is
  /// supplied, it will create an AssetImage with a default image containing the 
  /// Sync logo. The imageType is used to provide the correct fallback image.
  static Image createImage({
    required ImageType imageType, 
    String? path, 
    double? height, 
    double? width, 
    BoxFit? fit, 
    Animation<double>? opacity, 
    BlendMode? colorBlendMode, 
    Color? color
  }){
    // This image is also used as a fallback in case the url or path can't be resolved. 
    Image defaultImage = Image.asset(
      'assets/images/default/${imageType.name}.png',
      width: width,
      height: height,
      fit: fit,
      opacity: opacity,
      color: color,
      colorBlendMode: colorBlendMode,
    );

    Image image;

    // TODO: Handle SVGs.
    if (path != null){
      if (Uri.parse(path).host.isNotEmpty) { // path is an URL.
        image = Image.network(
          path,
          width: width,
          height: height,
          fit: fit,
          opacity: opacity,
          color: color,
          colorBlendMode: colorBlendMode,
          errorBuilder: ((context, error, stackTrace) {
            return defaultImage;
          })
        );
      } else if(path.startsWith('assets')){ // path points to an asset.
        image = Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          opacity: opacity,
          color: color,
          colorBlendMode: colorBlendMode,
          errorBuilder: ((context, error, stackTrace) {
            return defaultImage;
          })
        );
      } else {
        image = Image.file(
          File(path),
          width: width,
          height: height,
          fit: fit,
          opacity: opacity,
          color: color,
          colorBlendMode: colorBlendMode,
          errorBuilder: ((context, error, stackTrace) {
            return defaultImage;
          })
        );
      }
    } else {
      image = defaultImage;
    }

    return image;
  }
}

enum ImageType {icon, grid, hero, header}