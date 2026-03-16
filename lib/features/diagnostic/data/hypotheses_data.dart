import 'package:stiv/features/diagnostic/models/hypothesis.dart';
import 'package:stiv/features/diagnostic/data/hypotheses/cctv_hypotheses.dart';
import 'package:stiv/features/diagnostic/data/hypotheses/network_hypotheses.dart';
import 'package:stiv/features/diagnostic/data/hypotheses/energy_hypotheses.dart';
import 'package:stiv/features/diagnostic/data/hypotheses/access_hypotheses.dart';
import 'package:stiv/features/diagnostic/data/hypotheses/shared_hypotheses.dart';

/// Hipótesis diagnósticas agrupadas por síntoma.
///
/// Este archivo actúa como ensamblador: importa los listados de hipótesis
/// definidos en `data/hypotheses/` y los combina en el mapa que
/// consume [DiagnosticFlowProvider].
///
/// Para agregar o editar hipótesis de un tipo de dispositivo, edita
/// el archivo correspondiente en `data/hypotheses/`.
final Map<String, List<Hypothesis>> hypothesesBySymptom = {
  // ══════════════════════════════════════════════════════
  // POWER ISSUE — "No enciende"
  // ══════════════════════════════════════════════════════
  'power_issue': const [
    ...energyPowerHypotheses,  // PoE, adaptador, cable, breaker, UPS + nuevas
    ...accessOtherHypotheses,  // batería panel acceso
  ],

  // ══════════════════════════════════════════════════════
  // CONNECTIVITY ISSUE — "Sin conexión"
  // ══════════════════════════════════════════════════════
  'connectivity_issue': const [
    ...networkConnectivityHypotheses,
  ],

  // ══════════════════════════════════════════════════════
  // DISPLAY ISSUE — "Imagen borrosa / sin video"
  // ══════════════════════════════════════════════════════
  'display_issue': const [
    ...cctvDisplayHypotheses,
  ],

  // ══════════════════════════════════════════════════════
  // AUDIO ISSUE — "Ruido extraño / problema de sonido"
  // ══════════════════════════════════════════════════════
  'audio_issue': const [
    ...cctvAudioHypotheses,   // HDD, ventilador, sobrecalentamiento, bucle tierra
    ...energyAudioHypotheses, // UPS pitidos, sobrecarga, bypass
  ],

  // ══════════════════════════════════════════════════════
  // CAMERA ISSUE — "Cámara falla / no graba"
  // Incluye hipótesis de cámara IP, grabación, ONVIF y ancho de banda
  // ══════════════════════════════════════════════════════
  'camera_issue': const [
    ...cctvCameraHypotheses,
  ],

  // ══════════════════════════════════════════════════════
  // OTHER ISSUE — "Otro problema"
  // ══════════════════════════════════════════════════════
  'other_issue': const [
    ...sharedOtherHypotheses,
    ...accessOtherHypotheses,
  ],
};
