import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Barra de progreso premium con indicador de pasos y gradiente animado.
class DiagnosticProgressBar extends StatelessWidget {
  const DiagnosticProgressBar({
    super.key,
    required this.progress,
    required this.currentStep,
  });

  final double progress;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    final screenWidth = MediaQuery.of(context).size.width - (AppSpacing.md * 2);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.brMd,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: paso + porcentaje con indicador visual
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B8BF6), AppColors.primary],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$currentStep',
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Paso $currentStep',
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              // Porcentaje badge
              AnimatedContainer(
                duration: AppDurations.normal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: percent == 100
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: percent == 100
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Barra de progreso con glow effect
          Stack(
            children: [
              // Fondo
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Relleno animado con glow
              AnimatedContainer(
                duration: AppDurations.normal,
                curve: Curves.easeInOut,
                height: 6,
                width: screenWidth * progress.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: percent == 100
                        ? [const Color(0xFF22C55E), const Color(0xFF16A34A)]
                        : [const Color(0xFF60A5FA), AppColors.primary],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (percent == 100
                              ? AppColors.success
                              : AppColors.primary)
                          .withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
