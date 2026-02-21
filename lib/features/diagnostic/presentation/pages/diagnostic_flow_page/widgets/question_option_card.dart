import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

/// Tarjeta de opción premium — Material 3, dashboard técnico.
///
/// Animación de escala al presionar + HapticFeedback.
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
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _elevationAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeIn));

    _elevationAnim = Tween<double>(
      begin: 0,
      end: 6,
    ).animate(
        CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  bool get _isAiOption {
    final label = widget.option.label.toLowerCase();
    return label.contains('ia') ||
        label.contains('asistencia') ||
        label.contains('otro');
  }

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color selectedBg = AppColors.primary.withValues(alpha: 0.06);
    final Color defaultBg = Colors.white;
    final Color aiBg = const Color(0xFFFFF7ED);

    final Color bg = widget.isSelected
        ? selectedBg
        : _isAiOption
            ? aiBg
            : defaultBg;

    final Color borderColor = widget.isSelected
        ? AppColors.primary
        : _isAiOption
            ? const Color(0xFFF59E0B).withValues(alpha: 0.4)
            : AppColors.border;

    final double borderWidth = widget.isSelected ? 2.0 : 1.0;

    return AnimatedBuilder(
      animation: _pressController,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTapDown: (_) => _pressController.forward(),
            onTapUp: (_) {
              _pressController.reverse();
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            onTapCancel: () => _pressController.reverse(),
            borderRadius: BorderRadius.circular(16),
            splashColor: AppColors.primary.withValues(alpha: 0.05),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // ── Icon container ───────────────────
                  _OptionIcon(
                    icon: widget.option.icon,
                    isSelected: widget.isSelected,
                    isAi: _isAiOption,
                  ),

                  const SizedBox(width: 14),

                  // ── Labels ──────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.option.label,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: widget.isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        if (widget.option.description != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            widget.option.description!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: _isAiOption
                                  ? const Color(0xFFB45309)
                                  : AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ── Trailing ────────────────────────
                  _isAiOption
                      ? _AiBadge(elevation: _elevationAnim.value)
                      : _SelectionIndicator(isSelected: widget.isSelected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Icon widget ───────────────────────────────────────────────────────────────

class _OptionIcon extends StatelessWidget {
  const _OptionIcon({
    required this.icon,
    required this.isSelected,
    required this.isAi,
  });

  final IconData? icon;
  final bool isSelected;
  final bool isAi;

  @override
  Widget build(BuildContext context) {
    if (icon == null) return const SizedBox(width: 48, height: 48);

    final Color bg = isSelected
        ? AppColors.primary.withValues(alpha: 0.12)
        : isAi
            ? const Color(0xFFF59E0B).withValues(alpha: 0.10)
            : AppColors.primary.withValues(alpha: 0.06);

    final Color iconColor = isSelected
        ? AppColors.primary
        : isAi
            ? const Color(0xFFD97706)
            : AppColors.primary.withValues(alpha: 0.65);

    return AnimatedContainer(
      duration: AppDurations.fast,
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: isSelected
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
                width: 1.0,
              )
            : null,
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}

// ── Selection circle ──────────────────────────────────────────────────────────

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.outline,
          width: isSelected ? 0 : 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
          : null,
    );
  }
}

// ── AI sparkle badge ──────────────────────────────────────────────────────────

class _AiBadge extends StatelessWidget {
  const _AiBadge({required this.elevation});
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 12,
            color: Color(0xFFB45309),
          ),
          SizedBox(width: 4),
          Text(
            'IA',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w800,
              fontSize: 11,
              color: Color(0xFFB45309),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
