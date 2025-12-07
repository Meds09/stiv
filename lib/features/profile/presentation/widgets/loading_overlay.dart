import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Overlay de carga para mostrar durante operaciones asíncronas
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }
}

