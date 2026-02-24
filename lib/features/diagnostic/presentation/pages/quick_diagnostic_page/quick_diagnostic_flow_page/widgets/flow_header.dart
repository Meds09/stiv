import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class FlowHeader extends StatelessWidget {
  const FlowHeader({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.onClose,
    this.gradient,
    this.highlightColor = AppColors.primary,
  });

  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onClose;
  final Gradient? gradient;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.xl + 10, AppSpacing.md, 0), // Bajado un poco más
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Large icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: gradient != null
                ? ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => gradient!.createShader(bounds),
                    child: Icon(icon, color: Colors.white, size: 26),
                  )
                : Icon(icon, color: highlightColor, size: 26),
          ),

          const SizedBox(width: 14),

          // Title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gradient != null
                    ? ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => gradient!.createShader(bounds),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      )
                    : Text(
                        label,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Close
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
