import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/widgets/symptom.dart';

/// Tarjeta individual de un síntoma con animaciones suaves y mejor jerarquía visual.
class SymptomCard extends StatefulWidget {
  const SymptomCard({
    super.key,
    required this.symptom,
    required this.onTap,
    this.color = AppColors.primary,
    this.gradient,
  });

  final Symptom symptom;
  final VoidCallback onTap;
  final Color color;
  final Gradient? gradient;

  @override
  State<SymptomCard> createState() => _SymptomCardState();
}

class _SymptomCardState extends State<SymptomCard> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadii.brMd,
            border: Border.all(
              color: _isPressed ? widget.color : AppColors.border,
              width: _isPressed ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isPressed
                    ? widget.color.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: _isPressed ? 10 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _isPressed 
                      ? widget.color.withValues(alpha: 0.15)
                      : widget.color.withValues(alpha: 0.08),
                  borderRadius: AppRadii.brMd,
                ),
                child: Center(
                  child: AnimatedScale(
                    scale: _isPressed ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: widget.gradient != null
                        ? ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) =>
                                widget.gradient!.createShader(bounds),
                            child: Icon(
                              widget.symptom.icon,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        : Icon(
                            widget.symptom.icon,
                            color: widget.color,
                            size: 30,
                          ),
                  ),
                ),
              ),
              const Spacer(),
              widget.gradient != null
                  ? ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) =>
                          widget.gradient!.createShader(bounds),
                      child: Text(
                        widget.symptom.label,
                        style: AppTextStyles.subtitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Text(
                      widget.symptom.label,
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              const SizedBox(height: 2),
              Text(
                widget.symptom.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
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
