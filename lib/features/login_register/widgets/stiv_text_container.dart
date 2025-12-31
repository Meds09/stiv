import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class StivTextContainer extends StatelessWidget {
  final Widget? suffixIcon;
  final String? text;
  final String? title;
  const StivTextContainer({
    super.key,
    this.suffixIcon = const Icon(Icons.person, color: AppColors.primary),
    this.text = 'Informacion',
    this.title = 'Titulo'
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          suffixIcon ??
              Icon(Icons.card_travel_outlined, color: AppColors.primary),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? 'Titulo',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  text ?? 'Sin datos registrados',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
