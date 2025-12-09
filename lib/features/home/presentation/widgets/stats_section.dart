import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/home/models/home_stats.dart';
import 'package:stiv/features/home/presentation/providers/home_stats_provider.dart';
import 'package:stiv/features/home/presentation/widgets/device_stat_card.dart';

/// Sección de estadísticas con tarjetas de dispositivos
class StatsSection extends ConsumerWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(homeStatsProvider);

    return statsAsync.when(
      data: (stats) => _buildStatsList(stats),
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(),
    );
  }

  Widget _buildStatsList(HomeStats stats) {
    final statCards = [
      DeviceStatCardData(
        label: 'Cámaras',
        value: '${stats.cameras}',
        emoji: '📷',
        color: AppColors.primary,
        history: stats.camerasHistory,
        onActionTap: () {
          // TODO: Navegar a diagnóstico de cámaras
        },
        actionLabel: 'Diagnosticar',
      ),
      DeviceStatCardData(
        label: 'Soporte Eléctrico',
        value: '${stats.electricalSupport}',
        emoji: '⚡',
        color: AppColors.warning,
        history: stats.electricalHistory,
        onActionTap: () {
          // TODO: Navegar a diagnóstico de soporte eléctrico
        },
        actionLabel: 'Diagnosticar',
      ),
      DeviceStatCardData(
        label: 'Control de Acceso',
        value: '${stats.accessControl}',
        emoji: '🔐',
        color: AppColors.success,
        history: stats.accessControlHistory,
        onActionTap: () {
          // TODO: Navegar a diagnóstico de control de acceso
        },
        actionLabel: 'Diagnosticar',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estadísticas de Equipos',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: AppSpacing.md),
          ...statCards.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < statCards.length - 1
                    ? AppSpacing.md
                    : 0,
              ),
              child: DeviceStatCard(
                data: entry.value,
                index: entry.key,
              ),
            );
          }),
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
            'Estadísticas de Equipos',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < 2 ? AppSpacing.md : 0,
              ),
              child: Container(
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
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.brMd,
        ),
        child: const Center(
          child: Text(
            'Error al cargar estadísticas',
            style: AppTextStyles.body,
          ),
        ),
      ),
    );
  }
}

