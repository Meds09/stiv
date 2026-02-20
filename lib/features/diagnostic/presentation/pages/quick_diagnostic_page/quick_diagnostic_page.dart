import 'package:flutter/material.dart';
import 'package:stiv/core/router/router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic.dart';

class QuickDiagnosticPage extends StatelessWidget {
  const QuickDiagnosticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),

              const HeroBanner(),

              const SizedBox(height: AppSpacing.xl),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Síntomas comunes', style: AppTextStyles.h3),
                  TextButton(
                    onPressed: () {
                      // TODO: navegar a lista completa
                    },
                    child: Text(
                      'Ver todos',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              const SymptomsGrid(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          router.go('/home');
        },
      ),
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
      ),
    );
  }
}
