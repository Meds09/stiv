import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';
import 'package:stiv/features/diagnostic/data/questions/cctv_questions.dart';
import 'package:stiv/features/diagnostic/data/questions/cctv_detail_questions.dart';
import 'package:stiv/features/diagnostic/data/questions/network_questions.dart';
import 'package:stiv/features/diagnostic/data/questions/energy_questions.dart';
import 'package:stiv/features/diagnostic/data/questions/access_questions.dart';
import 'package:stiv/features/diagnostic/data/questions/shared_questions.dart';

/// Árboles de preguntas de diagnóstico por síntoma.
///
/// Este archivo actúa como ensamblador: importa los sub-árboles
/// definidos en `data/questions/` y los combina en el mapa que
/// consume [DiagnosticFlowProvider].
///
/// Para agregar o editar preguntas de un tipo de dispositivo, edita
/// el archivo correspondiente en `data/questions/`.
final Map<String, List<DiagnosticQuestion>> diagnosticQuestionTrees = {
  // ═══════════════════════════════════════════════════
  // POWER ISSUE — "No enciende"
  // ═══════════════════════════════════════════════════
  'power_issue': [
    // ── Paso 1: selección de dispositivo ──
    const DiagnosticQuestion(
      id: 'pow_1',
      text: '¿Qué tipo de equipo presenta el problema?',
      subtitle: 'Selecciona la categoría del dispositivo',
      options: [
        QuestionOption(id: 'pow_1_cctv', label: 'Cámara / DVR / NVR', icon: Icons.videocam_rounded, nextQuestionId: 'pow_2_cctv'),
        QuestionOption(id: 'pow_1_net', label: 'Switch / Router / AP', icon: Icons.router_rounded, nextQuestionId: 'pow_2_net'),
        QuestionOption(id: 'pow_1_ups', label: 'UPS / Fuente de poder', icon: Icons.battery_charging_full_rounded, nextQuestionId: 'pow_2_energy'),
        QuestionOption(id: 'pow_1_acc', label: 'Control de acceso', icon: Icons.lock_rounded, nextQuestionId: 'pow_2_access'),
        QuestionOption(id: 'pow_1_other', label: 'Otro equipo', description: 'Describir con asistencia IA', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Preguntas CCTV (power) ──
    ...cctvPowerQuestions,
    // ── Preguntas Network (power) ──
    ...networkPowerQuestions,
    // ── Preguntas Energy/UPS (power) ──
    ...energyPowerQuestions,
    // ── Preguntas Access Control (power) ──
    ...accessPowerQuestions,
  ],

  // ═══════════════════════════════════════════════════
  // CONNECTIVITY ISSUE — "Sin conexión"
  // ═══════════════════════════════════════════════════
  'connectivity_issue': [
    // ── Paso 1: selección de dispositivo ──
    const DiagnosticQuestion(
      id: 'con_1',
      text: '¿Qué tipo de equipo no tiene conectividad?',
      subtitle: 'Selecciona la categoría del dispositivo',
      options: [
        QuestionOption(id: 'con_1_cctv', label: 'Cámara / NVR', icon: Icons.videocam_rounded, nextQuestionId: 'con_2_cctv'),
        QuestionOption(id: 'con_1_net', label: 'Red general (switch, router, PC)', icon: Icons.router_rounded, nextQuestionId: 'con_2_net'),
        QuestionOption(id: 'con_1_acc', label: 'Panel de acceso / biométrico', icon: Icons.lock_rounded, nextQuestionId: 'con_2_access'),
        QuestionOption(id: 'con_1_other', label: 'Otro', description: 'Solicitar asistencia IA', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Preguntas CCTV (connectivity) ──
    ...cctvConnectivityQuestions,
    // ── Preguntas Network (connectivity) ──
    ...networkConnectivityQuestions,
    // ── Preguntas Access (connectivity) ──
    ...accessConnectivityQuestions,
  ],

  // ═══════════════════════════════════════════════════
  // DISPLAY ISSUE — "Imagen borrosa / sin video"
  // ═══════════════════════════════════════════════════
  'display_issue': [
    ...cctvDisplayQuestions,
  ],

  // ═══════════════════════════════════════════════════
  // AUDIO ISSUE — "Ruido extraño / problema de sonido"
  // ═══════════════════════════════════════════════════
  'audio_issue': [
    // ── Paso 1: origen del sonido ──
    const DiagnosticQuestion(
      id: 'aud_1',
      text: '¿De qué equipo proviene el sonido o la alarma?',
      options: [
        QuestionOption(id: 'aud_1_nvr', label: 'DVR / NVR', icon: Icons.videocam_rounded, nextQuestionId: 'aud_2_nvr'),
        QuestionOption(id: 'aud_1_ups', label: 'UPS', icon: Icons.battery_charging_full_rounded, nextQuestionId: 'aud_2_ups'),
        QuestionOption(id: 'aud_1_other', label: 'Otro equipo', description: 'Solicitar asistencia IA', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Preguntas NVR/DVR (audio) ──
    ...cctvAudioQuestions,
    // ── Preguntas UPS (audio) ──
    ...energyAudioQuestions,
  ],

  // ═══════════════════════════════════════════════════
  // CAMERA ISSUE — "Cámara falla / no graba"
  // ═══════════════════════════════════════════════════
  'camera_issue': [
    ...cctvCameraQuestions,
  ],

  // ═══════════════════════════════════════════════════
  // OTHER ISSUE — "Otro problema"
  // ═══════════════════════════════════════════════════
  'other_issue': [
    ...sharedOtherQuestions,
    // Access-specific other issues
    ...accessOtherQuestions,
  ],
};
