import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class CustomBottomNavigationBar extends StatelessWidget {

  const CustomBottomNavigationBar({super.key});

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
       context.go('/home');
        break;
      case 1:
        // context.go('/diagnostic');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: AppColors.textSecondary,
      onTap: (index) => onItemTapped(context, index),
   
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Diagnóstico'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
