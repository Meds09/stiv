import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/diagnostic/data/catalog_repository_impl.dart';
import 'package:stiv/features/diagnostic/models/catalog_repository.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/diagnostic/models/device.dart';

//Proveedor del repositorio

final selectedDeviceProvider =
    StateProvider<Device?>((ref) => null);

final isExpandedCategoryIdProvider = StateProvider<Set<int>>((ref) => <int>{});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepositoryImpl();
});

//lista de categorias
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.read(catalogRepositoryProvider);
  return repo.getCategories();
});

final deviceByCategoryProvider = FutureProvider.family((ref, int categoryId) {
  final repo = ref.read(catalogRepositoryProvider);
  return repo.getDevicesByCategory(categoryId);
});

final deviceByIdProvider = FutureProvider.family<Device?, int>((ref, int deviceId) async {
final repo = ref.read(catalogRepositoryProvider);
  return repo.getDeviceById(deviceId);
},
);
