import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/providers/problem_providers.dart';

class DiagnosticDeviceBody extends ConsumerWidget {
  const DiagnosticDeviceBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final problemsAsync = ref.watch(problemsBySelectedDeviceProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const Text(
            '¿Que problema presenta el dispositivo?',
            style: AppTextStyles.t1,
          ),
          const SizedBox(height: 20),
          
          problemsAsync.when(
            error: (e, _) => const Text('Error al cargar los problemas'),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (problems) {
              if (problems.isEmpty) {
                return const Text(
                  'No hay problemas disponibles para este dispositivo.',
                  style: AppTextStyles.h1,
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: problems.length,
                itemBuilder: (context, index) {
                  final problem = problems[index];
                  return ListTile(
                    title: Text(
                      problem.title,
                      style: AppTextStyles.h1,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Acción al seleccionar un problema
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
