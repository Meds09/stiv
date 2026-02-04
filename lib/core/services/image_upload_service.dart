import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

class ImageUploadService {
  final FirebaseStorage _storage;

  ImageUploadService(this._storage);

  /// Uploads a device image to Firebase Storage.
  /// 
  /// Returns the download URL of the uploaded image.
  /// 
  /// [image] - The image file to upload.
  /// [deviceId] - The ID of the device (used for naming the file).
  Future<String> uploadDeviceImage(XFile image, String deviceId) async {
    try {
      // 1. Compress image
      final File file = File(image.path);
      final String extension = path.extension(image.path).toLowerCase();
      
      // Target path for compression (temp)
      final String tempPath = image.path.replaceAll(extension, '_compressed.jpg');
      
      XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        tempPath,
        quality: 85, // Good quality/size balance
        minWidth: 1024, // Resize if too large
        minHeight: 1024,
      );

      final File fileToUpload = result != null ? File(result.path) : file;

      // 2. Define storage reference
      // using .jpg since we compressed to jpeg preferably, or keep original extension if compression failed
      final String storagePath = 'devices/$deviceId${millisecondsSinceEpoch()}.jpg';
      final Reference ref = _storage.ref().child(storagePath);

      // 3. Upload
      final UploadTask uploadTask = ref.putFile(
        fileToUpload,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      
      // 4. Get URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      // Cleanup temp file
      if (result != null && await File(result.path).exists()) {
        await File(result.path).delete();
      }

      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
  
  String millisecondsSinceEpoch() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
