import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PREGUNTAS DE CONTROL DE ACCESO
// Cubre síntomas: power (panel/batería), connectivity, other (cerraduras,
//                 biométricos, RS-485/Wiegand)
// ─────────────────────────────────────────────────────────────────────────────

// ── Power: Access Control ────────────────────────────────────────────────────
const accessPowerQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'pow_2_access', text: '¿El panel de control de acceso tiene energía?', options: [
    QuestionOption(id: 'pow_2a_no', label: 'No, ningún LED encendido', nextQuestionId: 'pow_3_access_main'),
    QuestionOption(id: 'pow_2a_batt', label: 'Reinicia constantemente / LED inestable', nextQuestionId: 'pow_3_access_battery'),
    QuestionOption(id: 'pow_2a_yes', label: 'Sí, Panel OK pero la cerradura no responde', nextQuestionId: 'pow_3_access_lock'),
    QuestionOption(id: 'pow_2a_other', label: 'Otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_3_access_main', text: '¿El transformador o fuente del panel tiene 12V en los bornes?', options: [
    QuestionOption(id: 'pow_3am_yes', label: 'Sí, hay 12V en la fuente', evidence: [EvidenceWeight(hypothesisId: 'access_battery_backup', weight: 0.7), EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5)]),
    QuestionOption(id: 'pow_3am_no', label: 'No, no hay voltaje en la fuente', evidence: [EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.8), EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.4)]),
    QuestionOption(id: 'pow_3am_other', label: 'No puedo medir', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_3_access_battery', text: '¿La batería de respaldo del panel está hinchada o muy caliente al tacto?', options: [
    QuestionOption(id: 'pow_3ab_yes', label: 'Sí, está abombada o caliente', evidence: [EvidenceWeight(hypothesisId: 'access_battery_backup', weight: 0.95)]),
    QuestionOption(id: 'pow_3ab_no', label: 'No, parece normal', nextQuestionId: 'pow_4_access_bat_test'),
    QuestionOption(id: 'pow_3ab_other', label: 'No puedo acceder al panel', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_3_access_lock', text: '¿La cerradura recibe el voltaje correcto en sus terminales?', subtitle: 'Mide con multímetro en los terminales de la cerradura', options: [
    QuestionOption(id: 'pow_3al_yes', label: 'Sí, tiene 12V al activar', evidence: [EvidenceWeight(hypothesisId: 'access_strike_jammed', weight: 0.8)]),
    QuestionOption(id: 'pow_3al_low', label: 'Voltaje menor al esperado (<9V)', evidence: [EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'access_battery_backup', weight: 0.4)]),
    QuestionOption(id: 'pow_3al_no', label: 'No hay voltaje en la cerradura', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.6), EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5)]),
    QuestionOption(id: 'pow_3al_other', label: 'No puedo medir', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_4_access_bat_test', text: '¿Al desconectar la batería, el panel se estabiliza?', options: [
    QuestionOption(id: 'pow_4abt_yes', label: 'Sí, al desconectar la batería el panel funciona', evidence: [EvidenceWeight(hypothesisId: 'access_battery_backup', weight: 0.9)]),
    QuestionOption(id: 'pow_4abt_no', label: 'No, sigue inestable sin la batería', evidence: [EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5)]),
    QuestionOption(id: 'pow_4abt_other', label: 'No puedo realizar la prueba', icon: Icons.help_outline_rounded),
  ]),
];

