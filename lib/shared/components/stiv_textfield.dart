import 'package:flutter/material.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class StivTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final IconButton? suffixIcon;
  final Color? borderColor;

  const StivTextField({
    super.key,
    required this.keyboardType,
    required this.hintText,
    required this.label,
    this.textInputAction,
    required this.obscureText,
    required this.controller,
    this.borderColor,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(3.0);
    const primaryColor = Color(0xFF055EF4);
    const errorColor = Colors.redAccent;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),

      child: TextFormField(
        style: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'Inter'
      
        ),
        controller: controller,
        obscureText: obscureText,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: primaryColor, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: errorColor, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: errorColor, width: 1.0),
          ),
          fillColor: AppColors.surface.withValues(alpha: 0.8),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textSecondary),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
