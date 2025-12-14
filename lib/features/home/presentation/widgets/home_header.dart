import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Header del homepage con logo y acciones
class HomeHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const HomeHeader({
    super.key,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Image.asset(
          'assets/images/stiv-logo-blue.png',
          height: 50,
        ),
        const SizedBox(width: AppSpacing.sm),
        const Text(
          'Stiv',
          style: AppTextStyles.h2,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.settings_outlined,
          onTap: onSettingsTap ?? () {
            // TODO: Navegar a configuración
          },
        ),
        const SizedBox(width: AppSpacing.md),
        _ActionButton(
          icon: Icons.logout,
          onTap: onLogoutTap,
        ),
      ],
    );
  }
}

/// Botón de acción del header con efecto de ripple
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.brMd,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

