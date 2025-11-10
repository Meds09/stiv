import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    switch (location) {
      case '/home':
        return 0;
      case '/diag':
        return 1;
      case '/profile':
        return 2;
      default:
        return 0;
    }
  }

  void onItemTapped(BuildContext context, int index) {
    final router = GoRouter.of(context);

    switch (index) {
      case 0:
        router.go('/home');
        break;
      case 1:
        router.go('/diag');
        break;
      case 2:
        router.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // desenfoque suave
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xCCF5F7FA), // fondo claro semi-transparente
                Color(0xE6FFFFFF),
              ],
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor:
                Colors.transparent, // 👈 dejamos el fondo transparente
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: getCurrentIndex(context),
            onTap: (index) => onItemTapped(context, index),
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textPrimary.withValues(alpha: 0.8),
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Diagnóstico',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
