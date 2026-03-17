import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/guides/providers/guides_providers.dart';

class GuidesCategoryFilter extends ConsumerWidget {
  const GuidesCategoryFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidesAsync = ref.watch(guidesStreamProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return guidesAsync.when(
      data: (guides) {
        // Extract unique categories
        final categories = guides.map((g) => g.category).toSet().toList();
        categories.sort();

        // Add 'Todas' option
        final allCategories = ['Todas', ...categories];

        return SizedBox(
          height: 50,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = allCategories[index];
              final isSelected = (selectedCategory == null && category == 'Todas') ||
                                 (selectedCategory == category);

              return FilterChip(
                color: WidgetStatePropertyAll(isSelected ? AppColors.info.withValues(alpha: 0.15): AppColors.surface),
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  // The original logic was: if 'Todas' is selected, set null. Otherwise, set the category.
                  // The provided edit's `if (isSelected)` condition would mean:
                  // if the *currently selected* chip is clicked again, set null.
                  // if a *non-selected* chip is clicked, set its category.
                  // This changes the behavior for 'Todas'.
                  // To maintain the original behavior while using setCategory:
                  if (category == 'Todas') {
                    ref.read(selectedCategoryProvider.notifier).setCategory(null);
                  } else {
                    // Assuming category is a String, not an object with a 'name' property.
                    ref.read(selectedCategoryProvider.notifier).setCategory(category);
                  }
                },
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.primary.withValues(alpha: 0.1),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontFamily: 'Inter',
                  fontSize: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 1,
                  ),
                ),
        
                elevation: 0,
                pressElevation: 0,
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
