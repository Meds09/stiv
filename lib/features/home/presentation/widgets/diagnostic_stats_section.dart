import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/home/models/diagnostic_stats.dart';
import 'package:stiv/features/home/presentation/providers/home_stats_provider.dart';
import 'package:stiv/features/home/presentation/widgets/stat_item_card.dart';

/// Sección tipo dashboard para métricas clave de diagnóstico
class DiagnosticStatsSection extends ConsumerWidget {
  const DiagnosticStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(homeStatsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(AppSpacing.sm), // Reducido iterativamente 
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.brMd,

          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
              child: Text(
                'Estadísticas clave',
                style: AppTextStyles.h2,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            statsAsync.when(
              data: (stats) => _buildStatsDashboard(stats),
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsDashboard(DiagnosticStats stats) {
    return Row(

      children: [
        Expanded(
          
          child: StatItemCard(
            icon: Icons.devices,
            value: stats.totalDevices,
            label: 'Total Dispositivos',
            color: AppColors.primary,
            isPrimary: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: StatItemCard(
            icon: Icons.analytics,
            value: stats.totalDiagnostics,
            label: 'Total Diagnósticos',
            color: AppColors.info,
            isPrimary: true,
          ),
        ),
      ].animate(interval: const Duration(milliseconds: 150))
       .fade(duration: const Duration(milliseconds: 500))
       .slideY(begin: 0.1, duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic),
    );
  }

  Widget _buildLoadingState() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadii.brMd,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadii.brMd,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadii.brMd,
      ),
      child: const Text(
        'Error al cargar estadísticas',
        style: AppTextStyles.body,
      ),
    );
  }
}
