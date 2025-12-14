import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({super.key});

  @override
/// Construye una lista de categorías, con cada categoría
/// representada por un `ListTile` que muestra el nombre, el emoji
/// y un icono de flecha para expandir o contraer la lista de dispositivos
/// de esa categoría. Al hacer tap en una categoría, se expande o se
/// contrae su lista de dispositivos, según sea el caso. La lista
/// de dispositivos se carga en tiempo real según se expanda o se
/// contraiga cada categoría. Si no hay categorías disponibles, se muestra
/// un mensaje indicando que no hay categorías disponibles.
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final expandedIds = ref.watch(isExpandedCategoryIdProvider);
    return categoriesAsyncValue.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(child: Text('No hay categorías disponibles'));
        }
        return ListView.builder(
          itemCount: categories.length,

          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final category = categories[index];
            final isExpanded = expandedIds.contains(category.id);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(category.name, style: AppTextStyles.h2),
                leading: Text(category.emoji, style: AppTextStyles.h2),
                trailing: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.primary,
                ),
                onTap: () {
                  final notifier = ref.read(
                    isExpandedCategoryIdProvider.notifier,
                  );

                  final next = {...notifier.state};
                  if (next.contains(category.id)) {
                    next.remove(category.id);
                  } else {
                    next.add(category.id);
                  }
                  notifier.state = next;

                  //TODO: LISTAR LOS DISPOSITIVOS DE LA CATEGORÍA
                },
                
              ),
            );
            
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
