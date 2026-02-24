import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class StyledDialog extends StatelessWidget {
  const StyledDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.actions,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 40,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          actions,
        ],
      ),
    );
  }
}
