import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

/// Tarjeta de opción premium con animaciones e indicador visual moderno.
class QuestionOptionCard extends StatefulWidget {
  const QuestionOptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
    this.index = 0,
  });

  final QuestionOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  @override
  State<QuestionOptionCard> createState() => _QuestionOptionCardState();
}

class _QuestionOptionCardState extends State<QuestionOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isAiOption =>
      widget.option.label.toLowerCase().contains('ia') ||
      widget.option.label.toLowerCase().contains('otro');

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isSelected
        ? AppColors.primary
        : _isAiOption
            ? AppColors.warning.withValues(alpha: 0.3)
            : AppColors.border;

    final bgColor = widget.isSelected
        ? AppColors.primary.withValues(alpha: 0.05)
        : _isAiOption
            ? AppColors.warning.withValues(alpha: 0.03)
            : Colors.white;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadii.brMd,
          border: Border.all(
            color: borderColor,
            width: widget.isSelected ? 2.0 : 1.0,
          ),
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) {
              _controller.reverse();
              widget.onTap();
            },
            onTapCancel: () => _controller.reverse(),
            borderRadius: AppRadii.brMd,
            splashColor: AppColors.primary.withValues(alpha: 0.06),
            highlightColor: AppColors.primary.withValues(alpha: 0.03),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 14,
              ),
              child: Row(
                children: [
                  // Icono con fondo gradiente
                  _buildIcon(),
                  const SizedBox(width: 14),

                  // Textos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.option.label,
                          style: AppTextStyles.subtitle.copyWith(
                            fontSize: 14,
                            fontWeight: widget.isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: widget.isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (widget.option.description != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            widget.option.description!,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              color: _isAiOption
                                  ? AppColors.warning
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Chevron / selección
                  const SizedBox(width: AppSpacing.sm),
                  _buildTrailing(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.option.icon == null) {
      return const SizedBox.shrink();
    }

    final Color iconBg;
    final Color iconColor;

    if (_isAiOption) {
      iconBg = AppColors.warning.withValues(alpha: 0.12);
      iconColor = AppColors.warning;
    } else if (widget.isSelected) {
      iconBg = AppColors.primary.withValues(alpha: 0.12);
      iconColor = AppColors.primary;
    } else {
      iconBg = AppColors.primary.withValues(alpha: 0.06);
      iconColor = AppColors.primary.withValues(alpha: 0.7);
    }

    return AnimatedContainer(
      duration: AppDurations.fast,
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: iconBg,
        borderRadius: BorderRadius.circular(12),
        border: widget.isSelected
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              )
            : null,
      ),
      child: Icon(
        widget.option.icon,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildTrailing() {
    if (_isAiOption) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.warning.withValues(alpha: 0.15),
              AppColors.warning.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 12,
              color: AppColors.warning.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 3),
            Text(
              'IA',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: AppColors.warning.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedContainer(
      duration: AppDurations.fast,
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.isSelected
            ? AppColors.primary
            : Colors.transparent,
        border: Border.all(
          color: widget.isSelected
              ? AppColors.primary
              : AppColors.outline,
          width: widget.isSelected ? 0 : 1.5,
        ),
      ),
      child: widget.isSelected
          ? const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }
}

