import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/shared/providers/auth_provider.dart';
import 'package:stiv/shared/widgets/card_menu.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(userFirstNameProvider);
    final authController = ref.read(authControllerProvider);
    final isSigningOut = ref.watch(isSigningOutProvider); // ✅ Observa el estado

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ✅ El contenido normal del HomePage
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/stiv-logo-blue.png',
                              height: 50,
                            ),
                            const Text('Stiv', style: AppTextStyles.h2),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // TODO: Ir a settings
                              },
                              child: const Icon(
                                Icons.settings,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () => authController.signOut(), // ✅ Simple
                              child: const Icon(
                                Icons.logout,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              '¡Bienvenido de nuevo, ',
                              style: TextStyle(
                                color: AppColors.textPrimary.withOpacity(0.8),
                                fontSize: 16,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '$firstName! 👋',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          'Analicemos tus equipos en segundos',
                          style: AppTextStyles.h2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Divider(color: Colors.grey[350], thickness: 3),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CardMenu(
                          title: "Diagnóstico Rápido",
                          icon: const Icon(Icons.import_contacts_rounded),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: CardMenu(
                          title: "Dispositivos",
                          icon: const Icon(Icons.devices),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CardMenu(
                          title: "Historial de reportes",
                          icon: const Icon(Icons.history),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: CardMenu(
                          title: "Manuales",
                          icon: const Icon(Icons.menu_book_rounded),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ✅ Overlay que cubre todo cuando está cerrando sesión
          if (isSigningOut)
            Container(
              color:
                  AppColors.background, // Fondo opaco (mismo color que tu app)
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo (opcional)
                    Image.asset('assets/images/stiv-logo-blue.png', height: 80),
                    const SizedBox(height: 32),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Cerrando sesión...',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hasta pronto 👋',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
