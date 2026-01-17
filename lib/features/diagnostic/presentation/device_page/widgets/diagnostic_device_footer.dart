import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/data/mock_problem.dart';

class DiagnosticDeviceFooter extends StatelessWidget {
  final int problemId;
  final VoidCallback? onTapped;

  const DiagnosticDeviceFooter({
    super.key,
    required this.problemId,
    this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    final problem = mockProblems.firstWhere((p) => p.id == problemId);

    return Card(
      color: AppColors.background,
      elevation: 4,

      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      borderOnForeground: true,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: AppColors.primary,
          strokeWidth: 2,
          dashPattern: [10, ],
          radius: const Radius.circular(12),
        ),
        child: ListTile(
          title: Text(problem.title, style: AppTextStyles.h3),
          subtitle: Text(problem.description, style: AppTextStyles.h4),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.primary,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                problem.icon ??
                const Icon(
                  Icons.question_mark_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
          ),
          onTap: onTapped,
        ),
      ),
    );
  }
}
