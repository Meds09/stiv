import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/services/image_upload_service.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  final storage = ref.watch(firebaseStorageProvider);
  return ImageUploadService(storage);
});
