import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/auth/providers/auth_provider.dart';
import 'package:stiv/features/diagnostic/domain/entities/ai_chat_context.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_result.dart';
import 'package:stiv/features/diagnostic/presentation/pages/ai_chat_page/ai_chat_page.dart';


/// Página de resultado del diagnóstico DSS.
///
/// Muestra la causa probable, nivel de confianza, acciones recomendadas
/// y opción de escalación a IA si la confianza es baja.
class DiagnosticResultPage extends ConsumerWidget {
  const DiagnosticResultPage({
    super.key,
    required this.result,
    this.deviceName,
    this.symptomLabel,
  });

  final DiagnosticResult result;
  /// Nombre del dispositivo específico (null cuando viene del quick diagnostic).
  final String? deviceName;
  /// Etiqueta del síntoma seleccionado (null cuando viene del quick diagnostic).
  final String? symptomLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _ResultHeader(result: result),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ConfidenceCard(result: result),
                    const SizedBox(height: AppSpacing.md),
                    _RecommendationsCard(result: result),
                    if (result.requiresAiEscalation) ...[
                      const SizedBox(height: AppSpacing.md),
                      _AiEscalationBanner(),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    _ActionButtons(
                      result: result,
                      deviceName: deviceName,
                      symptomLabel: symptomLabel,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.result});
  final DiagnosticResult result;

  @override
  Widget build(BuildContext context) {
    final isHigh = result.level == ConfidenceLevel.high;
    final isMedium = result.level == ConfidenceLevel.medium;
    final isEscalated = result.level == ConfidenceLevel.escalated;

    final Color headerColor = isHigh
        ? const Color(0xFF16A34A)
        : isMedium
            ? const Color(0xFFD97706)
            : isEscalated
                ? AppColors.primary
                : const Color(0xFFDC2626);

    final IconData headerIcon = isHigh
        ? Icons.check_circle_rounded
        : isMedium
            ? Icons.info_rounded
            : isEscalated
                ? Icons.auto_awesome
                : Icons.warning_amber_rounded;

    final String title = isHigh
        ? '¡Diagnóstico completado!'
        : isMedium
            ? 'Diagnóstico probable'
            : isEscalated
                ? 'Se recomienda asistencia IA'
                : 'Diagnóstico incierto';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: headerColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(headerIcon, color: headerColor, size: 36),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (result.probableCause != null) ...[
            const SizedBox(height: 4),
            Text(
              result.probableCause!.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: headerColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Confidence Card ─────────────────────────────────────────────────────────

class _ConfidenceCard extends StatelessWidget {
  const _ConfidenceCard({required this.result});
  final DiagnosticResult result;

  Color get _barColor {
    switch (result.level) {
      case ConfidenceLevel.high:
        return const Color(0xFF16A34A);
      case ConfidenceLevel.medium:
        return const Color(0xFFD97706);
      case ConfidenceLevel.low:
        return const Color(0xFFDC2626);
      case ConfidenceLevel.escalated:
        return AppColors.primary;
    }
  }

  String get _levelLabel {
    switch (result.level) {
      case ConfidenceLevel.high:
        return 'Alta confianza';
      case ConfidenceLevel.medium:
        return 'Confianza media';
      case ConfidenceLevel.low:
        return 'Confianza baja';
      case ConfidenceLevel.escalated:
        return 'Evidencia insuficiente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.brMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nivel de confianza',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _barColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _levelLabel,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: _barColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: result.confidenceScore.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: _barColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${result.confidencePercent}% de confianza diagnóstica',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          if (result.probableCause?.description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                result.probableCause!.description,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Recommendations Card ─────────────────────────────────────────────────────

class _RecommendationsCard extends StatelessWidget {
  const _RecommendationsCard({required this.result});
  final DiagnosticResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.brMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.build_rounded,
                    color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 10),
              const Text(
                'Acciones recomendadas',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...result.recommendations.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}


// ─── AI Escalation Banner ─────────────────────────────────────────────────────

class _AiEscalationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadii.brMd,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A56DB), Color(0xFF6C2BD9)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: AppRadii.brMd,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.20),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Requiere soporte especializado!',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'El diagnóstico automático no pudo determinar la causa con certeza.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Usa el botón "Consultar con IA" de abajo para obtener un análisis detallado con inteligencia artificial.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons({
    required this.result,
    this.deviceName,
    this.symptomLabel,
  });
  final DiagnosticResult result;
  final String? deviceName;
  final String? symptomLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (result.requiresAiEscalation)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.brMd),
              elevation: 0,
            ),
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text(
              'Consultar con IA',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              final user = ref.read(currentUserProvider);
              final name = user?.displayName?.split(' ').first ?? 'Técnico';
              // Usa el nombre real del dispositivo si viene de un diagnóstico
              // específico, de lo contrario usa la causa probable del DSS.
              final ctx = AiChatContext(
                deviceType: deviceName ?? result.probableCause?.label ?? 'Dispositivo',
                symptomLabel: symptomLabel ?? result.probableCause?.description,
                userName: name,
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AiChatPage(chatContext: ctx),
                ),
              );
            },
          ),
        if (result.requiresAiEscalation) const SizedBox(height: 10),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: AppColors.border, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: AppRadii.brMd),
          ),
          onPressed: () => context.go('/home'),
          child: const Text(
            'Volver al inicio',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
