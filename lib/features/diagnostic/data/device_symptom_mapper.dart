import 'package:flutter/material.dart';

/// Representa un síntoma disponible para un dispositivo:
/// el [questionId] es la primera pregunta del sub-árbol DSS,
/// y [symptomKey] es la clave de hipótesis del motor de inferencia.
class DeviceSymptom {
  final int problemId;
  final String label;
  final String description;
  final IconData icon;
  final String questionId; // Primer nodo del sub-árbol DSS
  final String symptomKey; // Clave en hypothesesBySymptom

  const DeviceSymptom({
    required this.problemId,
    required this.label,
    required this.description,
    required this.icon,
    required this.questionId,
    required this.symptomKey,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Mapa de síntomas por categoría de dispositivo
// categoryId: 1=CCTV, 2=Red, 3=Energía, 4=Acceso
// ─────────────────────────────────────────────────────────────────────────────

const _cctvSymptoms = <DeviceSymptom>[
  DeviceSymptom(
    problemId: 1,
    label: 'No enciende o sin señal',
    description: 'El equipo no da señales de vida',
    icon: Icons.power_settings_new_rounded,
    questionId: 'pow_2_cctv',
    symptomKey: 'power_issue',
  ),
  DeviceSymptom(
    problemId: 2,
    label: 'Sin conexión de red',
    description: 'No se detecta en la red local',
    icon: Icons.wifi_off_rounded,
    questionId: 'con_2_cctv',
    symptomKey: 'connectivity_issue',
  ),
  DeviceSymptom(
    problemId: 3,
    label: 'Imagen borrosa o degradada',
    description: 'Problema de calidad de video',
    icon: Icons.blur_on_rounded,
    questionId: 'dsp_2_cam',
    symptomKey: 'display_issue',
  ),
  DeviceSymptom(
    problemId: 4,
    label: 'Ruido o sonido inusual',
    description: 'Sonidos inusuales del DVR/NVR',
    icon: Icons.graphic_eq_rounded,
    questionId: 'aud_2_nvr',
    symptomKey: 'audio_issue',
  ),
  DeviceSymptom(
    problemId: 6,
    label: 'Cámara no graba o falla PTZ',
    description: 'Problemas de grabación o movimiento',
    icon: Icons.videocam_off_rounded,
    questionId: 'cam_2_novid',
    symptomKey: 'camera_issue',
  ),
  DeviceSymptom(
    problemId: 5,
    label: 'No estoy seguro del problema',
    description: 'Quiero describir el problema con IA',
    icon: Icons.help_outline_rounded,
    questionId: 'oth_1',
    symptomKey: 'other_issue',
  ),
];

const _networkSymptoms = <DeviceSymptom>[
  DeviceSymptom(
    problemId: 1,
    label: 'No enciende',
    description: 'Sin LEDs ni señales de energía',
    icon: Icons.power_settings_new_rounded,
    questionId: 'pow_2_net',
    symptomKey: 'power_issue',
  ),
  DeviceSymptom(
    problemId: 2,
    label: 'Sin conexión o red caída',
    description: 'Equipos sin acceso a la red',
    icon: Icons.wifi_off_rounded,
    questionId: 'con_2_net',
    symptomKey: 'connectivity_issue',
  ),
  DeviceSymptom(
    problemId: 4,
    label: 'Ruido o ventilador ruidoso',
    description: 'Sonidos inusuales del switch/router',
    icon: Icons.graphic_eq_rounded,
    questionId: 'aud_2_switch',
    symptomKey: 'audio_issue',
  ),
  DeviceSymptom(
    problemId: 5,
    label: 'No estoy seguro del problema',
    description: 'Quiero describir el problema con IA',
    icon: Icons.help_outline_rounded,
    questionId: 'oth_1',
    symptomKey: 'other_issue',
  ),
];

const _energySymptoms = <DeviceSymptom>[
  DeviceSymptom(
    problemId: 1,
    label: 'No enciende o no da poder',
    description: 'El UPS no responde o no entrega energía',
    icon: Icons.power_settings_new_rounded,
    questionId: 'pow_2_ups',
    symptomKey: 'power_issue',
  ),
  DeviceSymptom(
    problemId: 4,
    label: 'Alarma, pitidos o ruido',
    description: 'Sonidos de alerta del UPS',
    icon: Icons.graphic_eq_rounded,
    questionId: 'aud_2_ups',
    symptomKey: 'audio_issue',
  ),
  DeviceSymptom(
    problemId: 5,
    label: 'No estoy seguro del problema',
    description: 'Quiero describir el problema con IA',
    icon: Icons.help_outline_rounded,
    questionId: 'oth_1',
    symptomKey: 'other_issue',
  ),
];

const _accessSymptoms = <DeviceSymptom>[
  DeviceSymptom(
    problemId: 1,
    label: 'No enciende / sin alimentación',
    description: 'El panel o equipo no tiene energía',
    icon: Icons.power_settings_new_rounded,
    questionId: 'pow_2_acc',
    symptomKey: 'power_issue',
  ),
  DeviceSymptom(
    problemId: 2,
    label: 'Sin comunicación con el sistema',
    description: 'No conecta con el software de gestión',
    icon: Icons.wifi_off_rounded,
    questionId: 'con_2_acc',
    symptomKey: 'connectivity_issue',
  ),
  DeviceSymptom(
    problemId: 3,
    label: 'Cerradura o lector no funciona',
    description: 'Panel OK pero biométrico o lector falla',
    icon: Icons.lock_open_rounded,
    questionId: 'oth_2_acc',
    symptomKey: 'other_issue',
  ),
  DeviceSymptom(
    problemId: 5,
    label: 'No estoy seguro del problema',
    description: 'Quiero describir el problema con IA',
    icon: Icons.help_outline_rounded,
    questionId: 'oth_1',
    symptomKey: 'other_issue',
  ),
];

/// Retorna los síntomas disponibles para una categoría de dispositivo.
/// [categoryId] debe ser 1 (CCTV), 2 (Red), 3 (Energía) o 4 (Acceso).
List<DeviceSymptom> getSymptomsForCategory(int categoryId) {
  switch (categoryId) {
    case 1:
      return _cctvSymptoms;
    case 2:
      return _networkSymptoms;
    case 3:
      return _energySymptoms;
    case 4:
      return _accessSymptoms;
    default:
      return const [
        DeviceSymptom(
          problemId: 5,
          label: 'No estoy seguro del problema',
          description: 'Quiero describir el problema con IA',
          icon: Icons.help_outline_rounded,
          questionId: 'oth_1',
          symptomKey: 'other_issue',
        ),
      ];
  }
}

/// Busca el [DeviceSymptom] dado un [problemId] y [categoryId].
/// Retorna `null` si no hay mapeo definido.
DeviceSymptom? getSymptomForProblem(int categoryId, int problemId) {
  final symptoms = getSymptomsForCategory(categoryId);
  try {
    return symptoms.firstWhere((s) => s.problemId == problemId);
  } catch (_) {
    return null;
  }
}
