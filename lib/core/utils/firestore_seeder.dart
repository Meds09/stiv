import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stiv/features/diagnostic/data/mock_catalog_data.dart';

/// Utility class to seed Firestore with initial data
class FirestoreSeeder {
  static final _firestore = FirebaseFirestore.instance;

  /// Seeds the database with categories and devices from mock data
  /// Only runs if collections are empty to avoid duplicates
  static Future<void> seedDatabase() async {
    try {
      print('🌱 Checking if database needs seeding...');
      
      // Check if data already exists
      final devicesSnapshot = await _firestore.collection('devices').limit(1).get();
      final categoriesSnapshot = await _firestore.collection('categories').limit(1).get();
      
      if (devicesSnapshot.docs.isNotEmpty && categoriesSnapshot.docs.isNotEmpty) {
        print('✅ Database already has data. Skipping seed.');
        return;
      }

      print('📦 Seeding database with initial data...');
      
      // Seed categories first
      await _seedCategories();
      
      // Then seed devices
      await _seedDevices();
      
      print('✅ Database seeded successfully!');
    } catch (e) {
      print('❌ Error seeding database: $e');
      rethrow;
    }
  }

  /// Seeds categories into Firestore
  static Future<void> _seedCategories() async {
    final collection = _firestore.collection('categories');
    final batch = _firestore.batch();

    for (final category in mockCategories) {
      // Use category ID as document ID for easy querying
      final docRef = collection.doc(category.id.toString());
      batch.set(docRef, {
        'id': category.id,
        'name': category.name,
        'emoji': category.emoji,
      });
    }

    await batch.commit();
    print('  ✓ ${mockCategories.length} categories seeded');
  }

  /// Seeds devices into Firestore
  static Future<void> _seedDevices() async {
    final collection = _firestore.collection('devices');
    final batch = _firestore.batch();

    for (final device in mockDevices) {
      // Use the device ID as the document ID
      final docRef = collection.doc(device.id);
      
      // Convert device to JSON and store
      batch.set(docRef, device.toJson());
    }

    await batch.commit();
    print('  ✓ ${mockDevices.length} devices seeded');
  }

  /// Force re-seed (deletes existing data and re-seeds)
  /// USE WITH CAUTION - Only for development/testing
  static Future<void> forceReseed() async {
    try {
      print('⚠️  FORCE RE-SEEDING - Deleting existing data...');
      
      // Delete all existing data
      await _deleteCollection('devices');
      await _deleteCollection('categories');
      
      // Re-seed
      await seedDatabase();
    } catch (e) {
      print('❌ Error during force reseed: $e');
      rethrow;
    }
  }

  /// Helper to delete all documents in a collection
  static Future<void> _deleteCollection(String collectionName) async {
    final collection = _firestore.collection(collectionName);
    final snapshot = await collection.get();
    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    print('  ✓ Deleted ${snapshot.docs.length} documents from $collectionName');
  }
}
