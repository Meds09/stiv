import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stiv/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'services/storage_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //BORRAR SHARRED PREFERENCES PARA PRUEBAS POR PRIMERA EJECUCION

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final storage = StorageService();
  await storage.init();
  runApp(
    ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storage)],
      child: const StivApp(),
    ),
  );
}
