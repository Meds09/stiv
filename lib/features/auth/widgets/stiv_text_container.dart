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
      padding: const EdgeInsets.all(16),
      // Removed margin to respect parent padding
      decoration: BoxDecoration(
        color: AppColors.card2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
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
                    fontSize: 14,
                    color: AppColors.primary,
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
