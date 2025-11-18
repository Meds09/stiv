import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/shared/providers/auth_provider.dart';
import 'package:stiv/core/theme/theme_data.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // desenfoque suave
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background.withValues(alpha: 0.4),
                AppColors.background.withValues(alpha: 0.6),
              ],
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor:
                Colors.transparent, 
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
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Diagnóstico',
              ),
              BottomNavigationBarItem(
                icon: user?.photoURL != null
                    ? CircleAvatar(
                        radius: 13,
                        backgroundImage: NetworkImage(user!.photoURL!),
                      )
                    : Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
