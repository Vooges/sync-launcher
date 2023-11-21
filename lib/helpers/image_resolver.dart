import 'dart:io';

import 'package:flutter/material.dart';

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
    Image fallback = Image.asset(
      'assets/images/default/${imageType.name}.png',
      width: width,
      height: height,
      fit: fit,
      opacity: opacity,
      color: color,
      colorBlendMode: colorBlendMode,
    );

    return _createImage(
      imageType: imageType, 
      fallback: fallback,
      path: path,
      height: height,
      width: width,
      fit: fit,
      opacity: opacity,
      color: color,
      colorBlendMode: colorBlendMode
    ) as Image;
  }

  static Widget createImageWithTextOnFallback({
    required ImageType imageType, 
    required String fallbackText,
    required BuildContext context,
    String? path, 
    double? height, 
    double? width, 
    BoxFit? fit, 
    Animation<double>? opacity, 
    BlendMode? colorBlendMode, 
    Color? color
  }){
    Widget fallback = Stack(
      children: [
        Image.asset(
          'assets/images/default/${imageType.name}.png',
          width: width,
          height: height,
          fit: fit,
          opacity: opacity,
          color: color,
          colorBlendMode: colorBlendMode,
        ),
        Padding(
          padding: const EdgeInsets.all(10), 
          child: Text(
            fallbackText, 
            style: Theme.of(context).textTheme.displaySmall,
          ),
        )
      ],
    );

    return _createImage(
      imageType: imageType, 
      fallback: fallback,
      path: path,
      height: height,
      width: width,
      fit: fit,
      opacity: opacity,
      color: color,
      colorBlendMode: colorBlendMode
    );
  }

  static Widget _createImage({
    required ImageType imageType, 
    required Widget fallback,
    String? path, 
    double? height, 
    double? width, 
    BoxFit? fit, 
    Animation<double>? opacity, 
    BlendMode? colorBlendMode, 
    Color? color,
  }){
    Widget image;

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
            return fallback;
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
            return fallback;
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
            return fallback;
          })
        );
      }
    } else {
      image = fallback;
    }

    return image;
  }
}

enum ImageType {icon, grid, hero, header}