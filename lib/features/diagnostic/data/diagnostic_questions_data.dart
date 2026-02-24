import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

/// Árboles de preguntas de diagnóstico por síntoma.
///
/// Cada síntoma tiene su propio flujo de preguntas que puede ramificarse
/// según el tipo de dispositivo (CCTV, Red, Energía, Control de Acceso).
/// Profundidad: 4–5 niveles. La última opción siempre es "Otro / Asistencia IA".
final Map<String, List<DiagnosticQuestion>> diagnosticQuestionTrees = {
  // ═══════════════════════════════════════════════════
  // POWER ISSUE — "No enciende"
  // ═══════════════════════════════════════════════════
  'power_issue': [
    // ── Paso 1: tipo de dispositivo ──
    const DiagnosticQuestion(
      id: 'pow_1',
      text: '¿Qué tipo de equipo presenta el problema?',
      subtitle: 'Selecciona la categoría del dispositivo',
      options: [
        QuestionOption(id: 'pow_1_cctv', label: 'Cámara / DVR / NVR', icon: Icons.videocam_rounded, nextQuestionId: 'pow_2_cctv'),
        QuestionOption(id: 'pow_1_net', label: 'Switch / Router / AP', icon: Icons.router_rounded, nextQuestionId: 'pow_2_net'),
        QuestionOption(id: 'pow_1_ups', label: 'UPS / Fuente de poder', icon: Icons.battery_charging_full_rounded, nextQuestionId: 'pow_2_ups'),
        QuestionOption(id: 'pow_1_acc', label: 'Control de acceso', icon: Icons.lock_rounded, nextQuestionId: 'pow_2_acc'),
        QuestionOption(id: 'pow_1_other', label: 'Otro equipo', description: 'Describir con asistencia IA', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 2 CCTV ──
    const DiagnosticQuestion(
      id: 'pow_2_cctv',
      text: '¿El LED indicador de la cámara se enciende?',
      subtitle: 'Revisa los LEDs frontales o traseros del equipo',
      options: [
        QuestionOption(id: 'pow_2c_yes', label: 'Sí, el LED se enciende', nextQuestionId: 'pow_3_cctv_led_on'),
        QuestionOption(id: 'pow_2c_no', label: 'No, ningún LED', nextQuestionId: 'pow_3_cctv_led_off'),
        QuestionOption(id: 'pow_2c_blink', label: 'Parpadea intermitentemente', nextQuestionId: 'pow_3_cctv_blink'),
        QuestionOption(id: 'pow_2c_other', label: 'No estoy seguro', description: 'Solicitar asistencia IA', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 3 CCTV: LED encendido ──
    const DiagnosticQuestion(
      id: 'pow_3_cctv_led_on',
      text: '¿El equipo transmite imagen al monitor/NVR?',
      options: [
        QuestionOption(id: 'pow_3co_yes', label: 'Sí, pero se congela', nextQuestionId: 'pow_4_cctv_freeze'),
        QuestionOption(id: 'pow_3co_no', label: 'No hay imagen', nextQuestionId: 'pow_4_cctv_no_img'),
        QuestionOption(id: 'pow_3co_other', label: 'Otro comportamiento', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 3 CCTV: LED apagado ──
    const DiagnosticQuestion(
      id: 'pow_3_cctv_led_off',
      text: '¿Cómo se alimenta el equipo?',
      options: [
        QuestionOption(id: 'pow_3cf_poe', label: 'PoE (cable de red)', nextQuestionId: 'pow_4_cctv_poe'),
        QuestionOption(id: 'pow_3cf_adapter', label: 'Adaptador DC 12V/24V', nextQuestionId: 'pow_4_cctv_adapter'),
        QuestionOption(id: 'pow_3cf_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 3 CCTV: Parpadeo ──
    const DiagnosticQuestion(
      id: 'pow_3_cctv_blink',
      text: '¿Cada cuánto se reinicia?',
      options: [
        QuestionOption(id: 'pow_3cb_freq', label: 'Cada pocos segundos', nextQuestionId: 'pow_4_cctv_poe'),
        QuestionOption(id: 'pow_3cb_random', label: 'De forma aleatoria', nextQuestionId: 'pow_4_cctv_adapter'),
        QuestionOption(id: 'pow_3cb_other', label: 'Otro patrón', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 4 CCTV: PoE ──
    const DiagnosticQuestion(
      id: 'pow_4_cctv_poe',
      text: '¿El puerto PoE del switch muestra actividad?',
      subtitle: 'Revisa los LEDs del puerto donde está conectada la cámara',
      options: [
        QuestionOption(id: 'pow_4cp_yes', label: 'Sí, LED activo', nextQuestionId: 'pow_5_cctv_cable'),
        QuestionOption(id: 'pow_4cp_no', label: 'No, LED apagado', nextQuestionId: 'pow_5_cctv_switch'),
        QuestionOption(id: 'pow_4cp_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 4 CCTV: Adaptador ──
    const DiagnosticQuestion(
      id: 'pow_4_cctv_adapter',
      text: '¿El adaptador tiene LED o indicador de encendido?',
      options: [
        QuestionOption(id: 'pow_4ca_yes', label: 'Sí, el adaptador enciende', nextQuestionId: 'pow_5_cctv_cable'),
        QuestionOption(id: 'pow_4ca_no', label: 'No, el adaptador está muerto'),
        QuestionOption(id: 'pow_4ca_other', label: 'No estoy seguro', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 4 CCTV: Imagen congelada ──
    const DiagnosticQuestion(
      id: 'pow_4_cctv_freeze',
      text: '¿El equipo se reinicia solo o se queda congelado?',
      options: [
        QuestionOption(id: 'pow_4cfr_restart', label: 'Se reinicia periódicamente'),
        QuestionOption(id: 'pow_4cfr_frozen', label: 'Se queda congelado'),
        QuestionOption(id: 'pow_4cfr_other', label: 'Otro comportamiento', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 4 CCTV: Sin imagen ──
    const DiagnosticQuestion(
      id: 'pow_4_cctv_no_img',
      text: '¿Probaste con otro cable de video o puerto?',
      options: [
        QuestionOption(id: 'pow_4ci_yes', label: 'Sí, mismo resultado'),
        QuestionOption(id: 'pow_4ci_no', label: 'No lo he probado'),
        QuestionOption(id: 'pow_4ci_other', label: 'No aplica', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 5 CCTV: Cable ──
    const DiagnosticQuestion(
      id: 'pow_5_cctv_cable',
      text: '¿Probaste con otro cable de red / alimentación?',
      options: [
        QuestionOption(id: 'pow_5cc_yes', label: 'Sí, con otro cable funciona'),
        QuestionOption(id: 'pow_5cc_no', label: 'Sí, mismo resultado con otro cable'),
        QuestionOption(id: 'pow_5cc_skip', label: 'No tengo otro cable disponible'),
        QuestionOption(id: 'pow_5cc_other', label: 'Necesito ayuda', icon: Icons.help_outline_rounded),
      ],
    ),
    // ── Paso 5 CCTV: Switch ──
    const DiagnosticQuestion(
      id: 'pow_5_cctv_switch',
      text: '¿El switch/inyector PoE está encendido correctamente?',
      options: [
        QuestionOption(id: 'pow_5cs_yes', label: 'Sí, otros equipos funcionan'),
        QuestionOption(id: 'pow_5cs_no', label: 'No, el switch también falló'),
        QuestionOption(id: 'pow_5cs_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
      ],
    ),

    // ── Paso 2 RED ──
    const DiagnosticQuestion(
      id: 'pow_2_net',
      text: '¿Los LEDs del switch/router están encendidos?',
      options: [
        QuestionOption(id: 'pow_2n_all', label: 'Todos los LEDs encendidos', nextQuestionId: 'pow_3_net_on'),
        QuestionOption(id: 'pow_2n_some', label: 'Solo algunos LEDs', nextQuestionId: 'pow_3_net_partial'),
        QuestionOption(id: 'pow_2n_none', label: 'Ningún LED encendido', nextQuestionId: 'pow_3_net_off'),
        QuestionOption(id: 'pow_2n_other', label: 'No estoy seguro', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_3_net_on',
      text: '¿Los puertos transmiten datos correctamente?',
      options: [
        QuestionOption(id: 'pow_3no_yes', label: 'Sí, pero lento', nextQuestionId: 'pow_4_net_slow'),
        QuestionOption(id: 'pow_3no_no', label: 'No, sin conectividad', nextQuestionId: 'pow_4_net_noconn'),
        QuestionOption(id: 'pow_3no_other', label: 'Otro', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_3_net_partial',
      text: '¿El equipo hace algún sonido o el ventilador gira?',
      options: [
        QuestionOption(id: 'pow_3np_fan', label: 'Sí, el ventilador gira'),
        QuestionOption(id: 'pow_3np_no', label: 'No hay ruido'),
        QuestionOption(id: 'pow_3np_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_3_net_off',
      text: '¿Verificaste el cable de alimentación y la toma eléctrica?',
      options: [
        QuestionOption(id: 'pow_3nf_yes', label: 'Sí, el tomacorriente funciona'),
        QuestionOption(id: 'pow_3nf_no', label: 'No lo he verificado'),
        QuestionOption(id: 'pow_3nf_other', label: 'Necesito ayuda', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_4_net_slow',
      text: '¿El problema es en todos los puertos o solo en algunos?',
      options: [
        QuestionOption(id: 'pow_4ns_all', label: 'Todos los puertos'),
        QuestionOption(id: 'pow_4ns_some', label: 'Solo algunos puertos'),
        QuestionOption(id: 'pow_4ns_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_4_net_noconn',
      text: '¿Reiniciaste el equipo recientemente?',
      options: [
        QuestionOption(id: 'pow_4nn_yes', label: 'Sí, sin mejoría'),
        QuestionOption(id: 'pow_4nn_no', label: 'No lo he reiniciado'),
        QuestionOption(id: 'pow_4nn_other', label: 'Otro', icon: Icons.help_outline_rounded),
      ],
    ),

    // ── Paso 2 UPS ──
    const DiagnosticQuestion(
      id: 'pow_2_ups',
      text: '¿El UPS emite algún sonido o alarma?',
      options: [
        QuestionOption(id: 'pow_2u_beep', label: 'Sí, emite pitidos', nextQuestionId: 'pow_3_ups_beep'),
        QuestionOption(id: 'pow_2u_silent', label: 'No, totalmente silencioso', nextQuestionId: 'pow_3_ups_silent'),
        QuestionOption(id: 'pow_2u_other', label: 'Otro sonido', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_3_ups_beep',
      text: '¿Cuántos pitidos y con qué frecuencia?',
      options: [
        QuestionOption(id: 'pow_3ub_cont', label: 'Pitido continuo', nextQuestionId: 'pow_4_ups_overload'),
        QuestionOption(id: 'pow_3ub_inter', label: 'Pitidos intermitentes', nextQuestionId: 'pow_4_ups_battery'),
        QuestionOption(id: 'pow_3ub_other', label: 'No sé identificar', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_3_ups_silent',
      text: '¿Hay energía eléctrica en la toma de corriente?',
      options: [
        QuestionOption(id: 'pow_3us_yes', label: 'Sí, hay corriente'),
        QuestionOption(id: 'pow_3us_no', label: 'No hay corriente'),
        QuestionOption(id: 'pow_3us_other', label: 'No puedo medir', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_4_ups_overload',
      text: '¿Cuántos equipos están conectados al UPS?',
      options: [
        QuestionOption(id: 'pow_4uo_many', label: 'Más de los recomendados'),
        QuestionOption(id: 'pow_4uo_few', label: 'Dentro de la capacidad'),
        QuestionOption(id: 'pow_4uo_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_4_ups_battery',
      text: '¿Hace cuánto se reemplazó la batería?',
      options: [
        QuestionOption(id: 'pow_4ub_new', label: 'Menos de 1 año'),
        QuestionOption(id: 'pow_4ub_old', label: 'Más de 2 años'),
        QuestionOption(id: 'pow_4ub_never', label: 'Nunca se ha cambiado'),
        QuestionOption(id: 'pow_4ub_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),

    // ── Paso 2 ACCESS CONTROL ──
    const DiagnosticQuestion(
      id: 'pow_2_acc',
      text: '¿El panel de control de acceso muestra algo en pantalla?',
      options: [
        QuestionOption(id: 'pow_2a_yes', label: 'Sí, pantalla encendida', nextQuestionId: 'pow_3_acc_on'),
        QuestionOption(id: 'pow_2a_no', label: 'No, pantalla apagada', nextQuestionId: 'pow_3_acc_off'),
        QuestionOption(id: 'pow_2a_other', label: 'No tiene pantalla / No sé', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_3_acc_on',
      text: '¿La cerradura o torniquete responde a comandos?',
      options: [
        QuestionOption(id: 'pow_3ao_yes', label: 'Sí, pero con retardo', nextQuestionId: 'pow_4_acc_delay'),
        QuestionOption(id: 'pow_3ao_no', label: 'No responde'),
        QuestionOption(id: 'pow_3ao_other', label: 'Otro comportamiento', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_3_acc_off',
      text: '¿Cómo se alimenta el panel?',
      options: [
        QuestionOption(id: 'pow_3af_dc', label: '12V DC directo'),
        QuestionOption(id: 'pow_3af_poe', label: 'PoE'),
        QuestionOption(id: 'pow_3af_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'pow_4_acc_delay',
      text: '¿El retardo ocurre siempre o es intermitente?',
      options: [
        QuestionOption(id: 'pow_4ad_always', label: 'Siempre tarda'),
        QuestionOption(id: 'pow_4ad_inter', label: 'A veces funciona rápido'),
        QuestionOption(id: 'pow_4ad_other', label: 'No lo puedo determinar', icon: Icons.help_outline_rounded),
      ],
    ),
  ],

  // ═══════════════════════════════════════════════════
  // CONNECTIVITY ISSUE — "Sin conexión"
  // ═══════════════════════════════════════════════════
  'connectivity_issue': [
    const DiagnosticQuestion(
      id: 'con_1',
      text: '¿Qué tipo de equipo perdió conexión?',
      subtitle: 'Selecciona la categoría del dispositivo',
      options: [
        QuestionOption(id: 'con_1_cctv', label: 'Cámara / DVR / NVR', icon: Icons.videocam_rounded, nextQuestionId: 'con_2_cctv'),
        QuestionOption(id: 'con_1_net', label: 'Switch / Router / AP', icon: Icons.router_rounded, nextQuestionId: 'con_2_net'),
        QuestionOption(id: 'con_1_acc', label: 'Control de acceso', icon: Icons.lock_rounded, nextQuestionId: 'con_2_acc'),
        QuestionOption(id: 'con_1_other', label: 'Otro equipo', description: 'Describir con asistencia IA', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_2_cctv',
      text: '¿La cámara responde a ping desde la red?',
      options: [
        QuestionOption(id: 'con_2c_yes', label: 'Sí responde a ping', nextQuestionId: 'con_3_cctv_ping_ok'),
        QuestionOption(id: 'con_2c_no', label: 'No responde a ping', nextQuestionId: 'con_3_cctv_ping_fail'),
        QuestionOption(id: 'con_2c_dk', label: 'No sé hacer ping', nextQuestionId: 'con_3_cctv_check'),
        QuestionOption(id: 'con_2c_other', label: 'Otro', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_3_cctv_ping_ok',
      text: '¿Puedes acceder a la interfaz web de la cámara?',
      options: [
        QuestionOption(id: 'con_3co_yes', label: 'Sí, pero sin video', nextQuestionId: 'con_4_cctv_novid'),
        QuestionOption(id: 'con_3co_no', label: 'No carga la página', nextQuestionId: 'con_4_cctv_port'),
        QuestionOption(id: 'con_3co_other', label: 'No lo he intentado', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_3_cctv_ping_fail',
      text: '¿El LED del puerto del switch está activo?',
      options: [
        QuestionOption(id: 'con_3cf_yes', label: 'Sí, LED activo', nextQuestionId: 'con_4_cctv_ip'),
        QuestionOption(id: 'con_3cf_no', label: 'No, LED apagado', nextQuestionId: 'con_4_cctv_cable'),
        QuestionOption(id: 'con_3cf_other', label: 'No puedo ver', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_3_cctv_check',
      text: '¿El LED de red en la cámara parpadea?',
      options: [
        QuestionOption(id: 'con_3cc_yes', label: 'Sí, parpadea', nextQuestionId: 'con_4_cctv_ip'),
        QuestionOption(id: 'con_3cc_no', label: 'No parpadea', nextQuestionId: 'con_4_cctv_cable'),
        QuestionOption(id: 'con_3cc_other', label: 'No tiene LED de red', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_4_cctv_novid',
      text: '¿El stream de video muestra error o simplemente no carga?',
      options: [
        QuestionOption(id: 'con_4cn_err', label: 'Muestra un error'),
        QuestionOption(id: 'con_4cn_load', label: 'Se queda cargando'),
        QuestionOption(id: 'con_4cn_other', label: 'Otro', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_4_cctv_port',
      text: '¿Verificaste que el puerto HTTP de la cámara es correcto?',
      options: [
        QuestionOption(id: 'con_4cp_yes', label: 'Sí, es el puerto por defecto'),
        QuestionOption(id: 'con_4cp_changed', label: 'Se cambió el puerto'),
        QuestionOption(id: 'con_4cp_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_4_cctv_ip',
      text: '¿La IP de la cámara está en el mismo segmento de red?',
      options: [
        QuestionOption(id: 'con_4ci_yes', label: 'Sí, mismo segmento'),
        QuestionOption(id: 'con_4ci_no', label: 'No, segmento diferente'),
        QuestionOption(id: 'con_4ci_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_4_cctv_cable',
      text: '¿Probaste cambiando el cable o el puerto del switch?',
      options: [
        QuestionOption(id: 'con_4cc_yes', label: 'Sí, mismo resultado'),
        QuestionOption(id: 'con_4cc_no', label: 'No lo he probado'),
        QuestionOption(id: 'con_4cc_other', label: 'No tengo material', icon: Icons.help_outline_rounded),
      ],
    ),

    // Paso 2 RED
    const DiagnosticQuestion(
      id: 'con_2_net',
      text: '¿El problema afecta a toda la red o solo a un segmento?',
      options: [
        QuestionOption(id: 'con_2n_all', label: 'Toda la red', nextQuestionId: 'con_3_net_all'),
        QuestionOption(id: 'con_2n_seg', label: 'Solo un segmento/VLAN', nextQuestionId: 'con_3_net_seg'),
        QuestionOption(id: 'con_2n_one', label: 'Solo un puerto', nextQuestionId: 'con_3_net_port'),
        QuestionOption(id: 'con_2n_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_3_net_all',
      text: '¿El router/gateway principal está operativo?',
      options: [
        QuestionOption(id: 'con_3na_yes', label: 'Sí, encendido y con LEDs', nextQuestionId: 'con_4_net_dns'),
        QuestionOption(id: 'con_3na_no', label: 'No, está apagado'),
        QuestionOption(id: 'con_3na_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_3_net_seg',
      text: '¿El switch de ese segmento está funcionando?',
      options: [
        QuestionOption(id: 'con_3ns_yes', label: 'Sí, LEDs activos', nextQuestionId: 'con_4_net_vlan'),
        QuestionOption(id: 'con_3ns_no', label: 'No, tiene problemas'),
        QuestionOption(id: 'con_3ns_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_3_net_port',
      text: '¿Probaste conectando a otro puerto del switch?',
      options: [
        QuestionOption(id: 'con_3np_yes', label: 'Sí, funciona en otro puerto'),
        QuestionOption(id: 'con_3np_no', label: 'No, falla en todos'),
        QuestionOption(id: 'con_3np_other', label: 'No lo he probado', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_4_net_dns',
      text: '¿Puedes navegar usando IP directa pero no por nombre de dominio?',
      options: [
        QuestionOption(id: 'con_4nd_yes', label: 'Sí, es problema de DNS'),
        QuestionOption(id: 'con_4nd_no', label: 'No, ni por IP funciona'),
        QuestionOption(id: 'con_4nd_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_4_net_vlan',
      text: '¿Se realizó algún cambio de configuración reciente?',
      options: [
        QuestionOption(id: 'con_4nv_yes', label: 'Sí, hubo cambios'),
        QuestionOption(id: 'con_4nv_no', label: 'No, dejó de funcionar solo'),
        QuestionOption(id: 'con_4nv_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),

    // Paso 2 ACCESS
    const DiagnosticQuestion(
      id: 'con_2_acc',
      text: '¿El panel se comunica con el software de gestión?',
      options: [
        QuestionOption(id: 'con_2a_yes', label: 'Sí, pero con errores', nextQuestionId: 'con_3_acc_err'),
        QuestionOption(id: 'con_2a_no', label: 'No, aparece desconectado', nextQuestionId: 'con_3_acc_disc'),
        QuestionOption(id: 'con_2a_other', label: 'No tengo software de gestión', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_3_acc_err',
      text: '¿Qué tipo de error muestra?',
      options: [
        QuestionOption(id: 'con_3ae_timeout', label: 'Timeout de conexión'),
        QuestionOption(id: 'con_3ae_auth', label: 'Error de autenticación'),
        QuestionOption(id: 'con_3ae_other', label: 'Otro error', icon: Icons.help_outline_rounded),
      ],
    ),
    const DiagnosticQuestion(
      id: 'con_3_acc_disc',
      text: '¿El panel tiene IP fija o DHCP?',
      options: [
        QuestionOption(id: 'con_3ad_static', label: 'IP fija'),
        QuestionOption(id: 'con_3ad_dhcp', label: 'DHCP'),
        QuestionOption(id: 'con_3ad_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
      ],
    ),
  ],

  // ═══════════════════════════════════════════════════
  // DISPLAY ISSUE — "Imagen borrosa"
  // ═══════════════════════════════════════════════════
  'display_issue': _displayIssueQuestions,

  // ═══════════════════════════════════════════════════
  // AUDIO ISSUE — "Ruido extraño"
  // ═══════════════════════════════════════════════════
  'audio_issue': _audioIssueQuestions,

  // ═══════════════════════════════════════════════════
  // CAMERA ISSUE — "Cámara falla"
  // ═══════════════════════════════════════════════════
  'camera_issue': _cameraIssueQuestions,

  // ═══════════════════════════════════════════════════
  // OTHER ISSUE — "Otro problema"
  // ═══════════════════════════════════════════════════
  'other_issue': _otherIssueQuestions,
};

// ─────────────────────────────────────────────────────
// Display issue questions
// ─────────────────────────────────────────────────────
const _displayIssueQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(
    id: 'dsp_1',
    text: '¿Dónde se presenta el problema de imagen?',
    options: [
      QuestionOption(id: 'dsp_1_cam', label: 'En una cámara específica', icon: Icons.videocam_rounded, nextQuestionId: 'dsp_2_cam'),
      QuestionOption(id: 'dsp_1_nvr', label: 'En el monitor/NVR', icon: Icons.monitor_rounded, nextQuestionId: 'dsp_2_nvr'),
      QuestionOption(id: 'dsp_1_all', label: 'En todas las cámaras', nextQuestionId: 'dsp_2_all'),
      QuestionOption(id: 'dsp_1_other', label: 'Otro', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_2_cam',
    text: '¿Qué tipo de problema tiene la imagen?',
    options: [
      QuestionOption(id: 'dsp_2c_blur', label: 'Borrosa / desenfocada', nextQuestionId: 'dsp_3_blur'),
      QuestionOption(id: 'dsp_2c_lines', label: 'Líneas o rayas', nextQuestionId: 'dsp_3_lines'),
      QuestionOption(id: 'dsp_2c_dark', label: 'Imagen muy oscura', nextQuestionId: 'dsp_3_dark'),
      QuestionOption(id: 'dsp_2c_other', label: 'Otro defecto', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_2_nvr',
    text: '¿El NVR muestra todas las cámaras con problemas?',
    options: [
      QuestionOption(id: 'dsp_2n_all', label: 'Sí, todas tienen mal video', nextQuestionId: 'dsp_3_nvr_output'),
      QuestionOption(id: 'dsp_2n_some', label: 'Solo algunas cámaras', nextQuestionId: 'dsp_3_blur'),
      QuestionOption(id: 'dsp_2n_other', label: 'Otro', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_2_all',
    text: '¿Cuándo comenzó el problema?',
    options: [
      QuestionOption(id: 'dsp_2a_sudden', label: 'De repente', nextQuestionId: 'dsp_3_nvr_output'),
      QuestionOption(id: 'dsp_2a_gradual', label: 'Gradualmente', nextQuestionId: 'dsp_3_blur'),
      QuestionOption(id: 'dsp_2a_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_3_blur',
    text: '¿La cámara tiene lente con enfoque manual?',
    options: [
      QuestionOption(id: 'dsp_3b_yes', label: 'Sí, tiene anillo de enfoque', nextQuestionId: 'dsp_4_focus'),
      QuestionOption(id: 'dsp_3b_no', label: 'No, es foco fijo', nextQuestionId: 'dsp_4_clean'),
      QuestionOption(id: 'dsp_3b_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_3_lines',
    text: '¿Las líneas son horizontales o verticales?',
    options: [
      QuestionOption(id: 'dsp_3l_h', label: 'Horizontales'),
      QuestionOption(id: 'dsp_3l_v', label: 'Verticales'),
      QuestionOption(id: 'dsp_3l_other', label: 'Ambas / Otro patrón', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_3_dark',
    text: '¿El problema ocurre de noche o también de día?',
    options: [
      QuestionOption(id: 'dsp_3d_night', label: 'Solo de noche', nextQuestionId: 'dsp_4_ir'),
      QuestionOption(id: 'dsp_3d_always', label: 'Todo el tiempo', nextQuestionId: 'dsp_4_clean'),
      QuestionOption(id: 'dsp_3d_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_3_nvr_output',
    text: '¿Probaste con otro cable HDMI/VGA hacia el monitor?',
    options: [
      QuestionOption(id: 'dsp_3no_yes', label: 'Sí, mismo resultado'),
      QuestionOption(id: 'dsp_3no_no', label: 'No lo he probado'),
      QuestionOption(id: 'dsp_3no_other', label: 'No tengo otro cable', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_4_focus',
    text: '¿Ajustaste el anillo de enfoque y sigue borrosa?',
    options: [
      QuestionOption(id: 'dsp_4f_yes', label: 'Sí, no mejora'),
      QuestionOption(id: 'dsp_4f_no', label: 'No lo he ajustado'),
      QuestionOption(id: 'dsp_4f_other', label: 'No puedo acceder a la cámara', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_4_clean',
    text: '¿Limpiaste el domo o lente de la cámara?',
    options: [
      QuestionOption(id: 'dsp_4c_yes', label: 'Sí, sigue igual'),
      QuestionOption(id: 'dsp_4c_no', label: 'No lo he limpiado'),
      QuestionOption(id: 'dsp_4c_other', label: 'No puedo acceder', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'dsp_4_ir',
    text: '¿Los LEDs infrarrojos de la cámara se encienden de noche?',
    options: [
      QuestionOption(id: 'dsp_4i_yes', label: 'Sí, pero imagen sigue oscura'),
      QuestionOption(id: 'dsp_4i_no', label: 'No, los LEDs no encienden'),
      QuestionOption(id: 'dsp_4i_other', label: 'No puedo ver los LEDs', icon: Icons.help_outline_rounded),
    ],
  ),
];

// ─────────────────────────────────────────────────────
// Audio issue questions
// ─────────────────────────────────────────────────────
const _audioIssueQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(
    id: 'aud_1',
    text: '¿De dónde proviene el ruido?',
    options: [
      QuestionOption(id: 'aud_1_nvr', label: 'DVR / NVR', icon: Icons.dns_rounded, nextQuestionId: 'aud_2_nvr'),
      QuestionOption(id: 'aud_1_ups', label: 'UPS', icon: Icons.battery_charging_full_rounded, nextQuestionId: 'aud_2_ups'),
      QuestionOption(id: 'aud_1_switch', label: 'Switch / Router', icon: Icons.router_rounded, nextQuestionId: 'aud_2_switch'),
      QuestionOption(id: 'aud_1_other', label: 'Otro equipo', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'aud_2_nvr',
    text: '¿Qué tipo de ruido hace el NVR?',
    options: [
      QuestionOption(id: 'aud_2n_click', label: 'Click repetitivo (disco duro)', nextQuestionId: 'aud_3_hdd'),
      QuestionOption(id: 'aud_2n_fan', label: 'Zumbido fuerte (ventilador)', nextQuestionId: 'aud_3_fan'),
      QuestionOption(id: 'aud_2n_beep', label: 'Pitido constante', nextQuestionId: 'aud_3_beep'),
      QuestionOption(id: 'aud_2n_other', label: 'Otro ruido', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'aud_2_ups',
    text: '¿El UPS emite pitidos o zumbido?',
    options: [
      QuestionOption(id: 'aud_2u_beep', label: 'Pitidos intermitentes', nextQuestionId: 'aud_3_ups_beep'),
      QuestionOption(id: 'aud_2u_buzz', label: 'Zumbido eléctrico'),
      QuestionOption(id: 'aud_2u_other', label: 'Otro sonido', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'aud_2_switch',
    text: '¿El ruido proviene del ventilador del switch?',
    options: [
      QuestionOption(id: 'aud_2s_yes', label: 'Sí, ventilador ruidoso', nextQuestionId: 'aud_3_fan'),
      QuestionOption(id: 'aud_2s_no', label: 'No, es otro componente'),
      QuestionOption(id: 'aud_2s_other', label: 'No puedo identificar', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'aud_3_hdd',
    text: '¿El disco duro sigue grabando correctamente?',
    options: [
      QuestionOption(id: 'aud_3h_yes', label: 'Sí, pero hace ruido', nextQuestionId: 'aud_4_hdd_age'),
      QuestionOption(id: 'aud_3h_no', label: 'No, dejó de grabar', nextQuestionId: 'aud_4_hdd_fail'),
      QuestionOption(id: 'aud_3h_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'aud_3_fan',
    text: '¿El equipo se sobrecalienta?',
    options: [
      QuestionOption(id: 'aud_3f_yes', label: 'Sí, está muy caliente'),
      QuestionOption(id: 'aud_3f_no', label: 'No, temperatura normal'),
      QuestionOption(id: 'aud_3f_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'aud_3_beep',
    text: '¿El NVR muestra algún mensaje de error en pantalla?',
    options: [
      QuestionOption(id: 'aud_3b_hdd', label: 'Error de disco duro', nextQuestionId: 'aud_4_hdd_fail'),
      QuestionOption(id: 'aud_3b_net', label: 'Error de red'),
      QuestionOption(id: 'aud_3b_none', label: 'No muestra error'),
      QuestionOption(id: 'aud_3b_other', label: 'No puedo ver la pantalla', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'aud_3_ups_beep',
    text: '¿El UPS indica nivel de batería bajo?',
    options: [
      QuestionOption(id: 'aud_3ub_yes', label: 'Sí, LED de batería parpadeando'),
      QuestionOption(id: 'aud_3ub_no', label: 'No, indicadores normales'),
      QuestionOption(id: 'aud_3ub_other', label: 'No puedo ver los indicadores', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'aud_4_hdd_age',
    text: '¿Qué antigüedad tiene el disco duro?',
    options: [
      QuestionOption(id: 'aud_4ha_new', label: 'Menos de 1 año'),
      QuestionOption(id: 'aud_4ha_old', label: 'Más de 2 años'),
      QuestionOption(id: 'aud_4ha_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'aud_4_hdd_fail',
    text: '¿Tienes un disco de repuesto para probar?',
    options: [
      QuestionOption(id: 'aud_4hf_yes', label: 'Sí, puedo reemplazarlo'),
      QuestionOption(id: 'aud_4hf_no', label: 'No tengo repuesto'),
      QuestionOption(id: 'aud_4hf_other', label: 'Necesito ayuda', icon: Icons.help_outline_rounded),
    ],
  ),
];

// ─────────────────────────────────────────────────────
// Camera issue questions
// ─────────────────────────────────────────────────────
const _cameraIssueQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(
    id: 'cam_1',
    text: '¿Qué problema tiene la cámara?',
    options: [
      QuestionOption(id: 'cam_1_novid', label: 'No transmite video', icon: Icons.videocam_off_rounded, nextQuestionId: 'cam_2_novid'),
      QuestionOption(id: 'cam_1_norec', label: 'No graba en el NVR', icon: Icons.save_rounded, nextQuestionId: 'cam_2_norec'),
      QuestionOption(id: 'cam_1_move', label: 'PTZ no responde', icon: Icons.open_with_rounded, nextQuestionId: 'cam_2_ptz'),
      QuestionOption(id: 'cam_1_other', label: 'Otro problema', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_2_novid',
    text: '¿La cámara enciende y tiene LEDs activos?',
    options: [
      QuestionOption(id: 'cam_2nv_yes', label: 'Sí, enciende correctamente', nextQuestionId: 'cam_3_stream'),
      QuestionOption(id: 'cam_2nv_no', label: 'No enciende', nextQuestionId: 'cam_3_power'),
      QuestionOption(id: 'cam_2nv_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_2_norec',
    text: '¿La cámara aparece en la lista del NVR?',
    options: [
      QuestionOption(id: 'cam_2nr_yes', label: 'Sí, pero no graba', nextQuestionId: 'cam_3_storage'),
      QuestionOption(id: 'cam_2nr_no', label: 'No aparece', nextQuestionId: 'cam_3_add'),
      QuestionOption(id: 'cam_2nr_other', label: 'No tengo acceso al NVR', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_2_ptz',
    text: '¿El PTZ funcionaba antes correctamente?',
    options: [
      QuestionOption(id: 'cam_2p_yes', label: 'Sí, dejó de funcionar', nextQuestionId: 'cam_3_ptz_config'),
      QuestionOption(id: 'cam_2p_never', label: 'Nunca ha funcionado', nextQuestionId: 'cam_3_ptz_config'),
      QuestionOption(id: 'cam_2p_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_3_stream',
    text: '¿Puedes ver el stream directo en la interfaz web?',
    options: [
      QuestionOption(id: 'cam_3s_yes', label: 'Sí, en web funciona', nextQuestionId: 'cam_4_protocol'),
      QuestionOption(id: 'cam_3s_no', label: 'No, tampoco en web'),
      QuestionOption(id: 'cam_3s_other', label: 'No sé acceder a la web', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_3_power',
    text: '¿Verificaste la alimentación (PoE / Adaptador)?',
    options: [
      QuestionOption(id: 'cam_3pw_yes', label: 'Sí, la alimentación es correcta'),
      QuestionOption(id: 'cam_3pw_no', label: 'No lo he verificado'),
      QuestionOption(id: 'cam_3pw_other', label: 'Necesito ayuda', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_3_storage',
    text: '¿El disco duro del NVR tiene espacio disponible?',
    options: [
      QuestionOption(id: 'cam_3st_yes', label: 'Sí, hay espacio', nextQuestionId: 'cam_4_schedule'),
      QuestionOption(id: 'cam_3st_no', label: 'No, disco lleno'),
      QuestionOption(id: 'cam_3st_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_3_add',
    text: '¿Intentaste agregar la cámara manualmente al NVR?',
    options: [
      QuestionOption(id: 'cam_3a_yes', label: 'Sí, da error'),
      QuestionOption(id: 'cam_3a_no', label: 'No lo he intentado'),
      QuestionOption(id: 'cam_3a_other', label: 'No sé cómo hacerlo', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_3_ptz_config',
    text: '¿El protocolo PTZ está configurado correctamente (Ejemplo: Pelco-D/P, Axis VAPIX)?',
    options: [
      QuestionOption(id: 'cam_3pc_yes', label: 'Sí, protocolo correcto'),
      QuestionOption(id: 'cam_3pc_no', label: 'No estoy seguro'),
      QuestionOption(id: 'cam_3pc_other', label: 'No sé qué protocolo usa', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_4_protocol',
    text: '¿Qué protocolo de stream usa (RTSP, ONVIF, propietario)?',
    options: [
      QuestionOption(id: 'cam_4p_rtsp', label: 'RTSP'),
      QuestionOption(id: 'cam_4p_onvif', label: 'ONVIF'),
      QuestionOption(id: 'cam_4p_prop', label: 'Propietario del fabricante'),
      QuestionOption(id: 'cam_4p_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'cam_4_schedule',
    text: '¿La grabación está programada para este horario?',
    options: [
      QuestionOption(id: 'cam_4s_yes', label: 'Sí, debería grabar'),
      QuestionOption(id: 'cam_4s_no', label: 'No, es fuera de horario'),
      QuestionOption(id: 'cam_4s_other', label: 'No sé la programación', icon: Icons.help_outline_rounded),
    ],
  ),
];

// ─────────────────────────────────────────────────────
// Other issue questions
// ─────────────────────────────────────────────────────
const _otherIssueQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(
    id: 'oth_1',
    text: '¿Puedes identificar la categoría del problema?',
    subtitle: 'Esto nos ayudará a orientar la asistencia con IA',
    options: [
      QuestionOption(id: 'oth_1_hw', label: 'Problema de hardware', icon: Icons.memory_rounded, nextQuestionId: 'oth_2_hw'),
      QuestionOption(id: 'oth_1_sw', label: 'Problema de software/config', icon: Icons.settings_rounded, nextQuestionId: 'oth_2_sw'),
      QuestionOption(id: 'oth_1_env', label: 'Problema ambiental', icon: Icons.thermostat_rounded, nextQuestionId: 'oth_2_env'),
      QuestionOption(id: 'oth_1_dk', label: 'No lo sé', description: 'Solicitar asistencia IA directa', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'oth_2_hw',
    text: '¿Qué componente de hardware presenta la falla?',
    options: [
      QuestionOption(id: 'oth_2h_port', label: 'Puertos / Conectores', nextQuestionId: 'oth_3_hw_detail'),
      QuestionOption(id: 'oth_2h_struct', label: 'Estructura / Carcasa', nextQuestionId: 'oth_3_hw_detail'),
      QuestionOption(id: 'oth_2h_comp', label: 'Componente interno', nextQuestionId: 'oth_3_hw_detail'),
      QuestionOption(id: 'oth_2h_other', label: 'No puedo identificar', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'oth_2_sw',
    text: '¿Qué tipo de problema de software?',
    options: [
      QuestionOption(id: 'oth_2s_config', label: 'Error de configuración', nextQuestionId: 'oth_3_sw_detail'),
      QuestionOption(id: 'oth_2s_update', label: 'Problema tras actualización', nextQuestionId: 'oth_3_sw_detail'),
      QuestionOption(id: 'oth_2s_compat', label: 'Incompatibilidad', nextQuestionId: 'oth_3_sw_detail'),
      QuestionOption(id: 'oth_2s_other', label: 'Otro', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'oth_2_env',
    text: '¿Qué factor ambiental afecta al equipo?',
    options: [
      QuestionOption(id: 'oth_2e_temp', label: 'Temperatura extrema', nextQuestionId: 'oth_3_env_detail'),
      QuestionOption(id: 'oth_2e_humidity', label: 'Humedad / condensación', nextQuestionId: 'oth_3_env_detail'),
      QuestionOption(id: 'oth_2e_dust', label: 'Polvo / suciedad', nextQuestionId: 'oth_3_env_detail'),
      QuestionOption(id: 'oth_2e_other', label: 'Otro factor', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'oth_3_hw_detail',
    text: '¿El daño es visible a simple vista?',
    options: [
      QuestionOption(id: 'oth_3hd_yes', label: 'Sí, se ve el daño'),
      QuestionOption(id: 'oth_3hd_no', label: 'No, funciona pero con fallas'),
      QuestionOption(id: 'oth_3hd_other', label: 'Necesito ayuda para evaluar', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'oth_3_sw_detail',
    text: '¿Tienes acceso para revertir el cambio o restaurar config?',
    options: [
      QuestionOption(id: 'oth_3sd_yes', label: 'Sí, puedo restaurar'),
      QuestionOption(id: 'oth_3sd_no', label: 'No, no tengo acceso'),
      QuestionOption(id: 'oth_3sd_backup', label: 'Tengo un respaldo'),
      QuestionOption(id: 'oth_3sd_other', label: 'Necesito orientación', icon: Icons.help_outline_rounded),
    ],
  ),
  DiagnosticQuestion(
    id: 'oth_3_env_detail',
    text: '¿Puedes reubicar o proteger el equipo?',
    options: [
      QuestionOption(id: 'oth_3ed_yes', label: 'Sí, puedo reubicarlo'),
      QuestionOption(id: 'oth_3ed_no', label: 'No, la ubicación es fija'),
      QuestionOption(id: 'oth_3ed_other', label: 'Necesito opciones de protección', icon: Icons.help_outline_rounded),
    ],
  ),
];
