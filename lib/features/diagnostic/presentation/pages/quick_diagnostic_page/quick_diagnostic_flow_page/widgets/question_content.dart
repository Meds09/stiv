import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/quick_diagnostic_flow_page/widgets/question_option_card.dart';

class QuestionContent extends StatelessWidget {
  const QuestionContent({
    super.key,
    required this.question,
    required this.selectedOptionId,
    required this.onOptionSelected,
  });

  final DiagnosticQuestion question;
  final String? selectedOptionId;
  final void Function(String) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Selecciona la opción que corresponda',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: AppColors.primary,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Question text
          Text(
            question.text,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),

          if (question.subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              question.subtitle!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          // Options list
          ...List.generate(question.options.length, (i) {
            final option = question.options[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: QuestionOptionCard(
                option: option,
                isSelected: option.id == selectedOptionId,
                index: i,
                onTap: () => onOptionSelected(option.id),
              ),
            );
          }),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
