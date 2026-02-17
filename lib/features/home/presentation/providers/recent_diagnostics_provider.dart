import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/home/models/recent_diagnostic.dart';

/// Provider para los diagnósticos recientes
/// TODO: Reemplazar con llamada real a Firebase/BD
/// Ejemplo: StreamProvider que escuche cambios en tiempo real
final recentDiagnosticsProvider = FutureProvider<List<RecentDiagnostic>>((ref) async {
  // Simulación de delay de red
  await Future.delayed(const Duration(milliseconds: 600));

  // TODO: Reemplazar con llamada real a Firestore
  // final user = ref.watch(currentUserProvider);
  // if (user == null) return [];
  // 
  // final diagnosticsSnapshot = await FirebaseFirestore.instance
  //     .collection('diagnostics')
  //     .where('userId', isEqualTo: user.uid)
  //     .orderBy('date', descending: true)
  //     .limit(5)
  //     .get();
  // 
  // return diagnosticsSnapshot.docs
  //     .map((doc) => RecentDiagnostic.fromJson({
  //           'id': doc.id,
  //           ...doc.data(),
  //         }))
  //     .toList();

  // Datos de ejemplo (temporales hasta conectar con Firestore)
  return [
    RecentDiagnostic(
      id: '1',
      userId: 'mock',
      deviceName: 'Laptop Dell XPS 15',
      deviceType: 'Laptop',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      status: DiagnosticStatus.success,
      issueFound: 'Sistema operativo actualizado',
    ),
    RecentDiagnostic(
      id: '2',
      userId: 'mock',
      deviceName: 'iPhone 13 Pro',
      deviceType: 'Smartphone',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: DiagnosticStatus.warning,
      issueFound: 'Batería con 78% de capacidad',
    ),
    RecentDiagnostic(
      id: '3',
      userId: 'mock',
      deviceName: 'MacBook Pro M1',
      deviceType: 'Laptop',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: DiagnosticStatus.success,
      issueFound: 'Sin problemas detectados',
    ),
  ];
});
