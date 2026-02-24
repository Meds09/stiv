import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class OptionIcon extends StatelessWidget {
  const OptionIcon({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.isAi,
    required this.index,
  });

  final IconData? icon;
  final bool isSelected;
  final bool isAi;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Color bg = isSelected
        ? AppColors.primary.withValues(alpha: 0.12)
        : isAi
            ? const Color(0xFF9B72CB).withValues(alpha: 0.10)
            : AppColors.primary.withValues(alpha: 0.05);

    final Color defaultIconColor = isSelected
        ? AppColors.primary
        : AppColors.primary.withValues(alpha: 0.7);

    // Si no hay icono, usamos letras: A, B, C, D...
    final String letter = String.fromCharCode('A'.codeUnitAt(0) + index);

    return AnimatedContainer(
      duration: AppDurations.fast,
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: isSelected
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
                width: 1.0,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: isAi && icon != null
          ? ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => AppColors.aiGradient.createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 24),
            )
          : icon != null
              ? Icon(icon, color: defaultIconColor, size: 24)
              : Text(
                  letter,
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: defaultIconColor,
                  ),
                ),
    );
  }
}
