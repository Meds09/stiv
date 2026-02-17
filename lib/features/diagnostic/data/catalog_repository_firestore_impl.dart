import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stiv/features/diagnostic/models/catalog_repository.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/devices/domain/models/device.dart';

/// Firestore implementation of CatalogRepository
class CatalogRepositoryFirestoreImpl implements CatalogRepository {
  final FirebaseFirestore _firestore;

  CatalogRepositoryFirestoreImpl(this._firestore);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Category(
          id: data['id'] as int,
          name: data['name'] as String,
          emoji: data['emoji'] as String,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Device>> getDevicesByCategory(int categoryId) async {
    try {
      final snapshot = await _firestore
          .collection('devices')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      return snapshot.docs.map((doc) => Device.fromFirestore(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Device?> getDeviceById(String deviceId) async {
    try {
      final doc = await _firestore.collection('devices').doc(deviceId).get();
      if (doc.exists) {
        return Device.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      
      rethrow;
    }
  }
}
