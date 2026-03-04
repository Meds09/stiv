import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PREGUNTAS DE CCTV — Display, Audio NVR, Camera issues
// ─────────────────────────────────────────────────────────────────────────────

// ── Display ───────────────────────────────────────────────────────────────────
const cctvDisplayQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'dsp_1', text: '¿Dónde se presenta el problema de imagen?', options: [
    QuestionOption(id: 'dsp_1_cam', label: 'En una cámara específica', icon: Icons.videocam_rounded, nextQuestionId: 'dsp_2_cam'),
    QuestionOption(id: 'dsp_1_nvr', label: 'En el monitor/NVR', icon: Icons.monitor_rounded, nextQuestionId: 'dsp_2_nvr'),
    QuestionOption(id: 'dsp_1_all', label: 'En todas las cámaras', nextQuestionId: 'dsp_2_all'),
    QuestionOption(id: 'dsp_1_other', label: 'Otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_2_cam', text: '¿Qué tipo de problema tiene la imagen?', options: [
    QuestionOption(id: 'dsp_2c_blur', label: 'Borrosa / desenfocada', nextQuestionId: 'dsp_3_blur'),
    QuestionOption(id: 'dsp_2c_lines', label: 'Líneas o rayas', nextQuestionId: 'dsp_3_lines'),
    QuestionOption(id: 'dsp_2c_dark', label: 'Imagen muy oscura', nextQuestionId: 'dsp_3_dark'),
    QuestionOption(id: 'dsp_2c_other', label: 'Otro defecto', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_2_nvr', text: '¿El NVR muestra todas las cámaras con problemas?', options: [
    QuestionOption(id: 'dsp_2n_all', label: 'Sí, todas tienen mal video', nextQuestionId: 'dsp_3_nvr_output'),
    QuestionOption(id: 'dsp_2n_some', label: 'Solo algunas cámaras', nextQuestionId: 'dsp_3_blur'),
    QuestionOption(id: 'dsp_2n_other', label: 'Otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_2_all', text: '¿Cuándo comenzó el problema?', options: [
    QuestionOption(id: 'dsp_2a_sudden', label: 'De repente', nextQuestionId: 'dsp_3_nvr_output'),
    QuestionOption(id: 'dsp_2a_gradual', label: 'Gradualmente', nextQuestionId: 'dsp_3_blur'),
    QuestionOption(id: 'dsp_2a_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_3_blur', text: '¿La cámara tiene lente con enfoque manual?', options: [
    QuestionOption(id: 'dsp_3b_yes', label: 'Sí, tiene anillo de enfoque', nextQuestionId: 'dsp_4_focus'),
    QuestionOption(id: 'dsp_3b_no', label: 'No, es foco fijo', nextQuestionId: 'dsp_4_clean'),
    QuestionOption(id: 'dsp_3b_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_3_lines', text: '¿Las líneas son horizontales o verticales?', options: [
    QuestionOption(id: 'dsp_3l_h', label: 'Horizontales y parpadean', evidence: [EvidenceWeight(hypothesisId: 'signal_degradation', weight: 0.8), EvidenceWeight(hypothesisId: 'ground_loop_audio', weight: 0.5)]),
    QuestionOption(id: 'dsp_3l_v', label: 'Líneas rectas fijas de color (morado/verde)', evidence: [EvidenceWeight(hypothesisId: 'physical_damage', weight: 0.7), EvidenceWeight(hypothesisId: 'sensor_burn_ir_reflection', weight: 0.8)]),
    QuestionOption(id: 'dsp_3l_other', label: 'Ambas / Otro patrón caótico', evidence: [EvidenceWeight(hypothesisId: 'physical_damage', weight: 0.5), EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.4)], icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_3_dark', text: '¿El problema ocurre de noche o también de día?', options: [
    QuestionOption(id: 'dsp_3d_night', label: 'Solo de noche', nextQuestionId: 'dsp_4_ir'),
    QuestionOption(id: 'dsp_3d_always', label: 'Todo el tiempo', nextQuestionId: 'dsp_4_clean'),
    QuestionOption(id: 'dsp_3d_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_3_nvr_output', text: '¿Probaste con otro cable HDMI/VGA hacia el monitor?', options: [
    QuestionOption(id: 'dsp_3no_yes', label: 'Sí, mismo resultado', evidence: [EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.8)]),
    QuestionOption(id: 'dsp_3no_no', label: 'No lo he probado', evidence: [EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.6)]),
    QuestionOption(id: 'dsp_3no_other', label: 'No tengo otro cable', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_4_focus', text: '¿Ajustaste el anillo de enfoque y sigue borrosa?', options: [
    QuestionOption(id: 'dsp_4f_yes', label: 'Sí, no mejora o gira en falso', evidence: [EvidenceWeight(hypothesisId: 'camera_mount_loose', weight: 0.6), EvidenceWeight(hypothesisId: 'physical_damage', weight: 0.5)]),
    QuestionOption(id: 'dsp_4f_no', label: 'No lo he ajustado', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.7)]),
    QuestionOption(id: 'dsp_4f_other', label: 'No puedo acceder a la cámara', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_4_clean', text: '¿Limpiaste el domo o lente de la cámara?', options: [
    QuestionOption(id: 'dsp_4c_yes', label: 'Sí, sigue igual', evidence: [EvidenceWeight(hypothesisId: 'physical_damage', weight: 0.6), EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.3)]),
    QuestionOption(id: 'dsp_4c_no', label: 'No lo he limpiado', evidence: [EvidenceWeight(hypothesisId: 'environmental_factor', weight: 0.8), EvidenceWeight(hypothesisId: 'sensor_burn_ir_reflection', weight: 0.4)]),
    QuestionOption(id: 'dsp_4c_other', label: 'No puedo acceder', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'dsp_4_ir', text: '¿Los LEDs infrarrojos de la cámara se encienden de noche?', options: [
    QuestionOption(id: 'dsp_4i_yes', label: 'Sí, pero la imagen deslumbra o se ve blanca', evidence: [EvidenceWeight(hypothesisId: 'sensor_burn_ir_reflection', weight: 0.9), EvidenceWeight(hypothesisId: 'environmental_factor', weight: 0.5)]),
    QuestionOption(id: 'dsp_4i_no', label: 'No, los LEDs no encienden', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.6), EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.5)]),
    QuestionOption(id: 'dsp_4i_other', label: 'No puedo ver los LEDs', icon: Icons.help_outline_rounded),
  ]),
];

// ── Audio: DVR/NVR ────────────────────────────────────────────────────────────
const cctvAudioQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'aud_2_nvr', text: '¿Qué tipo de ruido hace el DVR/NVR?', subtitle: 'Escucha con atención y selecciona el más parecido', options: [
    QuestionOption(id: 'aud_2n_click', label: 'Click repetitivo (tipo reloj o arañazo)', nextQuestionId: 'aud_3_hdd', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'fan_failure', weight: -0.2)]),
    QuestionOption(id: 'aud_2n_fan', label: 'Zumbido fuerte continuo', nextQuestionId: 'aud_3_fan_nvr', evidence: [EvidenceWeight(hypothesisId: 'fan_failure', weight: 0.6), EvidenceWeight(hypothesisId: 'equipment_overheating', weight: 0.3)]),
    QuestionOption(id: 'aud_2n_beep', label: 'Pitido constante o en intervalos', nextQuestionId: 'aud_3_beep', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.4), EvidenceWeight(hypothesisId: 'equipment_overheating', weight: 0.2)]),
    QuestionOption(id: 'aud_2n_other', label: 'Otro sonido', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'aud_3_hdd', text: '¿El DVR/NVR sigue grabando correctamente?', options: [
    QuestionOption(id: 'aud_3h_yes', label: 'Sí, graba pero hace ruido', nextQuestionId: 'aud_4_hdd_age', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.4)]),
    QuestionOption(id: 'aud_3h_no', label: 'No, dejó de grabar o aparece error', nextQuestionId: 'aud_4_hdd_fail', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.8)]),
    QuestionOption(id: 'aud_3h_other', label: 'No lo sé / no tengo acceso', icon: Icons.help_outline_rounded, evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.2)]),
  ]),
  DiagnosticQuestion(id: 'aud_4_hdd_age', text: '¿Qué antigüedad tiene el disco duro del DVR/NVR?', options: [
    QuestionOption(id: 'aud_4ha_new', label: 'Menos de 1 año', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.3)]),
    QuestionOption(id: 'aud_4ha_old', label: 'Más de 2 años sin mantenimiento', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.7)]),
    QuestionOption(id: 'aud_4ha_other', label: 'No lo sé', icon: Icons.help_outline_rounded, evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.2)]),
  ]),
  DiagnosticQuestion(id: 'aud_4_hdd_fail', text: '¿El DVR/NVR muestra algún mensaje de error en pantalla?', options: [
    QuestionOption(id: 'aud_4hf_hdd_err', label: 'Sí — error de disco duro', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.9)]),
    QuestionOption(id: 'aud_4hf_no_err', label: 'No muestra ningún error', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.5)]),
    QuestionOption(id: 'aud_4hf_other', label: 'No puedo ver la pantalla', icon: Icons.help_outline_rounded, evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.3)]),
  ]),
  DiagnosticQuestion(id: 'aud_3_fan_nvr', text: '¿El DVR/NVR está caliente al tacto?', options: [
    QuestionOption(id: 'aud_3fn_yes', label: 'Sí, muy caliente', evidence: [EvidenceWeight(hypothesisId: 'equipment_overheating', weight: 0.7), EvidenceWeight(hypothesisId: 'fan_failure', weight: 0.5)]),
    QuestionOption(id: 'aud_3fn_no', label: 'No, temperatura normal', evidence: [EvidenceWeight(hypothesisId: 'fan_failure', weight: 0.5), EvidenceWeight(hypothesisId: 'equipment_overheating', weight: -0.2)]),
    QuestionOption(id: 'aud_3fn_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded, evidence: [EvidenceWeight(hypothesisId: 'fan_failure', weight: 0.2)]),
  ]),
  DiagnosticQuestion(id: 'aud_3_beep', text: '¿El DVR/NVR muestra algún mensaje de error en pantalla?', options: [
    QuestionOption(id: 'aud_3b_hdd', label: 'Error de disco duro', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.8)]),
    QuestionOption(id: 'aud_3b_temp', label: 'Alerta de temperatura', evidence: [EvidenceWeight(hypothesisId: 'equipment_overheating', weight: 0.7), EvidenceWeight(hypothesisId: 'fan_failure', weight: 0.5)]),
    QuestionOption(id: 'aud_3b_net', label: 'Error de red o cámara desconectada', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.1), EvidenceWeight(hypothesisId: 'equipment_overheating', weight: 0.1)]),
    QuestionOption(id: 'aud_3b_none', label: 'No muestra ningún error', evidence: [EvidenceWeight(hypothesisId: 'hdd_failure', weight: 0.3)]),
    QuestionOption(id: 'aud_3b_other', label: 'No puedo ver la pantalla', icon: Icons.help_outline_rounded),
  ]),
];

