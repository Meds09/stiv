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
    return BottomNavigationBar(
      currentIndex: getCurrentIndex(context),
      elevation: 8,
      backgroundColor: AppColors.textSecondary,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textPrimary.withOpacity(0.6),
      onTap: (index) => onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Diagnóstico'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
