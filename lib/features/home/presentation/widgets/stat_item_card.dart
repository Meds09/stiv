import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

class StatItemCard extends StatefulWidget {
  final IconData icon;
  final num value;
  final String label;
  final Color color;
  final bool isPrimary;
  final VoidCallback? onTap;

  const StatItemCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  State<StatItemCard> createState() => _StatItemCardState();
}

class _StatItemCardState extends State<StatItemCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Escala del tap effect
    final scale = _isPressed ? 0.95 : 1.0;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onTap != null) setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (widget.onTap != null) {
          setState(() => _isPressed = false);
          widget.onTap!();
        }
      },
      onTapCancel: () {
        if (widget.onTap != null) setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, 
            vertical: widget.isPrimary ? AppSpacing.md : AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.brMd,
            boxShadow: widget.isPrimary 
                ? [BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )] 
                : [],
            border: Border.all(
              color: AppColors.border.withValues(alpha: widget.isPrimary ? 0.2 : 0.5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(widget.isPrimary ? AppSpacing.md : AppSpacing.xs),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: widget.isPrimary ? 32 : 24,
                ),
              ),
              SizedBox(height: widget.isPrimary ? AppSpacing.md : AppSpacing.sm),
              AnimatedFlipCounter(
                value: widget.value,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                textStyle: AppTextStyles.h1.copyWith(
                  fontSize: widget.isPrimary ? 28 : 20,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: widget.isPrimary ? 13 : 11,
                  fontWeight: widget.isPrimary ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


