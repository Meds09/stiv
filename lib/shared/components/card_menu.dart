import 'package:flutter/material.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class CardMenu extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback? onTap;

  const CardMenu({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: AppColors.info,
        child: InkWell(
          splashColor: Colors.white.withAlpha(30),
          onTap: onTap,
          child: SizedBox(
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white12,
                  ),
                  child: icon,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                     fontFamily: 'Inter'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
