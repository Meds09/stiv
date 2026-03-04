import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PREGUNTAS DE ENERGÍA / UPS / FUENTES DE PODER
// Cubre síntomas: power (UPS, breakers, fuentes), audio (UPS)
// ─────────────────────────────────────────────────────────────────────────────

// ── Power: Energy / UPS ───────────────────────────────────────────────────────
const energyPowerQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'pow_2_energy', text: '¿Cuál es el tipo de problema de energía?', options: [
    QuestionOption(id: 'pow_2e_ups', label: 'UPS no funciona o no respalda', icon: Icons.battery_charging_full_rounded, nextQuestionId: 'pow_3_ups'),
    QuestionOption(id: 'pow_2e_breaker', label: 'Breaker/disyuntor disparado', icon: Icons.electrical_services_rounded, nextQuestionId: 'pow_3_breaker'),
    QuestionOption(id: 'pow_2e_pdu', label: 'Regleta/PDU sin energía', nextQuestionId: 'pow_3_pdu'),
    QuestionOption(id: 'pow_2e_other', label: 'Otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_3_ups', text: '¿Cuál es el comportamiento del UPS?', options: [
    QuestionOption(id: 'pow_3u_nopower', label: 'No enciende nada', nextQuestionId: 'pow_4_ups_power'),
    QuestionOption(id: 'pow_3u_nobackup', label: 'Enciende pero no respalda al cortar luz', nextQuestionId: 'pow_4_ups_battery'),
    QuestionOption(id: 'pow_3u_alarm', label: 'Pita/alarma pero mantiene energía', nextQuestionId: 'pow_4_ups_alarm'),
    QuestionOption(id: 'pow_3u_bypass', label: 'Modo Bypass activo / LED Fault encendido', nextQuestionId: 'pow_4_ups_bypass'),
    QuestionOption(id: 'pow_3u_other', label: 'Otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_3_breaker', text: '¿El breaker del tablero está en posición intermedia (ni ON ni OFF)?', options: [
    QuestionOption(id: 'pow_3b_yes', label: 'Sí, está a medio camino', evidence: [EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.9)]),
    QuestionOption(id: 'pow_3b_no', label: 'No, está en OFF — lo apagaron manualmente', evidence: [EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.3)]),
    QuestionOption(id: 'pow_3b_retrp', label: 'Se dispara repetidamente al subirlo', nextQuestionId: 'pow_4_breaker_fault'),
    QuestionOption(id: 'pow_3b_other', label: 'No puedo acceder al tablero', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_3_pdu', text: '¿La regleta tiene botón de RESET o interruptor con LED?', options: [
    QuestionOption(id: 'pow_3pd_yes', label: 'Sí, el LED está apagado', nextQuestionId: 'pow_4_pdu_reset'),
    QuestionOption(id: 'pow_3pd_no', label: 'No tiene botón de reset', evidence: [EvidenceWeight(hypothesisId: 'power_strip_trip', weight: 0.7)]),
    QuestionOption(id: 'pow_3pd_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_4_ups_power', text: '¿El tomacorriente donde se conecta el UPS funciona?', options: [
    QuestionOption(id: 'pow_4up_yes', label: 'Sí, el tomacorriente tiene tensión', evidence: [EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'ups_inverter_fault', weight: 0.5)]),
    QuestionOption(id: 'pow_4up_no', label: 'No, el tomacorriente está muerto', evidence: [EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.8), EvidenceWeight(hypothesisId: 'power_strip_trip', weight: 0.6)]),
    QuestionOption(id: 'pow_4up_other', label: 'No puedo medir', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_4_ups_battery', text: '¿Cuánto tiempo tiene la batería del UPS instalada?', options: [
    QuestionOption(id: 'pow_4ub_old', label: 'Más de 2 años', nextQuestionId: 'pow_5_ups_replace'),
    QuestionOption(id: 'pow_4ub_new', label: 'Menos de 1 año', nextQuestionId: 'pow_5_ups_inv'),
    QuestionOption(id: 'pow_4ub_other', label: 'No lo sé', icon: Icons.help_outline_rounded, evidence: [EvidenceWeight(hypothesisId: 'ups_battery_failure', weight: 0.5)]),
  ]),
  DiagnosticQuestion(id: 'pow_4_ups_alarm', text: '¿Cuál es el patrón del sonido?', options: [
    QuestionOption(id: 'pow_4ua_batt', label: 'Pitido cada 30s — batería baja', evidence: [EvidenceWeight(hypothesisId: 'ups_battery_noise', weight: 0.9)]),
    QuestionOption(id: 'pow_4ua_over', label: 'Alarma continua — sobrecarga', evidence: [EvidenceWeight(hypothesisId: 'ups_overload', weight: 0.9)]),
    QuestionOption(id: 'pow_4ua_other', label: 'Patrón desconocido', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_4_ups_bypass', text: '¿El panel del UPS muestra "Bypass On" o "Fault"?', options: [
    QuestionOption(id: 'pow_4by_yes', label: 'Sí, indica Bypass o Fault', evidence: [EvidenceWeight(hypothesisId: 'ups_bypass_mode', weight: 0.9)]),
    QuestionOption(id: 'pow_4by_no', label: 'No muestra error, pero se oye click rápido', evidence: [EvidenceWeight(hypothesisId: 'ups_inverter_fault', weight: 0.7)]),
    QuestionOption(id: 'pow_4by_other', label: 'No tengo acceso al panel', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_4_breaker_fault', text: '¿Desconectaste todos los equipos del circuito antes de subir el breaker?', options: [
    QuestionOption(id: 'pow_4bf_yes', label: 'Sí, aun así se dispara', evidence: [EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.8)]),
    QuestionOption(id: 'pow_4bf_no', label: 'No, los equipos seguían conectados', evidence: [EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.9)]),
    QuestionOption(id: 'pow_4bf_other', label: 'No he podido intentarlo', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_4_pdu_reset', text: '¿Intentaste presionar el botón de RESET de la regleta?', options: [
    QuestionOption(id: 'pow_4pr_yes', label: 'Sí, volvió a funcionar', evidence: [EvidenceWeight(hypothesisId: 'power_strip_trip', weight: 0.95)]),
    QuestionOption(id: 'pow_4pr_no', label: 'No funciona aunque lo reseteo', evidence: [EvidenceWeight(hypothesisId: 'power_strip_trip', weight: 0.6), EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.4)]),
    QuestionOption(id: 'pow_4pr_other', label: 'No puedo presionarlo', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_5_ups_replace', text: '¿El panel del UPS muestra indicador "Replace Battery"?', options: [
    QuestionOption(id: 'pow_5ur_yes', label: 'Sí, está encendido', evidence: [EvidenceWeight(hypothesisId: 'ups_battery_failure', weight: 0.95)]),
    QuestionOption(id: 'pow_5ur_no', label: 'No muestra ese indicador, pero la batería es vieja', evidence: [EvidenceWeight(hypothesisId: 'ups_battery_failure', weight: 0.7)]),
    QuestionOption(id: 'pow_5ur_other', label: 'No puedo ver el panel', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_5_ups_inv', text: '¿Al simular un corte de energía, el UPS continúa suministrando?', options: [
    QuestionOption(id: 'pow_5ui_yes', label: 'Sí, corre en batería normalmente', evidence: [EvidenceWeight(hypothesisId: 'ups_battery_failure', weight: -0.5), EvidenceWeight(hypothesisId: 'wrong_voltage_region', weight: 0.4)]),
    QuestionOption(id: 'pow_5ui_no', label: 'No, los equipos se apagan al cortar', evidence: [EvidenceWeight(hypothesisId: 'ups_inverter_fault', weight: 0.85)]),
    QuestionOption(id: 'pow_5ui_other', label: 'No puedo hacer la prueba', icon: Icons.help_outline_rounded),
  ]),
];

// ── Audio: UPS ────────────────────────────────────────────────────────────────
const energyAudioQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'aud_2_ups', text: '¿Cuál es el tipo de sonido del UPS?', subtitle: 'Consulta el manual del UPS para el código de pitidos', options: [
    QuestionOption(id: 'aud_2u_batt', label: 'Pitidos intermitentes (cada 30-60s)', nextQuestionId: 'aud_3_ups_batt', evidence: [EvidenceWeight(hypothesisId: 'ups_battery_noise', weight: 0.7)]),
    QuestionOption(id: 'aud_2u_over', label: 'Alarma continua sin parar', nextQuestionId: 'aud_3_ups_over', evidence: [EvidenceWeight(hypothesisId: 'ups_overload', weight: 0.6)]),
    QuestionOption(id: 'aud_2u_click', label: 'Click seco rápido tipo relé', nextQuestionId: 'aud_3_ups_bypass', evidence: [EvidenceWeight(hypothesisId: 'ups_bypass_mode', weight: 0.7), EvidenceWeight(hypothesisId: 'ups_inverter_fault', weight: 0.4)]),
    QuestionOption(id: 'aud_2u_other', label: 'Otro ruido', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'aud_3_ups_batt', text: '¿El LED de "Replace Battery" está activo?', options: [
    QuestionOption(id: 'aud_3ub_yes', label: 'Sí, LED encendido', evidence: [EvidenceWeight(hypothesisId: 'ups_battery_noise', weight: 0.9), EvidenceWeight(hypothesisId: 'ups_battery_failure', weight: 0.8)]),
    QuestionOption(id: 'aud_3ub_no', label: 'No, LED apagado', evidence: [EvidenceWeight(hypothesisId: 'ups_battery_noise', weight: 0.5)]),
    QuestionOption(id: 'aud_3ub_other', label: 'No puedo ver el panel', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'aud_3_ups_over', text: '¿Al desconectar equipos del UPS, la alarma se detiene?', options: [
    QuestionOption(id: 'aud_3uo_yes', label: 'Sí, desconectando equipo la alarma para', evidence: [EvidenceWeight(hypothesisId: 'ups_overload', weight: 0.95)]),
    QuestionOption(id: 'aud_3uo_no', label: 'No, la alarma continúa aunque desconecte todo', evidence: [EvidenceWeight(hypothesisId: 'ups_battery_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'ups_bypass_mode', weight: 0.5)]),
    QuestionOption(id: 'aud_3uo_other', label: 'No he intentado desconectar', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'aud_3_ups_bypass', text: '¿El panel del UPS muestra "Bypass On" o "Fault"?', options: [
    QuestionOption(id: 'aud_3uby_yes', label: 'Sí, indica Bypass o Fault', evidence: [EvidenceWeight(hypothesisId: 'ups_bypass_mode', weight: 0.9)]),
    QuestionOption(id: 'aud_3uby_no', label: 'No muestra error, solo hace click', evidence: [EvidenceWeight(hypothesisId: 'ups_inverter_fault', weight: 0.7)]),
    QuestionOption(id: 'aud_3uby_other', label: 'No tengo acceso al panel', icon: Icons.help_outline_rounded),
  ]),
];
