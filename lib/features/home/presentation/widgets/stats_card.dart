import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Modelo para una tarjeta de estadística individual
class StatCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const StatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });
}

/// Tarjeta de estadística con diseño moderno y animación
class StatsCard extends StatefulWidget {
  final StatCardData data;
  final int index;

  const StatsCard({
    super.key,
    required this.data,
    this.index = 0,
  });

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.index * 0.1,
          0.3 + (widget.index * 0.1),
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.index * 0.1,
          0.3 + (widget.index * 0.1),
          curve: Curves.easeOut,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.brMd,
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: widget.data.color.withOpacity(0.1),
                    borderRadius: AppRadii.brSm,
                  ),
                  child: Icon(
                    widget.data.icon,
                    color: widget.data.color,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.data.value,
              style: AppTextStyles.h1.copyWith(
                fontSize: 32,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.data.label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            if (widget.data.subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.data.subtitle!,
                style: AppTextStyles.caption,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

