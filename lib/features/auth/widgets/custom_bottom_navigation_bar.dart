import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/features/auth/providers/auth_provider.dart';
import 'package:stiv/features/auth/providers/bottom_nav_bar_provider.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Bottom Navigation Bar con diseño liquid glass moderno
class CustomBottomNavigationBar extends ConsumerStatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  ConsumerState<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends ConsumerState<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onItemTapped(BuildContext context, WidgetRef ref, int index) {
    final router = GoRouter.of(context);
    ref.read(menuIndexProvider.notifier).setIndex(index);

    _animationController.forward(from: 0.0).then((_) {
      _animationController.reverse();
    });

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
    final currentIndex = ref.watch(menuIndexProvider);
    final user = ref.watch(currentUserProvider);

    return Container(
      margin: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadii.brLg,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface.withValues(alpha: 0.85),
                  AppColors.surface.withValues(alpha: 0.75),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              borderRadius: AppRadii.brLg,
            ),
            child: SafeArea(
              top: false,
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Inicio',
                      isSelected: currentIndex == 0,
                      onTap: () => onItemTapped(context, ref, 0),
                    ),
                    _NavItem(
                      icon: Icons.search_rounded,
                      label: 'Diagnóstico',
                      isSelected: currentIndex == 1,
                      onTap: () => onItemTapped(context, ref, 1),
                    ),
                    _NavItem(
                      icon: Icons.person_rounded,
                      label: 'Perfil',
                      isSelected: currentIndex == 2,
                      onTap: () => onItemTapped(context, ref, 2),
                      user: user,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Item individual del navigation bar con animaciones
class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final User? user;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.user,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: AppRadii.brMd,
                border: widget.isSelected
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.user != null && widget.label == 'Perfil'
                      ? _buildAvatar()
                      : Icon(
                          widget.icon,
                          color: widget.isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary.withValues(alpha: 0.6),
                          size: 24,
                        ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: widget.isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.isSelected
              ? AppColors.primary
              : AppColors.textSecondary.withValues(alpha: 0.3),
          width: widget.isSelected ? 2 : 1.5,
        ),
      ),
      child: ClipOval(
        child: widget.user?.photoURL != null
            ? Image.network(
                widget.user!.photoURL!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: widget.isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary.withValues(alpha: 0.6),
                  );
                },
              )
            : Icon(
                Icons.person_rounded,
                size: 16,
                color: widget.isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary.withValues(alpha: 0.6),
              ),
      ),
    );
  }
}
