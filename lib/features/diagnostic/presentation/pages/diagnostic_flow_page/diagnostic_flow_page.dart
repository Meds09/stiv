import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/router/router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/pages/diagnostic_flow_page/widgets/diagnostic_progress_bar.dart';
import 'package:stiv/features/diagnostic/presentation/pages/diagnostic_flow_page/widgets/question_option_card.dart';
import 'package:stiv/features/diagnostic/presentation/providers/diagnostic_flow_provider.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

// ─── Metadata maps ─────────────────────────────────────────────────────────────

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

const _symptomDescriptions = <String, String>{
  'power_issue': 'El equipo no enciende o no da señales de energía',
  'connectivity_issue': 'No se detecta red o la conexión es inestable',
  'display_issue': 'La imagen se ve borrosa, con ruido o sin video',
  'audio_issue': 'Se escuchan sonidos inusuales en el hardware',
  'camera_issue': 'La cámara no graba, no conecta o no muestra imagen',
  'other_issue': 'Otro problema no listado — asistencia con IA',
};

// ─── Main page ────────────────────────────────────────────────────────────────

class DiagnosticFlowPage extends ConsumerStatefulWidget {
  const DiagnosticFlowPage({super.key, required this.symptomId});
  final String symptomId;

  @override
  ConsumerState<DiagnosticFlowPage> createState() => _DiagnosticFlowPageState();
}

class _DiagnosticFlowPageState extends ConsumerState<DiagnosticFlowPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diagnosticFlowProvider(widget.symptomId));
    final notifier = ref.read(diagnosticFlowProvider(widget.symptomId).notifier);
    final question = state.currentQuestion;
    final symptomLabel = _symptomLabels[widget.symptomId] ?? 'Diagnóstico';
    final symptomIcon =
        _symptomIcons[widget.symptomId] ?? Icons.medical_services_outlined;
    final symptomDesc = _symptomDescriptions[widget.symptomId] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE4),
      body: question == null
          ? _buildEmptyState()
          : FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SafeArea(
                  child: Column(
                    children: [
                      // ── Header ──────────────────────────────
                      _FlowHeader(
                        label: symptomLabel,
                        description: symptomDesc,
                        icon: symptomIcon,
                        onClose: () => _showExitDialog(),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // ── Progress ─────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: DiagnosticProgressBar(
                          progress: state.progress,
                          currentStep: state.currentStep,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // ── Question + Options ────────────────────
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 320),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.03, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeOutCubic,
                              )),
                              child: child,
                            ),
                          ),
                          child: _QuestionContent(
                            key: ValueKey(question.id),
                            question: question,
                            selectedOptionId: state.currentSelectedOptionId,
                            onOptionSelected: (optionId) {
                              final done =
                                  notifier.selectAndAdvance(optionId);
                              if (done) _showCompletionDialog();
                            },
                          ),
                        ),
                      ),

                      // ── Back button ───────────────────────────
                      AnimatedSize(
                        duration: AppDurations.normal,
                        curve: Curves.easeOut,
                        child: state.isFirstQuestion
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.md,
                                  0,
                                  AppSpacing.md,
                                  AppSpacing.md,
                                ),
                                child: _BackButton(
                                  onPressed: notifier.goBack,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────────

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: _StyledDialog(
            icon: Icons.exit_to_app_rounded,
            iconColor: AppColors.danger,
            title: '¿Salir del diagnóstico?',
            body:
                'Perderás el progreso actual y tendrás que empezar de nuevo.',
            actions: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.brMd),
                    ),
                    child: const Text('Continuar',
                        style: TextStyle(
                            fontFamily: 'Rubik', fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.brMd),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      router.pop();
                    },
                    child: const Text('Salir',
                        style: TextStyle(
                            fontFamily: 'Rubik', fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: _StyledDialog(
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xFF22C55E),
            title: '¡Diagnóstico completado!',
            body:
                'Hemos recopilado la información necesaria.\nEn la siguiente fase verás las recomendaciones personalizadas.',
            actions: SizedBox(
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
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    size: 48, color: AppColors.warning),
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

// ─── Header ───────────────────────────────────────────────────────────────────

class _FlowHeader extends StatelessWidget {
  const _FlowHeader({
    required this.label,
    required this.description,
    required this.icon,
    required this.onClose,
  });

  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Large icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 26),
          ),

          const SizedBox(width: 14),

          // Title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Close
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Back button ──────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: AppRadii.brMd,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_ios_rounded,
              size: 13,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 6),
            Text(
              'Pregunta anterior',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Styled Dialog ────────────────────────────────────────────────────────────

class _StyledDialog extends StatelessWidget {
  const _StyledDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.actions,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 40,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          actions,
        ],
      ),
    );
  }
}

// ─── Question content ─────────────────────────────────────────────────────────

class _QuestionContent extends StatelessWidget {
  const _QuestionContent({
    super.key,
    required this.question,
    required this.selectedOptionId,
    required this.onOptionSelected,
  });

  final DiagnosticQuestion question;
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
          // Question label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Selecciona la opción que corresponda',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: AppColors.primary,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Question text
          Text(
            question.text,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),

          if (question.subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              question.subtitle!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          // Options list
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

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
