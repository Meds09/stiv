import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/router/router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/diagnostic_progress_bar.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/flow_header.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/flow_back_button.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/styled_dialog.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/question_content.dart';
import 'package:stiv/features/diagnostic/presentation/providers/diagnostic_flow_provider.dart';
import 'package:stiv/features/diagnostic/presentation/pages/diagnostic_result_page/diagnostic_result_page.dart';

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
                      FlowHeader(
                        label: symptomLabel,
                        description: symptomDesc,
                        icon: symptomIcon,
                        onClose: () => _showExitDialog(),
                        gradient: widget.symptomId == 'other_issue' 
                            ? AppColors.aiGradient 
                            : null,
                        highlightColor: widget.symptomId == 'other_issue'
                            ? const Color(0xFF9B72CB)
                            : AppColors.primary,
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
                          totalSteps: state.totalSteps,
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
                          child: QuestionContent(
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
                                child: FlowBackButton(
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
          child: StyledDialog(
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
                      router.go("/home");
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
    final state = ref.read(diagnosticFlowProvider(widget.symptomId));
    final result = state.result;
    if (result != null) {
      // Navigate to the DSS result page.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DiagnosticResultPage(result: result),
        ),
      );
      return;
    }
    // Fallback if result not yet computed (edge case).
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: StyledDialog(
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xFF22C55E),
            title: '¡Diagnóstico completado!',
            body:
                'Hemos recopilado la información necesaria.',
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
