import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';


class DiagnosticPage extends ConsumerWidget {
  const DiagnosticPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Selecciona un dispositivo para iniciar el diagnóstico',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        height: 1.2,
                        letterSpacing: -0.2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                categoriesAsyncValue.when(
                  data: (categories){
                    return Column(
                      children: categories.map((category) => Text(category.name, style: AppTextStyles.h1,)).toList(),
                    );
                  }, 
                  error: (e, _) => Center(child: Text('Error: $e')), 
                  loading: () => const Center(child: CircularProgressIndicator()),
                  )

                // Aquí puedes agregar más widgets relacionados con el diagnóstico
              ],
            ),
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget _buildAppBar() {
  return AppBar(
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.primary),
    backgroundColor: AppColors.background,
    titleTextStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    title: const Text('Stiv'),
    
  );
}
