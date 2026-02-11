import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/devices/domain/models/device.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final expandedIds = ref.watch(isExpandedCategoryIdProvider);

    return categoriesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
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
            final AsyncValue<List<Device>> devicesAsync = ref.watch(
              deviceByCategoryProvider(category.id),
            );

            final devices = isExpanded
                ? devicesAsync.when(
                    data: (d) => d,
                    loading: () => const <Device>[],
                    error: (_, _) => const <Device>[],
                  )
                : const <Device>[];

            return DeviceTypeList(
              category: category,
              isExpanded: isExpanded,
              devices: devices,
            );
          },
        );
      },
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

  IconData _getCategoryIcon(int categoryId) {
    switch (categoryId) {
      case 1: // CCTV
        return Icons.videocam_outlined;
      case 2: // Red
        return Icons.lan_outlined;
      case 3: // Energía
        return Icons.bolt_outlined;
      case 4: // Control de Acceso
        return Icons.lock_outlined;
      default:
        return Icons.grid_view_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        color: AppColors.card2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                widget.category.name, 
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
              ),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(widget.category.id),
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              trailing: AnimatedRotation(
                turns: widget.isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.expand_more, color: AppColors.textSecondary),
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

            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: widget.isExpanded
                  ? _DevicesBlock(devices: widget.devices)
                  : const SizedBox(height: 0),
            ),
          ],
        ),
      ),
    );
  }
}

class _DevicesBlock extends ConsumerWidget {
  const _DevicesBlock({required this.devices});

  final List<Device> devices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (devices.isEmpty) {
      // No loader, no texto, no parpadeo
      return const SizedBox(height: 8);
    }

    return Column(
      children: [
        const SizedBox(height: 6),
        ...devices.map(
          (device) => Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.memory, color: AppColors.primary),
              title: Text(
                device.name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () {
                ref.read(selectedDeviceProvider.notifier).state = device;

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
