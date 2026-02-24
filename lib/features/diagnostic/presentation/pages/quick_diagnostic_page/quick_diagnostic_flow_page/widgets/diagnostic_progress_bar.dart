import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Indicador de progreso premium estilo dashboard técnico.
///
/// Muestra "Paso X" con puntos interactivos y una barra animada con glow.
class DiagnosticProgressBar extends StatelessWidget {
  const DiagnosticProgressBar({
    super.key,
    required this.progress,
    required this.currentStep,
    this.totalSteps = 5,
  });

  final double progress;
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    final isDone = percent == 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label row ──────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Paso $currentStep',
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'de $totalSteps',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            // Percentage pill
            AnimatedContainer(
              duration: AppDurations.normal,
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isDone
                    ? const Color(0xFF22C55E).withValues(alpha: 0.12)
                    : AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                isDone ? '✓ Completado' : '$percent%',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: isDone
                      ? const Color(0xFF16A34A)
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ── Animated bar ────────────────────────────────
        LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);

            return Stack(
              children: [
                // Track
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                // Fill
                AnimatedContainer(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  height: 6,
                  width: barWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: isDone
                          ? const [Color(0xFF4ADE80), Color(0xFF16A34A)]
                          : const [Color(0xFF60A5FA), Color(0xFF0663EF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDone
                                ? const Color(0xFF22C55E)
                                : AppColors.primary)
                            .withValues(alpha: 0.45),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 12),

    
      ],
    );
  }
}
