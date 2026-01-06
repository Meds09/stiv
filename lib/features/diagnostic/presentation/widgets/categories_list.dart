import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/diagnostic/models/device.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({super.key});

  @override
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
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isExpanded = expandedIds.contains(category.id);

            // Solo consulto dispositivos si está expandida
            final devicesAsyncValue = isExpanded
                ? ref.watch(deviceByCategoryProvider(category.id))
                : const AsyncValue.data(<Device>[]);

            return devicesAsyncValue.when(
              data: (devices) => DeviceTypeList(
                category: category,
                isExpanded: isExpanded,
                devices: devices,
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Text('Error: $e'),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class DeviceTypeList extends ConsumerStatefulWidget {
  const DeviceTypeList({
    super.key,
    required this.category,
    required this.isExpanded,
    required this.devices,
  });

  final Category category;
  final bool isExpanded;
  final List<Device> devices;

  @override
  ConsumerState<DeviceTypeList> createState() => _DeviceTypeListState();
}

class _DeviceTypeListState extends ConsumerState<DeviceTypeList>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          ListTile(
            title: Text(widget.category.name, style: AppTextStyles.h2),
            leading: Text(widget.category.emoji, style: AppTextStyles.h2),
            trailing: AnimatedRotation(
              turns: widget.isExpanded ? 0.5 : 0.0, // rota el icono
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.expand_more, color: AppColors.primary),
            ),
            onTap: () {
              final notifier = ref.read(isExpandedCategoryIdProvider.notifier);
              final next = {...notifier.state};

              if (next.contains(widget.category.id)) {
                next.remove(widget.category.id);
              } else {
                next.add(widget.category.id);
              }
              notifier.state = next;
            },
          ),

          // Animación de altura (expand/close)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: .topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: widget.isExpanded
                  ? _DevicesBlock(
                      key: ValueKey('expanded-${widget.category.id}'),
                      devices: widget.devices,
                    )
                  : const SizedBox(key: ValueKey('collapsed'), height: 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _DevicesBlock extends StatelessWidget {
  const _DevicesBlock({super.key, required this.devices});
  final List<Device> devices;

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(left: 16, bottom: 8),
        child: Text('No hay dispositivos en esta categoría'),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 6),
        ...devices.map(
          (device) => Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ListTile(
              dense: true,
              title: Text(
                device.name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
              leading: const Icon(Icons.memory, color: AppColors.primary),
              onTap: () {
                context.pushNamed(
                  'diagnosticChat',
                  pathParameters: {'deviceId': device.id.toString()},
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
