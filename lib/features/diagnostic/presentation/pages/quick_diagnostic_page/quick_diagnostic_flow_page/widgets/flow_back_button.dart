import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class FlowBackButton extends StatefulWidget {
  const FlowBackButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<FlowBackButton> createState() => _FlowBackButtonState();
}

class _FlowBackButtonState extends State<FlowBackButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) => setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }
  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _isPressed 
                ? AppColors.primary.withValues(alpha: 0.12)
                :AppColors.primary.withValues(alpha: 0.09),
            borderRadius: AppRadii.brMd,
            border: Border.all(
              color: _isPressed ? AppColors.primary : AppColors.border, 
              width: _isPressed ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isPressed 
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: _isPressed ? 10 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                size: 16,
                color: _isPressed ? AppColors.primary : AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Pregunta anterior',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600, 
                  fontSize: 18, 
                  color: _isPressed ? AppColors.primary : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
