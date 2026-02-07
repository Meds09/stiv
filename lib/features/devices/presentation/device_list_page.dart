import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/devices/domain/models/device.dart';
import 'package:stiv/features/devices/providers/devices_providers.dart';
import 'package:stiv/features/devices/widgets/status_indicator.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';
import 'package:stiv/core/utils/image_utils.dart';

class DeviceListPage extends ConsumerWidget {
  const DeviceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final expandedIds = ref.watch(isExpandedCategoryIdProviderFromDevicesPage);

    return categoriesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(child: Text('No hay categorías disponibles'));
        }

        final searchQuery = ref.watch(deviceSearchQueryProvider);
        final isSearching = searchQuery.trim().isNotEmpty;

        return ListView.builder(
          itemCount: categories.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isExpanded = expandedIds.contains(category.id);

            final devicesAsync = ref.watch(
              filteredDeviceByCategoryProvider(category.id),
            );

            final devices = devicesAsync.when(
              data: (d) => d,
              loading: () => const <Device>[],
              error: (_, _) => const <Device>[],
            );

            //ocultar categoría vacía SOLO si hay búsqueda
            if (isSearching && devices.isEmpty) {
              return const SizedBox.shrink();
            }

            return DeviceTypeList(
              category: category,
              isExpanded: isExpanded,
              devices: isExpanded ? devices : const <Device>[],
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: AppColors.card,
            elevation: 4,
            child: ListTile(
              title: Text(widget.category.name, style: AppTextStyles.h2),
              trailing: AnimatedRotation(
                turns: widget.isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.expand_more, color: AppColors.primary),
              ),
              onTap: () {
                final notifier = ref.read(
                  isExpandedCategoryIdProviderFromDevicesPage.notifier,
                );
                final next = {...notifier.state};

                if (next.contains(widget.category.id)) {
                  next.remove(widget.category.id);
                } else {
                  next.add(widget.category.id);
                }

                notifier.state = next;
              },
            ),
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
        const SizedBox(height: 10),
        ...devices.map(
          (device) => Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Card(
              elevation: 2,

              color: AppColors.card2,
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(10),

                //boton de accion
                trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  onPressed: () {
                     context.pushNamed('device-edit', pathParameters: {'deviceId': device.id});
                  },
                ),
                //icono del dispositivo
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: device.image != null
                      ? device.image!.toImageProvider
                      : null,
                  child: device.image == null
                      ? Icon(Icons.devices, size: 25, color: AppColors.primary)
                      : null,
                ),
                //texto del dispositivo
                title: Text(
                  device.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusIndicator(AppColors.primary, deviceId: device.id),
                    Text(
                      'IP: ${device.ip}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Ubicación: ${device.location ?? 'Sin ubicación'}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                  onTap: () {
                    // We need to update this provider or creating a selection provider in devices
                    // For now, let's assume we want to navigate.
                    // ref.read(selectedDeviceProvider.notifier).state = device;
                    
                    // Since diagnosticChat expects int ID maybe? Let's check router.
                    // For now passing String.
                    context.pushNamed(
                      'diagnosticChat',
                      pathParameters: {'deviceId': device.id},
                    );
                  },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
