import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/auth/providers/auth_provider.dart';
import 'package:stiv/features/devices/data/repositories/device_repository_impl.dart';
import 'package:stiv/features/devices/domain/models/device.dart';
import 'package:stiv/features/devices/domain/repositories/device_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Firestore Instance Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Repository Provider
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepositoryImpl(ref.watch(firestoreProvider));
});

class ExpandedCategoryIdNotifierFromDevices extends Notifier<Set<int>> {
  @override
  Set<int> build() => <int>{};
  void toggle(int id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state}..add(id);
    }
  }
}
final isExpandedCategoryIdProviderFromDevicesPage = NotifierProvider<ExpandedCategoryIdNotifierFromDevices, Set<int>>(ExpandedCategoryIdNotifierFromDevices.new);

class DeviceSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String query) => state = query;
}
final deviceSearchQueryProvider = NotifierProvider<DeviceSearchQueryNotifier, String>(DeviceSearchQueryNotifier.new);

// Stream of devices by category (filtered by current user)
final deviceByCategoryStreamProvider = StreamProvider.family<List<Device>, int>((ref, categoryId) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  
  final repo = ref.watch(deviceRepositoryProvider);
  return repo.getDevicesByCategory(user.uid, categoryId);
});

// Filtered Stream
final filteredDeviceByCategoryProvider = Provider.family<AsyncValue<List<Device>>, int>((ref, categoryId) {
  final query = ref.watch(deviceSearchQueryProvider).toLowerCase();
  final devicesAsync = ref.watch(deviceByCategoryStreamProvider(categoryId));

  return devicesAsync.when(
    data: (devices) {
      if (query.isEmpty) return AsyncData(devices);
      final filtered = devices.where((device) {
        return device.name.toLowerCase().contains(query) ||
               device.ip.toLowerCase().contains(query) ||
               (device.location ?? '').toLowerCase().contains(query);
      }).toList();
      return AsyncData(filtered);
    },
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
  );
});

// Stream of all devices for current user (for pre-loading images)
final devicesStreamProvider = StreamProvider<List<Device>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  
  final repo = ref.watch(deviceRepositoryProvider);
  return repo.getDevices(user.uid);
});

// Image pre-loader provider
// This provider watches the devices stream and pre-caches images in the background
final devicesImagePreloader = Provider<void>((ref) {
  final devicesAsync = ref.watch(devicesStreamProvider);
  
  devicesAsync.whenData((devices) {
    for (final device in devices) {
      if (device.image != null && device.image!.startsWith('http')) {
        CachedNetworkImageProvider(device.image!);
      }
    }
  });
});

// Single Device Provider (Firestore)
final deviceByIdProvider = StreamProvider.family<Device?, String>((ref, String id) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  
  final repo = ref.watch(deviceRepositoryProvider);
  return repo.getDevices(user.uid).map((list) {
    try {
      return list.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  });
}); 

final deviceByIdFutureProvider = FutureProvider.family<Device?, String>((ref, String id) async {
  final repo = ref.watch(deviceRepositoryProvider);
  return repo.getDeviceById(id);
});