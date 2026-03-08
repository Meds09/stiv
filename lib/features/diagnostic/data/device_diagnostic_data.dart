import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';
import 'package:stiv/features/diagnostic/data/diagnostic_questions_data.dart';

/// Árbol de preguntas unificado que comienza con la selección del tipo de
/// dispositivo. Las preguntas de los sub-árboles existentes se reutilizan
/// mediante referencias a [diagnosticQuestionTrees].
///
/// Flujo:
///   dev_0 → (dispositivo seleccionado) → dev_X_sym → (síntoma) → Q específica…

/// Lista plana de todas las preguntas del flujo unificado.
/// Se construye al final de este archivo.
final List<DiagnosticQuestion> deviceDiagnosticQuestions =
    _buildDeviceDiagnosticQuestions();

// ─────────────────────────────────────────────────────────────────────────────
// PREGUNTA RAÍZ — Tipo de dispositivo
// ─────────────────────────────────────────────────────────────────────────────
const _rootQuestion = DiagnosticQuestion(
  id: 'dev_0',
  text: '¿Qué tipo de dispositivo presenta el problema?',
  subtitle: 'Selecciona la categoría del equipo afectado',
  options: [
    QuestionOption(
      id: 'dev_0_cctv',
      label: 'CCTV y Videovigilancia',
      description: 'Cámaras, DVR, NVR',
      icon: Icons.videocam_rounded,
      nextQuestionId: 'dev_cctv_sym',
    ),
    QuestionOption(
      id: 'dev_0_net',
      label: 'Red y Conectividad',
      description: 'Switch, cables, radioenlaces',
      icon: Icons.router_rounded,
      nextQuestionId: 'dev_net_sym',
    ),
    QuestionOption(
      id: 'dev_0_nrg',
      label: 'Energía y Respaldo',
      description: 'UPS, plantas eléctricas, fuentes',
      icon: Icons.bolt_rounded,
      nextQuestionId: 'dev_nrg_sym',
    ),
    QuestionOption(
      id: 'dev_0_acc',
      label: 'Control de Acceso',
      description: 'Arcos, rayos X, biométricos',
      icon: Icons.security_rounded,
      nextQuestionId: 'dev_acc_sym',
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// PREGUNTAS DE SÍNTOMA POR DISPOSITIVO (Q2)
// ─────────────────────────────────────────────────────────────────────────────

const _cctvSymQuestion = DiagnosticQuestion(
  id: 'dev_cctv_sym',
  text: '¿Qué problema presenta el equipo?',
  subtitle: 'Selecciona el síntoma principal que describes',
  options: [
    QuestionOption(
      id: 'dev_cctv_sym_pow',
      label: 'No enciende o sin señal',
      description: 'El equipo no da señales de vida',
      icon: Icons.power_settings_new_rounded,
      nextQuestionId: 'pow_2_cctv',
    ),
    QuestionOption(
      id: 'dev_cctv_sym_con',
      label: 'Sin conexión de red',
      description: 'No se detecta en la red local',
      icon: Icons.wifi_off_rounded,
      nextQuestionId: 'con_2_cctv',
    ),
    QuestionOption(
      id: 'dev_cctv_sym_dsp',
      label: 'Imagen borrosa o degradada',
      description: 'Problema de calidad de video',
      icon: Icons.blur_on_rounded,
      nextQuestionId: 'dsp_2_cam',
    ),
    QuestionOption(
      id: 'dev_cctv_sym_aud',
      label: 'Ruido o sonido inusual',
      description: 'Sonidos inusuales del DVR/NVR',
      icon: Icons.graphic_eq_rounded,
      nextQuestionId: 'aud_2_nvr',
    ),
    QuestionOption(
      id: 'dev_cctv_sym_cam',
      label: 'Cámara no graba o falla',
      description: 'Problemas de grabación o PTZ',
      icon: Icons.videocam_off_rounded,
      nextQuestionId: 'cam_2_novid',
    ),
    QuestionOption(
      id: 'dev_cctv_sym_other',
      label: 'Otro problema',
      description: 'No está en la lista anterior',
      icon: Icons.help_outline_rounded,
      nextQuestionId: 'oth_1',
    ),
  ],
);

const _netSymQuestion = DiagnosticQuestion(
  id: 'dev_net_sym',
  text: '¿Qué problema presenta el equipo de red?',
  subtitle: 'Selecciona el síntoma principal que observas',
  options: [
    QuestionOption(
      id: 'dev_net_sym_pow',
      label: 'No enciende',
      description: 'Sin LEDs ni señales de energía',
      icon: Icons.power_settings_new_rounded,
      nextQuestionId: 'pow_2_net',
    ),
    QuestionOption(
      id: 'dev_net_sym_con',
      label: 'Sin conexión o red caída',
      description: 'Equipos sin acceso a la red',
      icon: Icons.wifi_off_rounded,
      nextQuestionId: 'con_2_net',
    ),
    QuestionOption(
      id: 'dev_net_sym_aud',
      label: 'Ruido o ventilador ruidoso',
      description: 'Sonidos inusuales del switch',
      icon: Icons.graphic_eq_rounded,
      nextQuestionId: 'aud_2_switch',
    ),
    QuestionOption(
      id: 'dev_net_sym_other',
      label: 'Otro problema',
      description: 'No está en la lista anterior',
      icon: Icons.help_outline_rounded,
      nextQuestionId: 'oth_1',
    ),
  ],
);

const _nrgSymQuestion = DiagnosticQuestion(
  id: 'dev_nrg_sym',
  text: '¿Qué problema presenta el UPS o fuente de poder?',
  subtitle: 'Selecciona el síntoma que describes',
  options: [
    QuestionOption(
      id: 'dev_nrg_sym_pow',
      label: 'No enciende o no da poder',
      description: 'El UPS no responde o no entrega energía',
      icon: Icons.power_settings_new_rounded,
      nextQuestionId: 'pow_2_ups',
    ),
    QuestionOption(
      id: 'dev_nrg_sym_aud',
      label: 'Alarma, pitidos o ruido',
      description: 'Sonidos de alerta del UPS',
      icon: Icons.graphic_eq_rounded,
      nextQuestionId: 'aud_2_ups',
    ),
    QuestionOption(
      id: 'dev_nrg_sym_other',
      label: 'Otro problema',
      description: 'No está en la lista anterior',
      icon: Icons.help_outline_rounded,
      nextQuestionId: 'oth_1',
    ),
  ],
);

const _accSymQuestion = DiagnosticQuestion(
  id: 'dev_acc_sym',
  text: '¿Qué problema presenta el equipo de acceso?',
  subtitle: 'Selecciona el síntoma que observas',
  options: [
    QuestionOption(
      id: 'dev_acc_sym_pow',
      label: 'No enciende / sin alimentación',
      description: 'El panel o equipo no tiene energía',
      icon: Icons.power_settings_new_rounded,
      nextQuestionId: 'pow_2_acc',
    ),
    QuestionOption(
      id: 'dev_acc_sym_con',
      label: 'Sin comunicación con el sistema',
      description: 'No conecta con el software de gestión',
      icon: Icons.wifi_off_rounded,
      nextQuestionId: 'con_2_acc',
    ),
    QuestionOption(
      id: 'dev_acc_sym_lock',
      label: 'Cerradura o lector no funciona',
      description: 'Panel OK pero la cerradura, biométrico o lector fallan',
      icon: Icons.lock_open_rounded,
      nextQuestionId: 'oth_2_acc',
    ),
    QuestionOption(
      id: 'dev_acc_sym_other',
      label: 'Otro problema',
      description: 'No está en la lista anterior',
      icon: Icons.help_outline_rounded,
      nextQuestionId: 'oth_2_acc',
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// Construcción de la lista plana combinada
// ─────────────────────────────────────────────────────────────────────────────

List<DiagnosticQuestion> _buildDeviceDiagnosticQuestions() {
  final all = <DiagnosticQuestion>[
    _rootQuestion,
    _cctvSymQuestion,
    _netSymQuestion,
    _nrgSymQuestion,
    _accSymQuestion,
    // Sub-árboles existentes de todos los síntomas
    ...diagnosticQuestionTrees['power_issue'] ?? [],
    ...diagnosticQuestionTrees['connectivity_issue'] ?? [],
    ...diagnosticQuestionTrees['display_issue'] ?? [],
    ...diagnosticQuestionTrees['audio_issue'] ?? [],
    ...diagnosticQuestionTrees['camera_issue'] ?? [],
    ...diagnosticQuestionTrees['other_issue'] ?? [],
  ];

  // Deduplicar por ID (por si acaso algún árbol tiene preguntas compartidas)
  final seen = <String>{};
  return all.where((q) => seen.add(q.id)).toList();
}
