import 'package:flutter/material.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class StivTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconButton? suffixIcon;
  final Color? borderColor;
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;

  const StivTextField({
    super.key,
    required this.hintText,
    required this.labelStyle,
    required this.floatingLabelStyle,
    required this.obscureText,
    required this.label,
    required this.controller,
    this.borderColor,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: TextStyle(color: AppColors.textSecondary),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          floatingLabelStyle: floatingLabelStyle ?? labelStyle,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? AppColors.primaryDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? AppColors.primary),
          ),
          fillColor: AppColors.surface,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textSecondary),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
