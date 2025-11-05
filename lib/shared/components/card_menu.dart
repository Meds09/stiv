import 'package:flutter/material.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class CardMenu extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback? onTap;

  const CardMenu({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color:AppColors.danger
      ),
    );
  }
}