// ── Connectivity: Access ─────────────────────────────────────────────────────
const accessConnectivityQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'con_2_access', text: '¿El panel de acceso tiene conectividad de red?', options: [
    QuestionOption(id: 'con_2ac_yes', label: 'Sí, pero el software no lo detecta', nextQuestionId: 'con_3_access_soft'),
    QuestionOption(id: 'con_2ac_no', label: 'No, sin red', nextQuestionId: 'con_3_access_net'),
    QuestionOption(id: 'con_2ac_other', label: 'No tengo información', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_3_access_soft', text: '¿Probaste con la dirección IP correcta en el software?', options: [
    QuestionOption(id: 'con_3as_yes', label: 'Sí, IP correcta pero falla', evidence: [EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.6), EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.5)]),
    QuestionOption(id: 'con_3as_no', label: 'No, habría que verificar la IP', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.8)]),
    QuestionOption(id: 'con_3as_other', label: 'No tengo acceso al software', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_3_access_net', text: '¿El cable UTP del panel tiene continuidad?', options: [
    QuestionOption(id: 'con_3an_yes', label: 'Sí, cable OK', nextQuestionId: 'con_4_access_port'),
    QuestionOption(id: 'con_3an_no', label: 'No, cable dañado', evidence: [EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.9)]),
    QuestionOption(id: 'con_3an_other', label: 'No tengo tester', evidence: [EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.5)]),
  ]),
  DiagnosticQuestion(id: 'con_4_access_port', text: '¿El LED del puerto switch que conecta el panel está activo?', options: [
    QuestionOption(id: 'con_4ap_yes', label: 'Sí, LED activo', nextQuestionId: 'con_5_access_ip'),
    QuestionOption(id: 'con_4ap_no', label: 'No, LED apagado', evidence: [EvidenceWeight(hypothesisId: 'switch_port_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'dirty_ethernet_port', weight: 0.5)]),
    QuestionOption(id: 'con_4ap_other', label: 'No puedo ver el switch', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_5_access_ip', text: '¿El panel tiene IP fija o por DHCP?', options: [
    QuestionOption(id: 'con_5ai_static', label: 'IP fija configurada', evidence: [EvidenceWeight(hypothesisId: 'ip_conflict', weight: 0.6), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5)]),
    QuestionOption(id: 'con_5ai_dhcp', label: 'Por DHCP', evidence: [EvidenceWeight(hypothesisId: 'dhcp_pool_exhausted', weight: 0.7), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.3)]),
    QuestionOption(id: 'con_5ai_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
];

// ── Other: Access Control ─────────────────────────────────────────────────────
const accessOtherQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'oth_2_access', text: '¿Cuál es el problema específico?', options: [
    QuestionOption(id: 'oth_2a_lock', label: 'Cerradura no abre aunque el panel autoriza', nextQuestionId: 'oth_3_lock'),
    QuestionOption(id: 'oth_2a_reader', label: 'Lector biométrico/tarjeta no reconoce usuarios', nextQuestionId: 'oth_3_reader'),
    QuestionOption(id: 'oth_2a_rs485', label: 'Lector secundario RS-485/Wiegand no funciona', nextQuestionId: 'oth_3_rs485'),
    QuestionOption(id: 'oth_2a_cred', label: 'No puedo acceder al panel (contraseña)', nextQuestionId: 'oth_3_cred'),
    QuestionOption(id: 'oth_2a_other', label: 'Otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_3_lock', text: '¿Se escucha el "click" del relé al pasar tarjeta/huella?', options: [
    QuestionOption(id: 'oth_3l_yes', label: 'Sí, se oye el click pero la puerta no abre', nextQuestionId: 'oth_4_lock_mechanical'),
    QuestionOption(id: 'oth_3l_no', label: 'No se oye ningún click', nextQuestionId: 'oth_4_lock_relay'),
    QuestionOption(id: 'oth_3l_other', label: 'No puedo estar presente en la puerta', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_3_reader', text: '¿Cuándo comenzó el problema con el lector?', options: [
    QuestionOption(id: 'oth_3r_recent', label: 'De repente (sin cambios de configuración)', nextQuestionId: 'oth_4_reader_clean'),
    QuestionOption(id: 'oth_3r_never', label: 'Nunca ha funcionado bien tras instalación', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.7), EvidenceWeight(hypothesisId: 'rs485_polarity_reversed', weight: 0.4)]),
    QuestionOption(id: 'oth_3r_install', label: 'Desde que cambiaron a nuevos usuarios', evidence: [EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.8)]),
    QuestionOption(id: 'oth_3r_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_3_rs485', text: '¿Los cables D+ y D- del RS-485 están conectados correctamente?', options: [
    QuestionOption(id: 'oth_3r4_yes', label: 'Sí, positivo a positivo, negativo a negativo', evidence: [EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5)]),
    QuestionOption(id: 'oth_3r4_no', label: 'No, podrían estar cruzados o sin resistencia', evidence: [EvidenceWeight(hypothesisId: 'rs485_polarity_reversed', weight: 0.9)]),
    QuestionOption(id: 'oth_3r4_other', label: 'No puedo verificar el cableado', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_3_cred', text: '¿Tienes acceso a la documentación de instalación con las credenciales?', options: [
    QuestionOption(id: 'oth_3c_yes', label: 'Sí, tengo las credenciales documentadas', nextQuestionId: 'oth_4_cred_block'),
    QuestionOption(id: 'oth_3c_no', label: 'No, la contraseña se perdió', evidence: [EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.9)]),
    QuestionOption(id: 'oth_3c_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_4_lock_mechanical', text: '¿La puerta tiene presión excesiva o desalineación en el marco?', options: [
    QuestionOption(id: 'oth_4lm_yes', label: 'Sí, la puerta está apretada o mal alineada', evidence: [EvidenceWeight(hypothesisId: 'access_strike_jammed', weight: 0.9)]),
    QuestionOption(id: 'oth_4lm_no', label: 'No, sin problema mecánico visible', evidence: [EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.6), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.4)]),
    QuestionOption(id: 'oth_4lm_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_4_lock_relay', text: '¿El relé del panel manda señal al activar credencial? (LED de salida activo)', options: [
    QuestionOption(id: 'oth_4lr_yes', label: 'Sí, LED de salida parpadea', evidence: [EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'access_strike_jammed', weight: 0.5)]),
    QuestionOption(id: 'oth_4lr_no', label: 'No, LED de salida no activa', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.7), EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5)]),
    QuestionOption(id: 'oth_4lr_other', label: 'No puedo ver el panel', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_4_reader_clean', text: '¿Limpiaste el sensor del lector biométrico/NFC?', options: [
    QuestionOption(id: 'oth_4rc_yes', label: 'Sí, sigue fallando', evidence: [EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.6), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5)]),
    QuestionOption(id: 'oth_4rc_no', label: 'No lo he limpiado', evidence: [EvidenceWeight(hypothesisId: 'reader_sensor_dirty', weight: 0.9)]),
    QuestionOption(id: 'oth_4rc_other', label: 'No tengo acceso al lector', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_4_cred_block', text: '¿El panel muestra un bloqueo por intentos fallidos?', options: [
    QuestionOption(id: 'oth_4cb_yes', label: 'Sí, indica bloqueo temporal', evidence: [EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.8)]),
    QuestionOption(id: 'oth_4cb_no', label: 'No, pero las credenciales no funcionan', evidence: [EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.6), EvidenceWeight(hypothesisId: 'firmware_bug', weight: 0.3)]),
    QuestionOption(id: 'oth_4cb_other', label: 'No puedo ver el panel', icon: Icons.help_outline_rounded),
  ]),
];
