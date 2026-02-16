import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// A reusable widget for displaying device images with caching support.
/// 
/// This widget handles:
/// - Disk caching for network images
/// - Loading placeholders with spinner
/// - Error fallback with icon
/// - Local asset images
class DeviceCachedImage extends StatelessWidget {
  const DeviceCachedImage({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.iconSize = 25,
    this.backgroundColor = Colors.white,
  });

  /// The URL or asset path of the image
  final String? imageUrl;
  
  /// The size of the circular image container
  final double size;
  
  /// The size of the fallback icon
  final double iconSize;
  
  /// The background color of the container
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: backgroundColor,
        child: _buildImageContent(),
      ),
    );
  }

  Widget _buildImageContent() {
    // Handle null or non-HTTP images
    if (imageUrl == null || !imageUrl!.startsWith('http')) {
      return Icon(
        Icons.devices,
        size: iconSize,
        color: AppColors.primary,
      );
    }

    // Use CachedNetworkImage for HTTP URLs
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.primary.withValues(alpha: 0.1),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(
          Icons.devices,
          size: iconSize,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
