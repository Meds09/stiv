import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/login_register/widgets/stiv_text_container.dart';


/// Sección que muestra la información personal del usuario
class ProfileInfoSection extends StatelessWidget {
  final User? user;

  const ProfileInfoSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StivTextContainer(
          suffixIcon: const Icon(
            Icons.email_outlined,
            color: AppColors.primary,
          ),
          text: user?.email ?? 'No disponible',
          title: 'Correo electrónico',
        ),
        const SizedBox(height: AppSpacing.md),
        StivTextContainer(
          suffixIcon: const Icon(
            Icons.phone_outlined,
            color: AppColors.primary,
          ),
          text: user?.phoneNumber ?? 'No registrado',
          title: 'Número de teléfono',
        ),
        const SizedBox(height: AppSpacing.md),
        StivTextContainer(
          suffixIcon: const Icon(
            Icons.badge_outlined,
            color: AppColors.primary,
          ),
          text: user?.displayName ?? 'No disponible',
          title: 'Nombre completo',
        ),
      ],
    );
  }
}

