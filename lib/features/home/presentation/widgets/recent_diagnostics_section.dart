import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/home/models/recent_diagnostic.dart';
import 'package:stiv/features/home/presentation/providers/recent_diagnostics_provider.dart';

/// Sección que muestra los diagnósticos recientes
class RecentDiagnosticsSection extends ConsumerWidget {
  const RecentDiagnosticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosticsAsync = ref.watch(recentDiagnosticsProvider);

    return diagnosticsAsync.when(
      data: (diagnostics) {
        if (diagnostics.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildDiagnosticsList(diagnostics);
      },
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(),
    );
  }

  Widget _buildDiagnosticsList(List<RecentDiagnostic> diagnostics) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Diagnósticos recientes',
                style: AppTextStyles.h2,
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navegar a historial completo
                },
                child: const Text(
                  'Ver todo',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...diagnostics.map((diagnostic) => _DiagnosticCard(
                diagnostic: diagnostic,
              )),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Diagnósticos recientes',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: AppSpacing.md),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadii.brMd,
                ),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return const SizedBox.shrink();
  }
}

/// Tarjeta individual de diagnóstico reciente
class _DiagnosticCard extends StatelessWidget {
  final RecentDiagnostic diagnostic;

  const _DiagnosticCard({required this.diagnostic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.brMd,
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          _buildStatusIndicator(),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diagnostic.deviceName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  diagnostic.deviceType,
                  style: AppTextStyles.caption,
                ),
                if (diagnostic.issueFound != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    diagnostic.issueFound!,
                    style: AppTextStyles.caption.copyWith(
                      color: _getStatusColor(),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(diagnostic.date),
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 4,
      height: 50,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Color _getStatusColor() {
    switch (diagnostic.status) {
      case DiagnosticStatus.success:
        return AppColors.success;
      case DiagnosticStatus.warning:
        return AppColors.warning;
      case DiagnosticStatus.error:
        return AppColors.danger;
      case DiagnosticStatus.pending:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (diagnostic.status) {
      case DiagnosticStatus.success:
        return Icons.check_circle;
      case DiagnosticStatus.warning:
        return Icons.warning;
      case DiagnosticStatus.error:
        return Icons.error;
      case DiagnosticStatus.pending:
        return Icons.pending;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes}m';
      }
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return DateFormat('dd/MM').format(date);
    }
  }
}

