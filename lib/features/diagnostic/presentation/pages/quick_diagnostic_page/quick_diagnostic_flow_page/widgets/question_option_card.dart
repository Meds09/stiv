import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/option_icon.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/selection_indicator.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/ai_badge.dart';

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
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  bool get _isAiOption {
    final label = widget.option.label.toLowerCase();
    return label.contains('asistencia') || label.contains('otro');
  }

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color selectedBg = AppColors.primary.withValues(alpha: 0.06);
    final Color defaultBg = Colors.white;
    final Color aiBg = const Color(0xFFF8F4FF); // Light purple background

    final Color bg = widget.isSelected
        ? selectedBg
        : _isAiOption
            ? aiBg
            : defaultBg;

    final Color borderColor = widget.isSelected
        ? AppColors.primary
        : _isAiOption
            ? const Color(0xFF9B72CB).withValues(alpha: 0.3)
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
                  OptionIcon(
                    icon: widget.option.icon,
                    isSelected: widget.isSelected,
                    isAi: _isAiOption,
                    index: widget.index,
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
                                  ? const Color(0xFF9B72CB)
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
                      ? const AiBadge()
                      : SelectionIndicator(isSelected: widget.isSelected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


