import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/router/router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/auth/providers/bottom_nav_bar_provider.dart';
import 'package:stiv/features/auth/widgets/card_menu.dart';

/// Modelo para las opciones del menú
class MenuOption {
  final String title;
  final IconData icon;
  final int? menuIndex;
  final String route;

  const MenuOption({
    required this.title,
    required this.icon,
    required this.route,
    this.menuIndex,
  });
}

/// Sección de grid de menú con animación escalonada
class MenuGridSection extends ConsumerStatefulWidget {
  final List<MenuOption> options;

  const MenuGridSection({super.key, required this.options});

  @override
  ConsumerState<MenuGridSection> createState() => _MenuGridSectionState();
}

class _MenuGridSectionState extends ConsumerState<MenuGridSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: _buildMenuGrid(),
    );
  }

  Widget _buildMenuGrid() {
    return Column(
      children: [
        _buildMenuRow(startIndex: 0, items: widget.options.take(2).toList()),
        const SizedBox(height: AppSpacing.sm),
        _buildMenuRow(
          startIndex: 2,
          items: widget.options.skip(2).take(2).toList(),
        ),
      ],
    );
  }

  Widget _buildMenuRow({
    required int startIndex,
    required List<MenuOption> items,
  }) {
    return Row(
      children: items.asMap().entries.map((entry) {
        final index = startIndex + entry.key;
        return Expanded(
          child: _AnimatedMenuCard(
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  index * 0.2,
                  0.4 + (index * 0.2),
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: CardMenu(
              title: entry.value.title,
              icon: Icon(entry.value.icon),
              onTap:  () {
                router.goNamed(entry.value.route);
                ref.read(menuIndexProvider.notifier).setIndex(entry.value.menuIndex ?? 0);
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Widget que anima la entrada de las tarjetas del menú
class _AnimatedMenuCard extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _AnimatedMenuCard({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: 0.8 + (animation.value * 0.2),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
