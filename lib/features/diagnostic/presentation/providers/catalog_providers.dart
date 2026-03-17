import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/auth/providers/auth_provider.dart';
import 'package:stiv/features/diagnostic/data/catalog_repository_firestore_impl.dart';
import 'package:stiv/features/diagnostic/models/catalog_repository.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/devices/domain/models/device.dart';
import 'package:stiv/features/devices/providers/devices_providers.dart' as dp;
import 'package:stiv/features/home/presentation/providers/recent_diagnostics_provider.dart';

class SelectedDeviceNotifier extends Notifier<Device?> {
  @override
  Device? build() => null;
  void setDevice(Device? device) => state = device;
}
/// Selected device provider for diagnostic flow
final selectedDeviceProvider = NotifierProvider<SelectedDeviceNotifier, Device?>(SelectedDeviceNotifier.new);

class ExpandedCategoryIdsNotifier extends Notifier<Set<int>> {
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
// State provider for expanded categories in device page
final isExpandedCategoryIdProvider = NotifierProvider<ExpandedCategoryIdsNotifier, Set<int>>(ExpandedCategoryIdsNotifier.new);

/// Catalog repository provider using Firestore
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepositoryFirestoreImpl(FirebaseFirestore.instance);
});

/// Categories provider - re-creates listener on auth state change
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getCategories();
});

/// Device by category provider - aliased from devices_providers (Firestore-based)
final deviceByCategoryProvider = dp.deviceByCategoryStreamProvider;

/// Device by ID provider - aliased from devices_providers (Firestore-based)
final deviceByIdProvider = dp.deviceByIdProvider;

/// Recent diagnostic IDs provider
final recentDiagnosticIdsProvider = Provider<List<String>>((ref) {
  final list = ref.watch(recentDiagnosticsProvider).value ?? [];
  return list.map((diagnostic) => diagnostic.id).toList();
});
