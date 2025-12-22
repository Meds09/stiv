import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Widget reutilizable para mostrar el avatar del usuario con borde decorativo
class ProfileAvatar extends StatelessWidget {
  final User? user;
  final double radius;
  final bool showEditBadge;
  final VoidCallback? onEditTap;

  const ProfileAvatar({
    super.key,
    required this.user,
    this.radius = 60,
    this.showEditBadge = true,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            backgroundColor: Colors.white,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : null,
            child: user?.photoURL == null
                ? Icon(
                    Icons.person,
                    size: radius,
                    color: AppColors.primary,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

