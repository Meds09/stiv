import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stiv/features/guides/domain/models/guides.dart';
import 'package:stiv/features/guides/domain/repositories/guide_repository.dart';

class GuideRepositoryImpl implements GuideRepository {
  final FirebaseFirestore _firestore;

  GuideRepositoryImpl(this._firestore);

  /// Helper to get the collection reference
  CollectionReference<Map<String, dynamic>> get _guidesCollection =>
      _firestore.collection('guides');

  @override
  Stream<List<Guide>> getGuides() {
    return _guidesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Guide.fromMap(doc.id, doc.data())).toList();
    });
  }

  /// Stream version for real-time updates
  Stream<List<Guide>> getGuidesStream() {
    return _guidesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Guide.fromMap(doc.id, doc.data())).toList();
    });
  }

  /// Get only active guides
  Stream<List<Guide>> getActiveGuidesStream() {
    return _guidesCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Guide.fromMap(doc.id, doc.data())).toList();
    });
  }

  /// Get guides by category
  Stream<List<Guide>> getGuidesByCategory(String category) {
    return _guidesCollection
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Guide.fromMap(doc.id, doc.data())).toList();
    });
  }
}
