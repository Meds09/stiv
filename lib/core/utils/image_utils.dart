import 'package:flutter/material.dart';

extension ImageProviderExtension on String {
  /// Returns a [NetworkImage] if the string starts with 'http', 
  /// otherwise returns an [AssetImage].
  ImageProvider get toImageProvider {
    if (startsWith('http')) {
      return NetworkImage(this);
    } else {
      return AssetImage(this);
    }
  }
}
