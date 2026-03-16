import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/router/router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/auth/providers/bottom_nav_bar_provider.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/diagnostic_progress_bar.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/flow_back_button.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/question_content.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/styled_dialog.dart';
import 'package:stiv/features/diagnostic/presentation/pages/diagnostic_result_page/diagnostic_result_page.dart';
import 'package:stiv/features/diagnostic/presentation/providers/device_diagnostic_flow_provider.dart';

/// Página del flujo de diagnóstico contextualizado por dispositivo.
///
/// Recibe [params] con el deviceId, nombre, categoría y el nodo inicial del
/// sub-árbol DSS. Reutiliza todos los widgets del quick diagnostic flow.
class DeviceDiagnosticFlowPage extends ConsumerStatefulWidget {
  const DeviceDiagnosticFlowPage({super.key, required this.params});

  final DeviceDiagnosticParams params;

  @override
  ConsumerState<DeviceDiagnosticFlowPage> createState() =>
      _DeviceDiagnosticFlowPageState();
}

class _DeviceDiagnosticFlowPageState
    extends ConsumerState<DeviceDiagnosticFlowPage>
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
    final params = widget.params;
    final state = ref.watch(deviceDiagnosticFlowProvider(params));
    final notifier =
        ref.read(deviceDiagnosticFlowProvider(params).notifier);
    final question = state.currentQuestion;

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
                      // ── Header ──────────────────────────────────────
                      _DeviceFlowHeader(
                        deviceName: params.deviceName,
                        symptomLabel: params.symptomLabel,
                        onClose: _showExitDialog,
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // ── Progress ─────────────────────────────────────
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

                      // ── Question + Options ────────────────────────────
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
                              final done = notifier.selectAndAdvance(optionId);
                              if (done) _navigateToResult();
                            },
                          ),
                        ),
                      ),

                      // ── Back button ───────────────────────────────────
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

  // ── Dialogs & Navigation ─────────────────────────────────────────────────

  void _navigateToResult() {
    final state =
        ref.read(deviceDiagnosticFlowProvider(widget.params));
    final result = state.result;
    if (result == null) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DiagnosticResultPage(
          result: result,
          deviceName: widget.params.deviceName,
          symptomLabel: widget.params.symptomLabel,
        ),
      ),
    );
  }

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
            body: 'Perderás el progreso actual y tendrás que empezar de nuevo.',
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
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w600)),
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
                      router.go('/home');
                      ref.read(menuIndexProvider.notifier).state = 0;
                    },
                    child: const Text('Salir',
                        style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
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

// ─────────────────────────────────────────────────────────────────────────────
// Header específico para el diagnóstico por dispositivo
// ─────────────────────────────────────────────────────────────────────────────

class _DeviceFlowHeader extends StatelessWidget {
  const _DeviceFlowHeader({
    required this.deviceName,
    required this.symptomLabel,
    required this.onClose,
  });

  final String deviceName;
  final String symptomLabel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.xl + 10, AppSpacing.md, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Device icon
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
            child: const Icon(
              Icons.devices_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          // Device name + symptom
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        symptomLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Close button
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
