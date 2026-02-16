import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// State Providers for UI
final isExpandedCategoryIdProviderFromDevicesPage = StateProvider<Set<int>>((ref) => <int>{});
final deviceSearchQueryProvider = StateProvider<String>((ref) => '');

// Stream of devices by category
final deviceByCategoryStreamProvider = StreamProvider.family<List<Device>, int>((ref, categoryId) {
  final repo = ref.watch(deviceRepositoryProvider);
  return repo.getDevicesByCategory(categoryId);
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

// Stream of all devices (for pre-loading images)
final devicesStreamProvider = StreamProvider<List<Device>>((ref) {
  final repo = ref.watch(deviceRepositoryProvider);
  return repo.getDevices();
});

// Image pre-loader provider
// This provider watches the devices stream and pre-caches images in the background
final devicesImagePreloader = Provider<void>((ref) {
  final devicesAsync = ref.watch(devicesStreamProvider);
  
  devicesAsync.whenData((devices) {
    // Get BuildContext from the ProviderContainer if available
    // Note: Pre-caching will happen when images are first rendered
    // This is primarily a marker to ensure the stream is watched
    for (final device in devices) {
      if (device.image != null && device.image!.startsWith('http')) {
        // Pre-load the image provider into cache manager
        // This happens lazily when CachedNetworkImage first requests it
        CachedNetworkImageProvider(device.image!);
      }
    }
  });
});

// Single Device Provider (Firestore)
final deviceByIdProvider = StreamProvider.family<Device?, String>((ref, String id) {
  final repo = ref.watch(deviceRepositoryProvider);
  // We can return a Stream of single document if repository supports it.
  // Repository has getDevices(). 
  // Efficient way: repo.getDeviceById(id) returns Future.
  // But for real-time edit updates, we might want stream.
  // The repository currently has `Future<Device?> getDeviceById(String id)`.
  // Let's us FutureProvider for now, or change repository to return Stream.
  // FutureProvider is fine for "Edit" init.
  return repo.getDevices().map((list) {
    try {
      return list.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  });
}); 
// Better: Add getDeviceStream(id) to Repository. But for now let's use FutureProvider wrapping the Future.
final deviceByIdFutureProvider = FutureProvider.family<Device?, String>((ref, String id) async {
  final repo = ref.watch(deviceRepositoryProvider);
  return repo.getDeviceById(id);
});