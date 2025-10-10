import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/services/storage_service.dart';
//import 'services/storage_service.dart';
import 'app.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();
final storage = StorageService();
await storage.init();
runApp(ProviderScope(overrides: [
storageServiceProvider.overrideWithValue(storage),
], child: const StivApp()));
}