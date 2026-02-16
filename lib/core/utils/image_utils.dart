import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

extension ImageProviderExtension on String {
 
  /// Returns a [CachedNetworkImageProvider] if the string starts with 'http',
  /// otherwise returns an [AssetImage].
  /// This enables disk caching for better performance.
  ImageProvider get toCachedImageProvider {
    if (startsWith('http')) {
      return CachedNetworkImageProvider(this);
    } else {
      return AssetImage(this);
    }
  }
}

/// Helper function to pre-cache device images in the background
Future<void> precacheDeviceImage(String imageUrl, BuildContext context) async {
  if (imageUrl.startsWith('http')) {
    try {
      await precacheImage(CachedNetworkImageProvider(imageUrl), context);
    } catch (e) {
      // Silently fail - pre-caching is a performance optimization
      // Images will still load on-demand if pre-caching fails
    }
  }
}