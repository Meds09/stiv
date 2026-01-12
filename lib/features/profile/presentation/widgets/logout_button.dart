import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Botón de cerrar sesión con estado de carga
class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;


  const LogoutButton({
    super.key,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadii.brMd,
        boxShadow: AppShadows.soft,
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadii.brMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.brMd,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const Icon(
                    Icons.logout,
                    color: AppColors.danger,
                    size: 20,
                  ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Cerrar sesión',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

