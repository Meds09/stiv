import 'package:flutter/material.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class LoginButton extends StatelessWidget {
 final Function()? onTap;

   const LoginButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Iniciar Sesión',
            style: TextStyle(
              color: AppColors.background,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}