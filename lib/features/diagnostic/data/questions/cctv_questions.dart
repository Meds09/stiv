import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PREGUNTAS DE CCTV / DVR / NVR
// Cubre síntomas: power, connectivity, display, audio (NVR), camera
// ─────────────────────────────────────────────────────────────────────────────

// ── Power ────────────────────────────────────────────────────────────────────
const cctvPowerQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(
    id: 'pow_2_cctv',
    text: '¿El LED indicador de la cámara se enciende?',
    subtitle: 'Revisa los LEDs frontales o traseros del equipo',
    options: [
      QuestionOption(id: 'pow_2c_yes', label: 'Sí, el LED se enciende', nextQuestionId: 'pow_3_cctv_led_on', evidence: [EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.3)]),
      QuestionOption(id: 'pow_2c_no', label: 'No, ningún LED', nextQuestionId: 'pow_3_cctv_led_off', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.4), EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.4)]),
      QuestionOption(id: 'pow_2c_blink', label: 'Parpadea intermitentemente', nextQuestionId: 'pow_3_cctv_blink', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.5), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.3)]),
      QuestionOption(id: 'pow_2c_other', label: 'No estoy seguro', description: 'Solicitar asistencia IA', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'pow_3_cctv_led_on',
    text: '¿El equipo transmite imagen al monitor/NVR?',
    options: [
      QuestionOption(id: 'pow_3co_yes', label: 'Sí, pero se congela', nextQuestionId: 'pow_4_cctv_freeze', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.4), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.3)]),
      QuestionOption(id: 'pow_3co_no', label: 'No hay imagen', nextQuestionId: 'pow_4_cctv_no_img', evidence: [EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.5), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.3)]),
      QuestionOption(id: 'pow_3co_other', label: 'Otro comportamiento', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'pow_3_cctv_led_off',
    text: '¿Cómo se alimenta el equipo?',
    options: [
      QuestionOption(id: 'pow_3cf_poe', label: 'PoE (cable de red)', nextQuestionId: 'pow_4_cctv_poe', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.6)]),
      QuestionOption(id: 'pow_3cf_adapter', label: 'Adaptador DC 12V/24V', nextQuestionId: 'pow_4_cctv_adapter', evidence: [EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.6)]),
      QuestionOption(id: 'pow_3cf_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'pow_3_cctv_blink',
    text: '¿Cada cuánto se reinicia?',
    options: [
      QuestionOption(id: 'pow_3cb_freq', label: 'Cada pocos segundos', nextQuestionId: 'pow_4_cctv_poe', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.3)]),
      QuestionOption(id: 'pow_3cb_random', label: 'De forma aleatoria', nextQuestionId: 'pow_4_cctv_adapter', evidence: [EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.5), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.2)]),
      QuestionOption(id: 'pow_3cb_other', label: 'Otro patrón', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'pow_4_cctv_poe',
    text: '¿El puerto PoE del switch muestra actividad?',
    subtitle: 'Revisa los LEDs del puerto donde está conectada la cámara',
    options: [
      QuestionOption(id: 'pow_4cp_yes', label: 'Sí, LED activo', nextQuestionId: 'pow_5_cctv_cable', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: -0.2), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.4)]),
      QuestionOption(id: 'pow_4cp_no', label: 'No, LED apagado', nextQuestionId: 'pow_5_cctv_switch', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.7)]),
      QuestionOption(id: 'pow_4cp_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'pow_4_cctv_adapter',
    text: '¿El adaptador tiene LED o indicador de encendido?',
    options: [
      QuestionOption(id: 'pow_4ca_yes', label: 'Sí, el adaptador enciende', nextQuestionId: 'pow_5_cctv_cable', evidence: [EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: -0.2), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.4)]),
      QuestionOption(id: 'pow_4ca_no', label: 'No, el adaptador está muerto', evidence: [EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.9)]),
      QuestionOption(id: 'pow_4ca_other', label: 'No estoy seguro', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'pow_4_cctv_freeze',
    text: '¿El equipo se reinicia solo o se queda congelado?',
    options: [
      QuestionOption(id: 'pow_4cfr_restart', label: 'Se reinicia periódicamente', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.6), EvidenceWeight(hypothesisId: 'overload', weight: 0.3)]),
      QuestionOption(id: 'pow_4cfr_frozen', label: 'Se queda congelado', evidence: [EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.6), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.2)]),
      QuestionOption(id: 'pow_4cfr_other', label: 'Otro comportamiento', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'pow_4_cctv_no_img',
    text: '¿Probaste con otro cable de video o puerto?',
    options: [
      QuestionOption(id: 'pow_4ci_yes', label: 'Sí, mismo resultado', evidence: [EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'cable_failure', weight: -0.2)]),
      QuestionOption(id: 'pow_4ci_no', label: 'No lo he probado', evidence: [EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.3)]),
      QuestionOption(id: 'pow_4ci_other', label: 'No aplica', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'pow_5_cctv_cable',
    text: '¿Probaste con otro cable de red / alimentación?',
    options: [
      QuestionOption(id: 'pow_5cc_yes', label: 'Sí, con otro cable funciona', evidence: [EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.9), EvidenceWeight(hypothesisId: 'poe_failure', weight: -0.2)]),
      QuestionOption(id: 'pow_5cc_no', label: 'Sí, mismo resultado con otro cable', evidence: [EvidenceWeight(hypothesisId: 'cable_failure', weight: -0.3), EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.5), EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.4)]),
      QuestionOption(id: 'pow_5cc_skip', label: 'No tengo otro cable disponible', evidence: [EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.5)]),
      QuestionOption(id: 'pow_5cc_other', label: 'Necesito ayuda', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'pow_5_cctv_switch',
    text: '¿El switch/inyector PoE está encendido correctamente?',
    options: [
      QuestionOption(id: 'pow_5cs_yes', label: 'Sí, otros equipos funcionan', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.5), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.3)]),
      QuestionOption(id: 'pow_5cs_no', label: 'No, el switch también falló', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.8), EvidenceWeight(hypothesisId: 'overload', weight: 0.3)]),
      QuestionOption(id: 'pow_5cs_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
    ],
  ),
];

