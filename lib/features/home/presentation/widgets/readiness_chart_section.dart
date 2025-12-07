import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/home/presentation/providers/home_stats_provider.dart';
import 'package:stiv/features/home/presentation/widgets/readiness_chart_card.dart';

/// Sección que muestra el gráfico de alistamiento de dispositivos
class ReadinessChartSection extends ConsumerWidget {
  const ReadinessChartSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(homeStatsProvider);

    return statsAsync.when(
      data: (stats) => ReadinessChartCard(
        currentPercentage: stats.readinessPercentage,
        history: stats.readinessHistory,
      ),
      loading: () => _buildLoadingState(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.brLg,
      ),
      child: const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }
}

