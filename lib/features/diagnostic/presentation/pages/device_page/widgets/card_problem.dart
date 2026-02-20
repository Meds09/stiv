import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/problem.dart';

class CardProblem extends StatelessWidget {
  final Problem problem;
  final VoidCallback? onTap;

  const CardProblem({super.key, required this.problem, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: AppColors.card2,
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          borderOnForeground: true,
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
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
        
               
              ),
              child:
                  problem.icon ??
                  const Icon(
                    Icons.report_problem_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
