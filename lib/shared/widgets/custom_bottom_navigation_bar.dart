import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/shared/providers/auth_provider.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/shared/providers/bottom_nav_bar_provider.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({super.key});

  void onItemTapped(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final indexProvider = ref.read(menuIndexProvider);

    switch (indexProvider) {
      case 0:
        router.go('/home');
        break;
      case 1:
        router.go('/diag');
        break;
      case 2:
        router.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexProvider = ref.read(menuIndexProvider.notifier);
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: indexProvider.state,
            onTap: (value) {
              indexProvider.state = value;
              onItemTapped(context, ref);
            },
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
