import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/profile/presentation/widgets/settings_card.dart';

/// Sección de configuración con opciones del perfil
class SettingsSection extends StatelessWidget {
  final VoidCallback? onEditProfile;
  final VoidCallback? onNotifications;
  final VoidCallback? onPrivacy;

  const SettingsSection({
    super.key,
    this.onEditProfile,
    this.onNotifications,
    this.onPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsCard(
          icon: Icons.edit_outlined,
          title: 'Editar perfil',
          subtitle: 'Actualiza tu información personal',
          onTap: onEditProfile ?? (){}
        ),
        const SizedBox(height: AppSpacing.sm),
        SettingsCard(
          icon: Icons.notifications_outlined,
          title: 'Notificaciones',
          subtitle: 'Gestiona tus preferencias',
          onTap: onNotifications ?? () {
            // TODO: Navegar a configuración de notificaciones
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        SettingsCard(
          icon: Icons.security_outlined,
          title: 'Privacidad y seguridad',
          subtitle: 'Controla tu privacidad',
          onTap: onPrivacy ?? () {
            // TODO: Navegar a privacidad
          },
        ),
      ],
    );
  }
}

