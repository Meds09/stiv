import 'package:stiv/features/devices/domain/models/device.dart';

abstract class DeviceRepository {
  /// Stream of all devices for a specific user. Real-time updates.
  Stream<List<Device>> getDevices(String userId);

  /// Stream of devices filtered by category for a specific user.
  Stream<List<Device>> getDevicesByCategory(String userId, int categoryId);

  /// Get a single device by ID (validates ownership).
  Future<Device?> getDeviceById(String id);

  /// Create a new device.
  Future<void> createDevice(Device device);

  /// Update an existing device.
  Future<void> updateDevice(Device device);

  /// Delete a device.
  Future<void> deleteDevice(String id);
}
