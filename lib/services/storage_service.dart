import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:stiv/features/diagnostic/data/models/failure_case.dart';

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());


class StorageService {
late Box _failures;
Future<void> init() async {
await Hive.initFlutter();
_failures = await Hive.openBox('failures');
if (_failures.isEmpty) {
// TODO: cargar data_seed/failures_seed.json y volcar en Hive
}
}
Future<List<FailureCase>> getFailures() async {
// TODO: mapear desde Hive (usa Freezed/JSON si prefieres)
return [];
}
}