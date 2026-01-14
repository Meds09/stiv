import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.primary),
    backgroundColor: AppColors.background,
    titleTextStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('assets/images/stiv-logo-blue.png', height: 50),
        const SizedBox(width: AppSpacing.sm),
        const Text('Stiv', style: AppTextStyles.h2),
      ],
      )),
      body: const Center(
        child: Text('Página de Dispositivos'),
      ),
    );
  }
}