// ── Camera issues ─────────────────────────────────────────────────────────────
const cctvCameraQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'cam_1', text: '¿Qué problema tiene la cámara?', options: [
    QuestionOption(id: 'cam_1_novid', label: 'No transmite video', icon: Icons.videocam_off_rounded, nextQuestionId: 'cam_2_novid'),
    QuestionOption(id: 'cam_1_norec', label: 'No graba en el NVR', icon: Icons.save_rounded, nextQuestionId: 'cam_2_norec'),
    QuestionOption(id: 'cam_1_move', label: 'PTZ no responde', icon: Icons.open_with_rounded, nextQuestionId: 'cam_2_ptz'),
    QuestionOption(id: 'cam_1_other', label: 'Otro problema', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_2_novid', text: '¿La cámara enciende y tiene LEDs activos?', options: [
    QuestionOption(id: 'cam_2nv_yes', label: 'Sí, enciende correctamente', nextQuestionId: 'cam_3_stream'),
    QuestionOption(id: 'cam_2nv_no', label: 'No enciende', nextQuestionId: 'cam_3_power'),
    QuestionOption(id: 'cam_2nv_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_2_norec', text: '¿La cámara aparece en la lista del NVR?', options: [
    QuestionOption(id: 'cam_2nr_yes', label: 'Sí, pero no graba', nextQuestionId: 'cam_3_storage'),
    QuestionOption(id: 'cam_2nr_no', label: 'No aparece', nextQuestionId: 'cam_3_add'),
    QuestionOption(id: 'cam_2nr_other', label: 'No tengo acceso al NVR', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_2_ptz', text: '¿El PTZ funcionaba antes correctamente?', options: [
    QuestionOption(id: 'cam_2p_yes', label: 'Sí, dejó de funcionar', nextQuestionId: 'cam_3_ptz_config'),
    QuestionOption(id: 'cam_2p_never', label: 'Nunca ha funcionado', nextQuestionId: 'cam_3_ptz_config'),
    QuestionOption(id: 'cam_2p_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_3_stream', text: '¿Puedes ver el stream directo en la interfaz web?', options: [
    QuestionOption(id: 'cam_3s_yes', label: 'Sí, en web funciona', nextQuestionId: 'cam_4_protocol'),
    QuestionOption(id: 'cam_3s_no', label: 'No, tampoco en web', evidence: [EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'network_port_closed', weight: 0.5)]),
    QuestionOption(id: 'cam_3s_other', label: 'No sé acceder a la web', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_3_power', text: '¿Verificaste la alimentación (PoE / Adaptador)?', options: [
    QuestionOption(id: 'cam_3pw_yes', label: 'Sí, la alimentación es correcta', evidence: [EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.8), EvidenceWeight(hypothesisId: 'firmware_bug', weight: 0.4)]),
    QuestionOption(id: 'cam_3pw_no', label: 'No lo he verificado', evidence: [EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.6)]),
    QuestionOption(id: 'cam_3pw_other', label: 'Necesito ayuda', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_3_storage', text: '¿El disco duro del NVR tiene espacio disponible?', options: [
    QuestionOption(id: 'cam_3st_yes', label: 'Sí, hay espacio', nextQuestionId: 'cam_4_schedule'),
    QuestionOption(id: 'cam_3st_no', label: 'No, disco lleno o no detectado', evidence: [EvidenceWeight(hypothesisId: 'hdd_sata_fault', weight: 0.8), EvidenceWeight(hypothesisId: 'storage_full', weight: 0.6)]),
    QuestionOption(id: 'cam_3st_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_3_add', text: '¿Intentaste agregar la cámara manualmente al NVR?', options: [
    QuestionOption(id: 'cam_3a_yes', label: 'Sí, da error de red o timeout', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.7), EvidenceWeight(hypothesisId: 'network_port_closed', weight: 0.5)]),
    QuestionOption(id: 'cam_3a_no', label: 'No lo he intentado', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.6)]),
    QuestionOption(id: 'cam_3a_other', label: 'No sé cómo hacerlo', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_3_ptz_config', text: '¿El protocolo PTZ está configurado correctamente?', options: [
    QuestionOption(id: 'cam_3pc_yes', label: 'Sí, protocolo e ID correctos', evidence: [EvidenceWeight(hypothesisId: 'rs485_polarity_reversed', weight: 0.8), EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.6)]),
    QuestionOption(id: 'cam_3pc_no', label: 'No estoy seguro o está mal configurado', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.9)]),
    QuestionOption(id: 'cam_3pc_other', label: 'No sé qué protocolo usa', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_4_protocol', text: '¿Qué protocolo de stream usa (RTSP, ONVIF, propietario)?', options: [
    QuestionOption(id: 'cam_4p_rtsp', label: 'RTSP pero la cadena de conexión falla', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.7)]),
    QuestionOption(id: 'cam_4p_onvif', label: 'ONVIF pero solicita un perfil erróneo', evidence: [EvidenceWeight(hypothesisId: 'firmware_bug', weight: 0.6), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5)]),
    QuestionOption(id: 'cam_4p_prop', label: 'Propietario del fabricante pero la versión es distinta', evidence: [EvidenceWeight(hypothesisId: 'firmware_bug', weight: 0.8)]),
    QuestionOption(id: 'cam_4p_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'cam_4_schedule', text: '¿La grabación está programada para este horario?', options: [
    QuestionOption(id: 'cam_4s_yes', label: 'Sí, debería grabar (marcado en verde/continuo)', evidence: [EvidenceWeight(hypothesisId: 'firmware_bug', weight: 0.6), EvidenceWeight(hypothesisId: 'hdd_sata_fault', weight: 0.5)]),
    QuestionOption(id: 'cam_4s_no', label: 'No, es fuera de horario (configurado por movimiento)', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.9)]),
    QuestionOption(id: 'cam_4s_other', label: 'No sé la programación', icon: Icons.help_outline_rounded),
  ]),
];
