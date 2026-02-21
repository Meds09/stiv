import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/router/router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/pages/diagnostic_flow_page/widgets/diagnostic_progress_bar.dart';
import 'package:stiv/features/diagnostic/presentation/pages/diagnostic_flow_page/widgets/question_option_card.dart';
import 'package:stiv/features/diagnostic/presentation/providers/diagnostic_flow_provider.dart';

/// Etiquetas e iconos legibles de cada síntoma.
const _symptomLabels = <String, String>{
  'power_issue': 'No enciende',
  'connectivity_issue': 'Sin conexión',
  'display_issue': 'Imagen borrosa',
  'audio_issue': 'Ruido extraño',
  'camera_issue': 'Cámara falla',
  'other_issue': 'Otro problema',
};

const _symptomIcons = <String, IconData>{
  'power_issue': Icons.power_settings_new_rounded,
  'connectivity_issue': Icons.wifi_off_rounded,
  'display_issue': Icons.blur_on_rounded,
  'audio_issue': Icons.graphic_eq_rounded,
  'camera_issue': Icons.videocam_off_rounded,
  'other_issue': Icons.help_outline_rounded,
};

/// Página premium del flujo de diagnóstico rápido.
class DiagnosticFlowPage extends ConsumerWidget {
  const DiagnosticFlowPage({super.key, required this.symptomId});

  final String symptomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diagnosticFlowProvider(symptomId));
    final notifier = ref.read(diagnosticFlowProvider(symptomId).notifier);
    final question = state.currentQuestion;
    final symptomLabel = _symptomLabels[symptomId] ?? 'Diagnóstico';
    final symptomIcon = _symptomIcons[symptomId] ?? Icons.medical_services_outlined;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: question == null
          ? _buildEmptyState(context)
          : SafeArea(
              child: Column(
                children: [
                  // ── Header personalizado ──
                  _DiagnosticHeader(
                    label: symptomLabel,
                    icon: symptomIcon,
                    onClose: () => _showExitConfirmation(context),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Progreso ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: DiagnosticProgressBar(
                      progress: state.progress,
                      currentStep: state.currentStep,
                    ),
                  ),

                  // ── Pregunta + Opciones ──
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: AppDurations.normal,
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.04, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            )),
                            child: child,
                          ),
                        );
                      },
                      child: _QuestionContent(
                        key: ValueKey(question.id),
                        question: question,
                        selectedOptionId: state.currentSelectedOptionId,
                        onOptionSelected: (optionId) {
                          final completed =
                              notifier.selectAndAdvance(optionId);
                          if (completed) {
                            _showCompletionDialog(context, ref);
                          }
                        },
                      ),
                    ),
                  ),

                  // ── Botón Atrás (refine) ──
                  if (!state.isFirstQuestion)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        0,
                        AppSpacing.md,
                        AppSpacing.md,
                      ),
                      child: _BackButton(onPressed: notifier.goBack),
                    ),
                ],
              ),
            ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadii.brLg),
          backgroundColor: Colors.white,
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.exit_to_app_rounded,
              color: AppColors.danger,
              size: 28,
            ),
          ),
          title: const Text(
            '¿Salir del diagnóstico?',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Perderás el progreso actual y tendrás que empezar de nuevo.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.brMd,
                      ),
                    ),
                    child: const Text('Continuar'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.brMd,
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      router.pop();
                    },
                    child: const Text('Salir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadii.brLg),
          backgroundColor: Colors.white,
          icon: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.success.withValues(alpha: 0.15),
                  AppColors.success.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 40,
            ),
          ),
          title: const Text(
            '¡Diagnóstico completado!',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Hemos recopilado la información necesaria. '
            'En la siguiente fase podrás ver las recomendaciones '
            'basadas en tus respuestas.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  router.pop();
                },
                child: const Text('Entendido'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: AppColors.warning.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'No hay preguntas disponibles\npara este síntoma.',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: () => router.pop(),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Custom Header ───────────────────────────────────────────────────────────

class _DiagnosticHeader extends StatelessWidget {
  const _DiagnosticHeader({
    required this.label,
    required this.icon,
    required this.onClose,
  });

  final String label;
  final IconData icon;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          // Close
          _HeaderIconButton(
            icon: Icons.close_rounded,
            onTap: onClose,
            tooltip: 'Cerrar diagnóstico',
          ),

          const SizedBox(width: AppSpacing.sm),

          // Icono y título
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.12),
                  AppColors.primary.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagnóstico rápido',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  label,
                  style: AppTextStyles.h3.copyWith(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 20),
          ),
        ),
      ),
    );
  }
}

// ─── Back Button ─────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.brMd,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withValues(alpha: 0.05),
            borderRadius: AppRadii.brMd,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                size: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                'Pregunta anterior',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Question Content ────────────────────────────────────────────────────────

class _QuestionContent extends StatelessWidget {
  const _QuestionContent({
    super.key,
    required this.question,
    required this.selectedOptionId,
    required this.onOptionSelected,
  });

  final dynamic question; // DiagnosticQuestion
  final String? selectedOptionId;
  final void Function(String) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xs),

          // Pregunta
          Text(
            question.text,
            style: AppTextStyles.t1.copyWith(
              fontSize: 22,
              height: 1.35,
            ),
          ),
          if (question.subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              question.subtitle!,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          // Texto guía
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              'Selecciona una opción para continuar',
              style: AppTextStyles.caption.copyWith(
                fontSize: 15,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                letterSpacing: 0.2,
              ),
            ),
          ),

          // Opciones
          ...List.generate(question.options.length, (i) {
            final option = question.options[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: QuestionOptionCard(
                option: option,
                isSelected: option.id == selectedOptionId,
                index: i,
                onTap: () => onOptionSelected(option.id),
              ),
            );
          }),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
