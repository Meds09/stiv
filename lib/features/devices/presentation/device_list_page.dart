import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/devices/widgets/status_indicator.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/diagnostic/models/device.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

class DeviceListPage extends ConsumerWidget {
  const DeviceListPage({super.key});

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
          physics: const BouncingScrollPhysics(),
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
                  isExpandedCategoryIdProvider.notifier,
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
    
              color:AppColors.card2,
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(10),

                //boton de accion
                trailing: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  onPressed: () {
                   
                  },
                ),
                //icono del dispositivo
                leading: CircleAvatar(

                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: device.image != null
                      ? AssetImage(device.image!)
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
                  ref.read(selectedDeviceProvider.notifier).state = device;
    
                  context.pushNamed(
                    'diagnosticChat',
                    pathParameters: {'deviceId': device.id.toString()},
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
