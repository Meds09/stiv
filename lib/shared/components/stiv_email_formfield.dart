import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stiv/features/email_validator.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class StivEmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final IconButton? suffixIcon;
  final Color? borderColor;

  const StivEmailTextField({
    super.key,
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
        style: TextStyle(color: AppColors.textPrimary),
        controller: controller,
        obscureText: obscureText,
        textInputAction: textInputAction,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
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
          fillColor: AppColors.surface,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textSecondary),
          suffixIcon: suffixIcon,
        ),
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        validator: (v) => EmailValidatorX.validate(v, fieldName: label),
      ),
    );
  }
}
