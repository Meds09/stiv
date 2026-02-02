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
  Stream<List<Device>> getDevices() {
    return _devicesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Device.fromFirestore(doc)).toList();
    });
  }

  @override
  Stream<List<Device>> getDevicesByCategory(int categoryId) {
    return _devicesCollection
        .where('categoryId', isEqualTo: categoryId)
        .snapshots() // Stream updates
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
    // We let Firestore generate the ID if it's empty, or use the one provided.
    // Ideally, for a new device, we might want Firestore to generate the ID.
    // But our model has 'id'. Let's see. 
    // If the device.id is 'new' or empty, we treat it as new.
    
    // Better approach: simple add() lets firestore generate ID.
    // BUT our Device object HAS an ID field. 
    // So usually we create a DTO or we just ignore the ID field when writing 
    // and let Firestore generate it, then read it back.
    
    // For now, let's assume if ID is empty string, we add.
    if (device.id.isEmpty) {
        final docRef = await _devicesCollection.add(device.toJson()..remove('id'));
        // If we needed to return the device with the new ID, we would do it here.
    } else {
        // If it has an ID, we set it (could be overwrite).
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
