import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/data/device_symptom_mapper.dart';
import 'package:stiv/features/diagnostic/presentation/pages/device_page/widgets/card_problem.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';
import 'package:stiv/features/diagnostic/presentation/providers/problem_providers.dart';
import 'package:stiv/features/diagnostic/presentation/providers/device_diagnostic_flow_provider.dart';

class DiagnosticDeviceBody extends ConsumerWidget {
  const DiagnosticDeviceBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final problemsAsync = ref.watch(problemsBySelectedDeviceProvider);
    final device = ref.watch(selectedDeviceProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              '¿Qué está ocurriendo con el dispositivo?',
              style: AppTextStyles.t1,
            ),
            const SizedBox(height: 10),

            problemsAsync.when(
              error: (e, _) =>
                  const Text('Error al cargar las fallas del dispositivo.'),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (problems) {
                if (problems.isEmpty) {
                  return const Text(
                    'No hay fallas disponibles para este dispositivo.',
                    style: AppTextStyles.h1,
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: problems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final problem = problems[index];

                    return CardProblem(
                      problem: problem,
                      onTap: device == null
                          ? null
                          : () {
                              // Resolver el síntoma correspondiente al problema + categoría
                              final symptom = getSymptomForProblem(
                                device.categoryId,
                                problem.id,
                              );

                              if (symptom == null) return;

                              final params = DeviceDiagnosticParams(
                                deviceId: device.id,
                                deviceName: device.name,
                                categoryId: device.categoryId,
                                startQuestionId: symptom.questionId,
                                symptomKey: symptom.symptomKey,
                                symptomLabel: symptom.label,
                              );

                              context.pushNamed(
                                'device-diagnostic-flow',
                                pathParameters: {'deviceId': device.id},
                                extra: params,
                              );
                            },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
