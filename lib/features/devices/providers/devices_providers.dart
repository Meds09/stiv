import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/diagnostic/models/device.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

final isExpandedCategoryIdProviderFromDevicesPage = StateProvider<Set<int>>(
  (ref) => <int>{},
);
final deviceSearchQueryProvider = StateProvider<String>((ref) => '');
final deviceProvider = Provider<List<Device>>((ref) => []);


// Proveedor para filtrar la lista de dispositivos
final filteredDeviceByCategoryProvider =
    Provider.family<AsyncValue<List<Device>>, int>((ref, categoryId) {
  final query = ref.watch(deviceSearchQueryProvider).toLowerCase();
  final devicesAsync = ref.watch(deviceByCategoryProvider(categoryId));

  return devicesAsync.when(
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
    data: (devices) {
      if (query.isEmpty) return AsyncData(devices);

      final filtered = devices.where((device) {
        return device.name.toLowerCase().contains(query) ||
               device.ip.toLowerCase().contains(query) ||
               (device.location ?? '').toLowerCase().contains(query);
      }).toList();

      return AsyncData(filtered);
    },
  );
});