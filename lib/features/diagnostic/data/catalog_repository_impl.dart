import 'package:stiv/features/diagnostic/data/mock_catalog_data.dart';
import 'package:stiv/features/diagnostic/models/catalog_repository.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/diagnostic/models/device.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  @override
  Future<List<Category>> getCategories() async {
    //simulando llamada asyn a la BD
    await Future.delayed(const Duration(milliseconds: 200));
    return mockCategories;
  }

  @override
  Future<List<Device>> getDevicesByCategory(int categoryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockDevices
        .where((device) => device.categoryId == categoryId)
        .toList();
  }
}
