import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/home/models/diagnostic_stats.dart';

/// Provider para las estadísticas del home
/// TODO: Reemplazar con llamada real a Firebase/BD
final homeStatsProvider = FutureProvider<DiagnosticStats>((ref) async {
  // Simulación de delay de red
  await Future.delayed(const Duration(milliseconds: 500));

  // Datos de ejemplo para el nuevo modelo DSS
  return const DiagnosticStats(
    totalDevices: 45,
    totalDiagnostics: 128,
    devicesByCategory: {
      'CCTV y Videovigilancia': 24,
      'Control de Acceso': 15,
      'Red y Conectividad': 8,
      'Energía y Respaldo': 8,
    },
  );
});

