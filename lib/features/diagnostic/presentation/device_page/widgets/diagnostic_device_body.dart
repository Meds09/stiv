import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/device_page/widgets/card_problem.dart';
import 'package:stiv/features/diagnostic/presentation/providers/problem_providers.dart';

class DiagnosticDeviceBody extends ConsumerWidget {
  const DiagnosticDeviceBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final problemsAsync = ref.watch(problemsBySelectedDeviceProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(

          color: AppColors.background,
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
              '¿Que está ocurriendo con el dispositivo? ',
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
                  itemBuilder: (context, index) {
                    final problem = problems[index];
                    return CardProblem(
                    problem: problem,
                    onTap: (){},
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
