import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stiv/features/devices/domain/models/device.dart';
import 'package:stiv/features/devices/domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final FirebaseFirestore _firestore;

  DeviceRepositoryImpl(this._firestore);

  /// Helper to get the collection reference
  CollectionReference<Map<String, dynamic>> get _devicesCollection =>
      _firestore.collection('devices');

  @override
  Stream<List<Device>> getDevices(String userId) {
    return _devicesCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Device.fromFirestore(doc)).toList();
    });
  }

  @override
  Stream<List<Device>> getDevicesByCategory(String userId, int categoryId) {
    return _devicesCollection
        .where('userId', isEqualTo: userId)
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Device.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<Device?> getDeviceById(String id) async {
    final doc = await _devicesCollection.doc(id).get();
    if (doc.exists) {
      return Device.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<void> createDevice(Device device) async {
    if (device.userId.isEmpty) {
      throw Exception("Cannot create device without userId");
    }

    if (device.id.isEmpty) {
      await _devicesCollection.add(device.toJson()..remove('id'));
    } else {
      await _devicesCollection.doc(device.id).set(device.toJson());
    }
  }

  @override
  Future<void> updateDevice(Device device) async {
    if (device.id.isEmpty) throw Exception("Cannot update device without ID");
    await _devicesCollection.doc(device.id).update(device.toJson());
  }

  @override
  Future<void> deleteDevice(String id) async {
    await _devicesCollection.doc(id).delete();
  }
}
