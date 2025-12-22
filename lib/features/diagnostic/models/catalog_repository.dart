import 'category.dart';
import 'device.dart';

abstract class CatalogRepository {
  Future<List<Category>> getCategories();
  Future<List<Device>> getDevicesByCategory(int categoryId);
  Future<Device?> getDeviceById(int deviceId);
}
