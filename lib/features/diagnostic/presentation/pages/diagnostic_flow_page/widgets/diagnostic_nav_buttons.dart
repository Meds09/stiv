import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Botones de navegación "Atrás" / "Siguiente" del flujo de diagnóstico.
class DiagnosticNavButtons extends StatelessWidget {
  const DiagnosticNavButtons({
    super.key,
    required this.onBack,
    required this.onNext,
    required this.isBackEnabled,
    required this.isNextEnabled,
    this.isLastStep = false,
  });

  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool isBackEnabled;
  final bool isNextEnabled;
  final bool isLastStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Botón Atrás
            Expanded(
              child: AnimatedOpacity(
                duration: AppDurations.fast,
                opacity: isBackEnabled ? 1.0 : 0.4,
                child: OutlinedButton.icon(
                  onPressed: isBackEnabled ? onBack : null,
                  style: AppButtonStyles.outline.copyWith(
                    padding: WidgetStatePropertyAll(
                      const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Atrás'),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Botón Siguiente
            Expanded(
              flex: 2,
              child: AnimatedOpacity(
                duration: AppDurations.fast,
                opacity: isNextEnabled ? 1.0 : 0.5,
                child: ElevatedButton.icon(
                  onPressed: isNextEnabled ? onNext : null,
                  style: AppButtonStyles.primary.copyWith(
                    padding: WidgetStatePropertyAll(
                      const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  icon: Icon(
                    isLastStep
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                  label: Text(isLastStep ? 'Finalizar' : 'Siguiente'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
