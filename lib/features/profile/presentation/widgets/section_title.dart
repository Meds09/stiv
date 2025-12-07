import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Widget reutilizable para títulos de sección
class SectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsets? padding;

  const SectionTitle({
    super.key,
    required this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.h2,
      ),
    );
  }
}

