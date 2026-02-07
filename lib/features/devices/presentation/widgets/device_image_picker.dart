import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/core/utils/image_utils.dart';

class DeviceImagePicker extends StatelessWidget {
  final String? imageUrl;
  final XFile? localImage;
  final double radius;
  final bool showEditBadge;
  final VoidCallback? onEditTap;

  const DeviceImagePicker({
    super.key,
    this.imageUrl,
    this.localImage,
    this.radius = 60,
    this.showEditBadge = true,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    
    if (localImage != null) {
      imageProvider = FileImage(File(localImage!.path));
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageProvider = imageUrl!.toImageProvider;
    }

    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: AppColors.background,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? Icon(
                      Icons.devices_other,
                      size: radius,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    )
                  : null,
            ),
          ),
          if (showEditBadge)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
