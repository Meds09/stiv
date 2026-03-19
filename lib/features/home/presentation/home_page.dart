import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/home/presentation/providers/home_stats_provider.dart';
import 'package:stiv/features/home/presentation/providers/menu_options_provider.dart';
import 'package:stiv/features/home/presentation/widgets/widgets.dart';
import 'package:stiv/features/auth/providers/auth_provider.dart';


/// Página principal del home con diseño moderno y estadísticas
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(userFirstNameProvider);
    final authController = ref.read(authControllerProvider);
    final isSigningOut = ref.watch(isSigningOutProvider);
    final menuOptions = ref.watch(menuOptionsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,  
            child: RefreshIndicator(
              onRefresh: () async {
                // Refrescar datos al hacer pull to refresh
                ref.invalidate(homeStatsProvider);
                await Future.delayed(const Duration(milliseconds: 500));
              },
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      onLogoutTap: () {
                        authController.signOut();
                        
                      }
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    WelcomeSection(firstName: firstName),
                    const SizedBox(height: AppSpacing.sm),
                    const DiagnosticStatsSection(),
                    const SizedBox(height: AppSpacing.xl),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Acciones rápidas',
                            style: AppTextStyles.h2,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ),
                    ),
                   const SizedBox(height: AppSpacing.sm),
                    MenuGridSection(options: menuOptions),
                    const SizedBox(height: AppSpacing.xl),
                    const SizedBox(height: AppSpacing.xl),
                    const SizedBox(height: 100), // Padding para que el contenido se vea detrás del nav bar
                  ],
                ),
              ),
            ),
            
          ),
          SignOutOverlay(isVisible: isSigningOut),
        ],
      ),
    );
  }
}
