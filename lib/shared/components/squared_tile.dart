import 'package:flutter/material.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class SquareTile extends StatelessWidget {
  final Function()? onTap;
  final String imagePath;
  const SquareTile({super.key, required this.imagePath,required this.onTap});

  @override

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textSecondary),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surface.withValues(alpha: 0.6),
        ),
        child: Image.asset(
          imagePath,
          height: 30,
          width: 30,
          )
        
        ,
      ),
    );
  }
}