import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PREGUNTAS COMPARTIDAS — Other Issue / Problema General
// Aplica a cualquier tipo de dispositivo
// ─────────────────────────────────────────────────────────────────────────────

const sharedOtherQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'oth_1', text: '¿Cuál describe mejor el problema?', options: [
    QuestionOption(id: 'oth_1_hw', label: 'Falla física del equipo (golpe, quemadura)', nextQuestionId: 'oth_2_hw'),
    QuestionOption(id: 'oth_1_fw', label: 'Error de firmware / software', nextQuestionId: 'oth_2_fw'),
    QuestionOption(id: 'oth_1_env', label: 'Temperatura, humedad o polvo', nextQuestionId: 'oth_2_env'),
    QuestionOption(id: 'oth_1_cred', label: 'Problema de acceso / credenciales', nextQuestionId: 'oth_2_cred'),
    QuestionOption(id: 'oth_1_remote', label: 'Acceso remoto no funciona', nextQuestionId: 'oth_2_remote'),
    QuestionOption(id: 'oth_1_other', label: 'Otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_2_hw', text: '¿Hay señales físicas visibles de daño?', options: [
    QuestionOption(id: 'oth_2hw_yes', label: 'Sí — quemaduras, condensadores abombados, olor', evidence: [EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.9), EvidenceWeight(hypothesisId: 'hardware_fault', weight: 0.8)]),
    QuestionOption(id: 'oth_2hw_no', label: 'No, sin daño visible', evidence: [EvidenceWeight(hypothesisId: 'hardware_fault', weight: 0.4), EvidenceWeight(hypothesisId: 'environmental_factor', weight: 0.3)]),
    QuestionOption(id: 'oth_2hw_other', label: 'No puedo inspeccionar', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_2_fw', text: '¿El problema comenzó después de una actualización o corte de luz?', options: [
    QuestionOption(id: 'oth_2fw_update', label: 'Sí, tras actualización de firmware', evidence: [EvidenceWeight(hypothesisId: 'software_firmware_config', weight: 0.9), EvidenceWeight(hypothesisId: 'firmware_bug', weight: 0.7)]),
    QuestionOption(id: 'oth_2fw_power', label: 'Sí, tras un corte de energía abrupto', evidence: [EvidenceWeight(hypothesisId: 'software_firmware_config', weight: 0.7), EvidenceWeight(hypothesisId: 'firmware_bug', weight: 0.5)]),
    QuestionOption(id: 'oth_2fw_no', label: 'No, de forma espontánea', evidence: [EvidenceWeight(hypothesisId: 'hardware_fault', weight: 0.5), EvidenceWeight(hypothesisId: 'software_firmware_config', weight: 0.4)]),
    QuestionOption(id: 'oth_2fw_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_2_env', text: '¿La temperatura del cuarto técnico supera los 27°C?', options: [
    QuestionOption(id: 'oth_2env_yes', label: 'Sí, hace mucho calor', evidence: [EvidenceWeight(hypothesisId: 'environmental_factor', weight: 0.9), EvidenceWeight(hypothesisId: 'equipment_overheating', weight: 0.7)]),
    QuestionOption(id: 'oth_2env_humid', label: 'No, pero hay mucha humedad o polvo', evidence: [EvidenceWeight(hypothesisId: 'environmental_factor', weight: 0.8)]),
    QuestionOption(id: 'oth_2env_no', label: 'No, condiciones normales', evidence: [EvidenceWeight(hypothesisId: 'hardware_fault', weight: 0.4)]),
    QuestionOption(id: 'oth_2env_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_2_cred', text: '¿Cuándo fue el último acceso exitoso al equipo?', options: [
    QuestionOption(id: 'oth_2cred_recent', label: 'Hace poco, alguien cambió la contraseña', evidence: [EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.9)]),
    QuestionOption(id: 'oth_2cred_long', label: 'Hace mucho tiempo o nunca se documentó', evidence: [EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.7)]),
    QuestionOption(id: 'oth_2cred_blocked', label: 'Bloqueado por intentos fallidos', evidence: [EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.8)]),
    QuestionOption(id: 'oth_2cred_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_2_remote', text: '¿El equipo funciona correctamente en la red local (LAN)?', options: [
    QuestionOption(id: 'oth_2rem_yes', label: 'Sí, local OK pero no funciona remoto', nextQuestionId: 'oth_3_remote_p2p'),
    QuestionOption(id: 'oth_2rem_no', label: 'No, tampoco funciona localmente', evidence: [EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.5), EvidenceWeight(hypothesisId: 'gateway_failure', weight: 0.5)]),
    QuestionOption(id: 'oth_2rem_other', label: 'No puedo verificar localmente', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_3_remote_p2p', text: '¿El servicio P2P/Cloud del equipo está habilitado y conectado?', options: [
    QuestionOption(id: 'oth_3rp_yes', label: 'Sí, P2P activo pero falla app', evidence: [EvidenceWeight(hypothesisId: 'remote_access_failure', weight: 0.6), EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.4)]),
    QuestionOption(id: 'oth_3rp_no', label: 'No, P2P deshabilitado o error', evidence: [EvidenceWeight(hypothesisId: 'remote_access_failure', weight: 0.8)]),
    QuestionOption(id: 'oth_3rp_port', label: 'Usa Port Forwarding, no P2P', nextQuestionId: 'oth_4_port_fwd'),
    QuestionOption(id: 'oth_3rp_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'oth_4_port_fwd', text: '¿El ISP tiene CG-NAT o IP pública dedicada?', options: [
    QuestionOption(id: 'oth_4pf_cgnat', label: 'CG-NAT / IP compartida', evidence: [EvidenceWeight(hypothesisId: 'remote_access_failure', weight: 0.9)]),
    QuestionOption(id: 'oth_4pf_static', label: 'IP pública dedicada', evidence: [EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.7), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5)]),
    QuestionOption(id: 'oth_4pf_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
];