// ── Connectivity ──────────────────────────────────────────────────────────────
const cctvConnectivityQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(
    id: 'con_2_cctv',
    text: '¿La cámara responde a ping desde la red?',
    options: [
      QuestionOption(id: 'con_2c_yes', label: 'Sí responde a ping', nextQuestionId: 'con_3_cctv_ping_ok'),
      QuestionOption(id: 'con_2c_no', label: 'No responde a ping', nextQuestionId: 'con_3_cctv_ping_fail'),
      QuestionOption(id: 'con_2c_dk', label: 'No sé hacer ping', nextQuestionId: 'con_3_cctv_check'),
      QuestionOption(id: 'con_2c_other', label: 'Otro', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'con_3_cctv_ping_ok',
    text: '¿Puedes acceder a la interfaz web de la cámara?',
    options: [
      QuestionOption(id: 'con_3co_yes', label: 'Sí, pero sin video', nextQuestionId: 'con_4_cctv_novid'),
      QuestionOption(id: 'con_3co_no', label: 'No carga la página', nextQuestionId: 'con_4_cctv_port'),
      QuestionOption(id: 'con_3co_other', label: 'No lo he intentado', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'con_3_cctv_ping_fail',
    text: '¿El LED del puerto del switch está activo?',
    options: [
      QuestionOption(id: 'con_3cf_yes', label: 'Sí, LED activo', nextQuestionId: 'con_4_cctv_ip'),
      QuestionOption(id: 'con_3cf_no', label: 'No, LED apagado', nextQuestionId: 'con_4_cctv_cable'),
      QuestionOption(id: 'con_3cf_other', label: 'No puedo ver', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'con_3_cctv_check',
    text: '¿El LED de red en la cámara parpadea?',
    options: [
      QuestionOption(id: 'con_3cc_yes', label: 'Sí, parpadea', nextQuestionId: 'con_4_cctv_ip'),
      QuestionOption(id: 'con_3cc_no', label: 'No parpadea', nextQuestionId: 'con_4_cctv_cable'),
      QuestionOption(id: 'con_3cc_other', label: 'No tiene LED de red', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'con_4_cctv_novid',
    text: '¿El stream de video muestra error o simplemente no carga?',
    options: [
      QuestionOption(id: 'con_4cn_err', label: 'Muestra un error', evidence: [EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.5), EvidenceWeight(hypothesisId: 'firmware_bug', weight: 0.3)]),
      QuestionOption(id: 'con_4cn_load', label: 'Se queda cargando infinitamente', evidence: [EvidenceWeight(hypothesisId: 'bandwidth_issue', weight: 0.7), EvidenceWeight(hypothesisId: 'mac_filtering_locked', weight: 0.2)]),
      QuestionOption(id: 'con_4cn_other', label: 'Otro', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'con_4_cctv_port',
    text: '¿Verificaste que el puerto HTTP de la cámara es correcto?',
    options: [
      QuestionOption(id: 'con_4cp_yes', label: 'Sí, es el puerto por defecto', evidence: [EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.6), EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.3)]),
      QuestionOption(id: 'con_4cp_changed', label: 'Alguien cambió el puerto', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.8)]),
      QuestionOption(id: 'con_4cp_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'con_4_cctv_ip',
    text: '¿La IP de la cámara está en el mismo segmento de red?',
    options: [
      QuestionOption(id: 'con_4ci_yes', label: 'Sí, mismo segmento', evidence: [EvidenceWeight(hypothesisId: 'mac_filtering_locked', weight: 0.5), EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.4)]),
      QuestionOption(id: 'con_4ci_no', label: 'Apuntó una IP APIPA u otro segmento', evidence: [EvidenceWeight(hypothesisId: 'dhcp_pool_exhausted', weight: 0.8), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5)]),
      QuestionOption(id: 'con_4ci_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'con_4_cctv_cable',
    text: '¿Probaste cambiando el cable o el puerto del switch?',
    options: [
      QuestionOption(id: 'con_4cc_yes', label: 'Sí, pero el LED sigue apagado', evidence: [EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.6), EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.5)]),
      QuestionOption(id: 'con_4cc_no', label: 'Aún no lo he probado', evidence: [EvidenceWeight(hypothesisId: 'dirty_ethernet_port', weight: 0.7), EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.5)]),
      QuestionOption(id: 'con_4cc_other', label: 'No tengo material', icon: Icons.help_outline_rounded),
    ],
  ),
];
