import 'package:stiv/features/devices/domain/models/device.dart';

abstract class DeviceRepository {
  /// Stream of all devices. Real-time updates.
  Stream<List<Device>> getDevices();

  /// Stream of devices filtered by category.
  Stream<List<Device>> getDevicesByCategory(int categoryId);

  /// Get a single device by ID.
  Future<Device?> getDeviceById(String id);

  /// Create a new device.
  Future<void> createDevice(Device device);

  /// Update an existing device.
  Future<void> updateDevice(Device device);

  /// Delete a device.
  Future<void> deleteDevice(String id);
}
