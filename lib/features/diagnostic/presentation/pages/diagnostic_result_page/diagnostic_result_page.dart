import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_result.dart';

/// Página de resultado del diagnóstico DSS.
///
/// Muestra la causa probable, nivel de confianza, acciones recomendadas
/// y opción de escalación a IA si la confianza es baja.
class DiagnosticResultPage extends ConsumerWidget {
  const DiagnosticResultPage({super.key, required this.result});

  final DiagnosticResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
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
                    if (result.allScores.length > 1) ...[
                      const SizedBox(height: AppSpacing.md),
                      _HypothesisRankingCard(result: result),
                    ],
                    if (result.requiresAiEscalation) ...[
                      const SizedBox(height: AppSpacing.md),
                      _AiEscalationBanner(),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    _ActionButtons(result: result),
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
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.xl, AppSpacing.md, AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
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

// ─── Hypothesis Ranking Card ──────────────────────────────────────────────────

class _HypothesisRankingCard extends StatelessWidget {
  const _HypothesisRankingCard({required this.result});
  final DiagnosticResult result;

  @override
  Widget build(BuildContext context) {
    final sorted = result.allScores.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sorted.isEmpty) return const SizedBox.shrink();

    final total = sorted.fold(0.0, (acc, e) => acc + e.value);

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
          const Text(
            'Otras hipótesis evaluadas',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...sorted.take(4).map((entry) {
            final pct = total == 0 ? 0.0 : entry.value / total;
            final isWinner = entry.key == result.probableCause?.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight:
                          isWinner ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 12,
                      color: isWinner
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: pct.clamp(0.0, 1.0),
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: isWinner
                                ? AppColors.primary
                                : AppColors.textSecondary.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: AppRadii.brMd,
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asistencia con IA disponible',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'La evidencia recopilada es insuficiente. La IA puede ayudarte a profundizar el diagnóstico.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.result});
  final DiagnosticResult result;

  @override
  Widget build(BuildContext context) {
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
              // TODO: integrar con el módulo de IA en una fase posterior
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
