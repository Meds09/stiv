import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class LoginButton extends StatelessWidget {
 final String buttonText;
 final Function()? onTap;
 final bool disabled;

   const LoginButton({
    super.key,
    required this.onTap, 
    required this.buttonText,
    this.disabled = false
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
               color: disabled ? Colors.grey[400] : AppColors.primary,
              borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
               color: disabled ? Colors.grey[200] : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Rubik'
              ),
            ),
          ),
        ),
      ),
    );
  }
}