import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/home/models/home_stats.dart';

/// Provider para las estadísticas del home
/// TODO: Reemplazar con llamada real a Firebase/BD
/// Ejemplo: FutureProvider que llame a FirebaseFirestore.instance.collection('stats').doc(userId).get()
final homeStatsProvider = FutureProvider<HomeStats>((ref) async {
  // Simulación de delay de red
  await Future.delayed(const Duration(milliseconds: 500));

  // TODO: Reemplazar con llamada real
  // final user = ref.watch(currentUserProvider);
  // if (user == null) return HomeStats.empty();
  // 
  // final statsDoc = await FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(user.uid)
  //     .collection('stats')
  //     .doc('summary')
  //     .get();
  // 
  // if (!statsDoc.exists) return HomeStats.empty();
  // return HomeStats.fromJson(statsDoc.data()!);

  // Datos de ejemplo
  return const HomeStats(
    cameras: 12,
    electricalSupport: 8,
    accessControl: 15,
    camerasHistory: [10, 11, 12, 11, 12, 10, 12],
    electricalHistory: [7, 8, 8, 7, 8, 8, 8],
    accessControlHistory: [14, 15, 15, 14, 15, 15, 15],
    readinessPercentage: 89.0,
    readinessHistory: [85.0, 87.0, 89.0, 88.0, 89.0, 88.0, 89.0],
  );
});

