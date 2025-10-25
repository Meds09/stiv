import 'package:flutter/material.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class StivTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconButton? suffixIcon;
  final Color? borderColor;

  const StivTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.borderColor,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: TextStyle(color: AppColors.textPrimary),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? Colors.grey),
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
