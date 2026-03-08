import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PREGUNTAS DE CONTROL DE ACCESO
// IDs sincronizados con device_diagnostic_data.dart:
//   pow_2_acc  → árbol de energía / alimentación
//   con_2_acc  → árbol de comunicación / red
//   oth_2_acc  → árbol de problemas específicos de acceso
// ─────────────────────────────────────────────────────────────────────────────

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  ENERGÍA / ALIMENTACIÓN                                                   ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
const accessPowerQuestions = <DiagnosticQuestion>[

  // ── Q1: síntoma inicial de energía ─────────────────────────────────────────
  DiagnosticQuestion(
    id: 'pow_2_acc',
    text: '¿Qué observas en el panel o equipo de acceso?',
    subtitle: 'Describe el estado actual de los LEDs y la respuesta del equipo',
    options: [
      QuestionOption(
        id: 'pow_2acc_dead',
        label: 'Sin ningún LED encendido (equipo muerto)',
        icon: Icons.power_off_rounded,
        nextQuestionId: 'pow_3_acc_adapter',
      ),
      QuestionOption(
        id: 'pow_2acc_restart',
        label: 'Panel reinicia constantemente o parpadea',
        icon: Icons.refresh_rounded,
        nextQuestionId: 'pow_3_acc_battery',
      ),
      QuestionOption(
        id: 'pow_2acc_lock',
        label: 'Panel enciende, pero la cerradura no responde',
        icon: Icons.lock_open_rounded,
        nextQuestionId: 'pow_3_acc_lock_volt',
      ),
      QuestionOption(
        id: 'pow_2acc_other',
        label: 'Otro',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Sin energía: verificar fuente/transformador ─────────────────────────────
  DiagnosticQuestion(
    id: 'pow_3_acc_adapter',
    text: '¿La fuente de alimentación principal del panel tiene energía?',
    subtitle: 'Verifica si el tomacorriente, regleta o UPS que alimenta el equipo tiene tensión',
    options: [
      QuestionOption(
        id: 'pow_3ada_nowall',
        label: 'No hay energía en el tomacorriente',
        evidence: [
          EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.7),
          EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'pow_3ada_wall_ok',
        label: 'Hay energía en el tomacorriente, pero el transformador no entrega voltaje',
        nextQuestionId: 'pow_4_acc_transformer',
        evidence: [
          EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.85),
        ],
      ),
      QuestionOption(
        id: 'pow_3ada_all_ok',
        label: 'Hay energía y el transformador mide voltaje correcto',
        nextQuestionId: 'pow_4_acc_cable_pwr',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.6),
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'pow_3ada_other',
        label: 'No puedo medir',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Transformador dañado ────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'pow_4_acc_transformer',
    text: '¿El transformador o adaptador tiene signos de daño físico?',
    subtitle: 'Revisa si hay olor a quemado, carcasa deformada, o fusible interno abierto',
    options: [
      QuestionOption(
        id: 'pow_4tra_burnt',
        label: 'Sí, hay olor a quemado o daño visible',
        evidence: [
          EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.95),
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.3),
        ],
      ),
      QuestionOption(
        id: 'pow_4tra_fuse',
        label: 'El fusible del transformador está abierto (quemado)',
        evidence: [
          EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.9),
          EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'pow_4tra_ok',
        label: 'No, parece en buen estado',
        evidence: [
          EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.6),
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'pow_4tra_other',
        label: 'No puedo inspeccionar',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Cable de alimentación al panel ─────────────────────────────────────────
  DiagnosticQuestion(
    id: 'pow_4_acc_cable_pwr',
    text: '¿El cableado de alimentación del panel tiene daños visibles?',
    subtitle: 'Inspecciona si los cables de 12V/24V presentan quemaduras, mordeduras, corrosión en bornes o contactos sulfatados',
    options: [
      QuestionOption(
        id: 'pow_4cpwr_sulfat',
        label: 'Sí, hay contactos sulfatados o corroídos en los bornes',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.85),
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.9),
        ],
      ),
      QuestionOption(
        id: 'pow_4cpwr_broken',
        label: 'Sí, cable pelado, cortado o con quemaduras',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.95),
        ],
      ),
      QuestionOption(
        id: 'pow_4cpwr_loose',
        label: 'El cable parece bien pero el borne está suelto',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.75),
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'pow_4cpwr_ok',
        label: 'No, el cableado se ve en buen estado',
        evidence: [
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.7),
        ],
      ),
      QuestionOption(
        id: 'pow_4cpwr_other',
        label: 'No puedo inspeccionar',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Reinicio / inestabilidad: batería de respaldo ──────────────────────────
  DiagnosticQuestion(
    id: 'pow_3_acc_battery',
    text: '¿La batería de respaldo interna del panel presenta anomalías?',
    subtitle: 'Abre la caja del panel y revisa la batería de ácido-plomo (típicamente 12V 4Ah o 7Ah)',
    options: [
      QuestionOption(
        id: 'pow_3bat_swollen',
        label: 'Sí, está hinchada, abombada o muy caliente',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_battery_backup', weight: 0.95),
        ],
      ),
      QuestionOption(
        id: 'pow_3bat_leaking',
        label: 'Tiene fuga de ácido o electrolito',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_battery_backup', weight: 0.9),
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.7),
        ],
      ),
      QuestionOption(
        id: 'pow_3bat_ok_test',
        label: 'Se ve normal — desconectar y probar si se estabiliza',
        nextQuestionId: 'pow_4_acc_bat_disconnect',
      ),
      QuestionOption(
        id: 'pow_3bat_other',
        label: 'No puedo acceder al panel',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Prueba de aislamiento de batería ───────────────────────────────────────
  DiagnosticQuestion(
    id: 'pow_4_acc_bat_disconnect',
    text: '¿Al desconectar completamente la batería, el panel se estabiliza?',
    subtitle: 'Retira ambos terminales de la batería y observa si los LEDs y el sistema reaccionan de forma estable',
    options: [
      QuestionOption(
        id: 'pow_4bat_yes',
        label: 'Sí, sin la batería el panel funciona con normalidad',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_battery_backup', weight: 0.9),
        ],
      ),
      QuestionOption(
        id: 'pow_4bat_no',
        label: 'No, continúa inestable sin la batería',
        evidence: [
          EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.7),
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'pow_4bat_other',
        label: 'No puedo realizar la prueba',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Voltaje en cerradura ────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'pow_3_acc_lock_volt',
    text: '¿Llega el voltaje correcto a los terminales de la cerradura?',
    subtitle: 'Mide con multímetro en los bornes de la cerradura al activar credencial válida (debe ser 12V ±10%)',
    options: [
      QuestionOption(
        id: 'pow_3lv_ok',
        label: 'Sí, mide entre 11V y 13V',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_strike_jammed', weight: 0.8),
        ],
      ),
      QuestionOption(
        id: 'pow_3lv_low',
        label: 'Voltaje bajo (menos de 9V)',
        nextQuestionId: 'pow_4_acc_lock_cable',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.75),
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'pow_3lv_none',
        label: 'No hay voltaje en la cerradura',
        nextQuestionId: 'pow_4_acc_relay',
        evidence: [
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.6),
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'pow_3lv_other',
        label: 'No puedo medir',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Cable de cerradura ──────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'pow_4_acc_lock_cable',
    text: '¿El cableado entre el panel y la cerradura tiene daños?',
    subtitle: 'Verifica continuidad del cable, posibles cortes, aplastamientos o contactos oxidados en los bornes',
    options: [
      QuestionOption(
        id: 'pow_4lc_sulfat',
        label: 'Bornes oxidados o sulfatados en la cerradura o el panel',
        evidence: [
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.9),
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.6),
        ],
      ),
      QuestionOption(
        id: 'pow_4lc_broken',
        label: 'Cable roto, aplastado o sin continuidad',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.95),
        ],
      ),
      QuestionOption(
        id: 'pow_4lc_ok',
        label: 'Cable y bornes en buen estado',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_battery_backup', weight: 0.5),
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'pow_4lc_other',
        label: 'No puedo verificar',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Relé del panel ──────────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'pow_4_acc_relay',
    text: '¿El LED de salida (relay output) del panel se activa al leer una credencial?',
    subtitle: 'Consulta el manual del panel para identificar el LED del relé de salida',
    options: [
      QuestionOption(
        id: 'pow_4rel_yes',
        label: 'Sí, el LED del relé parpadea pero no llega voltaje a la cerradura',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.8),
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'pow_4rel_no',
        label: 'No, el LED del relé no se activa',
        evidence: [
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.7),
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.6),
        ],
      ),
      QuestionOption(
        id: 'pow_4rel_other',
        label: 'No puedo verlo',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),
];

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COMUNICACIÓN / RED                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
const accessConnectivityQuestions = <DiagnosticQuestion>[

  // ── Q1: síntoma inicial de conectividad ────────────────────────────────────
  DiagnosticQuestion(
    id: 'con_2_acc',
    text: '¿Cómo se manifiesta el problema de comunicación?',
    subtitle: 'Describe lo que ocurre entre el panel y el software o red',
    options: [
      QuestionOption(
        id: 'con_2acc_nodetect',
        label: 'El software no detecta el panel en la red',
        nextQuestionId: 'con_3_acc_ping',
      ),
      QuestionOption(
        id: 'con_2acc_nolink',
        label: 'No hay enlace físico (LEDs del puerto apagados)',
        nextQuestionId: 'con_3_acc_cable_net',
      ),
      QuestionOption(
        id: 'con_2acc_drops',
        label: 'La comunicación se corta intermitentemente',
        nextQuestionId: 'con_3_acc_intermittent',
      ),
      QuestionOption(
        id: 'con_2acc_other',
        label: 'Otro',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Verificar alcanzabilidad por ping ──────────────────────────────────────
  DiagnosticQuestion(
    id: 'con_3_acc_ping',
    text: '¿El panel responde a un ping desde la PC del operador?',
    subtitle: 'Ejecuta: ping [IP del panel] desde la terminal del computador del sistema',
    options: [
      QuestionOption(
        id: 'con_3ping_yes',
        label: 'Sí, responde ping, pero el software no lo ve',
        nextQuestionId: 'con_4_acc_soft_config',
        evidence: [
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.7),
          EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'con_3ping_no',
        label: 'No responde ping',
        nextQuestionId: 'con_3_acc_cable_net',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.6),
          EvidenceWeight(hypothesisId: 'ip_conflict', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'con_3ping_other',
        label: 'No puedo hacer la prueba',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Verificar cable de red ─────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'con_3_acc_cable_net',
    text: '¿El cable UTP que conecta el panel al switch tiene continuidad?',
    subtitle: 'Verifica con un tester de red o cambia el cable por uno conocido como bueno',
    options: [
      QuestionOption(
        id: 'con_3cnet_bad',
        label: 'No tiene continuidad (cable dañado)',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.95),
        ],
      ),
      QuestionOption(
        id: 'con_3cnet_ok',
        label: 'Cable OK, tiene continuidad',
        nextQuestionId: 'con_4_acc_port',
        evidence: [
          EvidenceWeight(hypothesisId: 'switch_port_failure', weight: 0.5),
          EvidenceWeight(hypothesisId: 'ip_conflict', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'con_3cnet_notest',
        label: 'No tengo tester de red',
        nextQuestionId: 'con_4_acc_port',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.4),
        ],
      ),
    ],
  ),

  // ── Puerto del switch ───────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'con_4_acc_port',
    text: '¿El LED del puerto en el switch al que está conectado el panel está activo?',
    subtitle: 'Observa si hay LED verde o ámbar encendido/parpadeando en el puerto correspondiente del switch',
    options: [
      QuestionOption(
        id: 'con_4port_yes',
        label: 'Sí, hay enlace en el puerto del switch',
        nextQuestionId: 'con_5_acc_ip',
      ),
      QuestionOption(
        id: 'con_4port_no',
        label: 'No, el LED del puerto está apagado',
        evidence: [
          EvidenceWeight(hypothesisId: 'switch_port_failure', weight: 0.75),
          EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'con_4port_other',
        label: 'No puedo acceder al switch',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Configuración IP ────────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'con_5_acc_ip',
    text: '¿El panel tiene dirección IP fija o la recibe por DHCP?',
    subtitle: 'Consulta la configuración en el software de gestión o en la etiqueta del equipo',
    options: [
      QuestionOption(
        id: 'con_5ip_static',
        label: 'IP fija configurada en el panel',
        evidence: [
          EvidenceWeight(hypothesisId: 'ip_conflict', weight: 0.65),
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'con_5ip_dhcp',
        label: 'DHCP (IP automática)',
        evidence: [
          EvidenceWeight(hypothesisId: 'dhcp_pool_exhausted', weight: 0.7),
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'con_5ip_other',
        label: 'No lo sé',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Configuración en el software ────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'con_4_acc_soft_config',
    text: '¿La IP y el puerto configurados en el software coinciden con los del panel?',
    subtitle: 'Compara la IP del panel (consulta en el panel mismo o por DHCP) con la que tiene el software registrada',
    options: [
      QuestionOption(
        id: 'con_4soft_different',
        label: 'No, hay diferencia de IP o puerto',
        evidence: [
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.9),
        ],
      ),
      QuestionOption(
        id: 'con_4soft_match',
        label: 'Sí, coinciden perfectamente',
        evidence: [
          EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.7),
          EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'con_4soft_other',
        label: 'No tengo acceso al software ahora',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Comunicación intermitente ───────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'con_3_acc_intermittent',
    text: '¿Cuándo ocurren los cortes de comunicación?',
    subtitle: 'Identifica si hay un patrón en las desconexiones',
    options: [
      QuestionOption(
        id: 'con_3int_random',
        label: 'Aleatorio, sin patrón claro',
        nextQuestionId: 'con_4_acc_cable_quality',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.5),
          EvidenceWeight(hypothesisId: 'switch_port_failure', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'con_3int_humid',
        label: 'Con lluvia o en horas muy frías/húmedas',
        evidence: [
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.85),
          EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.6),
        ],
      ),
      QuestionOption(
        id: 'con_3int_overload',
        label: 'En horarios pico (muchos accesos simultáneos)',
        evidence: [
          EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.6),
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'con_3int_other',
        label: 'No puedo determinarlo',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Calidad del cable ────────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'con_4_acc_cable_quality',
    text: '¿El cable de red fue instalado con empalmes o juntas intermedias?',
    subtitle: 'Verifica si el recorrido del cable UTP tiene conectores RJ45 intermedios, empalmes o adaptadores',
    options: [
      QuestionOption(
        id: 'con_4cq_spliced',
        label: 'Sí, hay empalmes o adaptadores en el recorrido',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.8),
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'con_4cq_direct',
        label: 'No, es un cable directo sin empalmes',
        evidence: [
          EvidenceWeight(hypothesisId: 'switch_port_failure', weight: 0.6),
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'con_4cq_other',
        label: 'No puedo verificar el recorrido',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),
];

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  PROBLEMAS ESPECÍFICOS DE CONTROL DE ACCESO                               ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
const accessOtherQuestions = <DiagnosticQuestion>[

  // ── Q1: síntoma específico de acceso ──────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_2_acc',
    text: '¿Cuál es el problema específico del sistema de acceso?',
    subtitle: 'Panel encendido y con comunicación, pero algo no funciona correctamente',
    options: [
      QuestionOption(
        id: 'oth_2acc_lock',
        label: 'Cerradura no abre aunque el panel autoriza',
        nextQuestionId: 'oth_3_acc_relay',
      ),
      QuestionOption(
        id: 'oth_2acc_reader',
        label: 'Lector no reconoce tarjetas o huellas',
        nextQuestionId: 'oth_3_acc_reader',
      ),
      QuestionOption(
        id: 'oth_2acc_rs485',
        label: 'Lector secundario RS-485 / Wiegand no responde',
        nextQuestionId: 'oth_3_acc_rs485',
      ),
      QuestionOption(
        id: 'oth_2acc_cred',
        label: 'No puedo acceder al software del panel (contraseña)',
        nextQuestionId: 'oth_3_acc_cred',
      ),
      QuestionOption(
        id: 'oth_2acc_other',
        label: 'Otro',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Relé y cerradura ───────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_3_acc_relay',
    text: '¿El LED de salida del panel se activa al presentar credencial válida?',
    subtitle: 'Observa el LED del relé o salida digital en el panel al pasar tarjeta/huella',
    options: [
      QuestionOption(
        id: 'oth_3rel_yes',
        label: 'Sí, el LED activa pero la cerradura no abre',
        nextQuestionId: 'oth_4_acc_lock_mech',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.65),
          EvidenceWeight(hypothesisId: 'access_strike_jammed', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'oth_3rel_no',
        label: 'No, el LED de salida nunca activa',
        evidence: [
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.8),
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'oth_3rel_other',
        label: 'No puedo ver el panel',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Mecánica de la cerradura ────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_4_acc_lock_mech',
    text: '¿La puerta ejerce presión excesiva sobre el marco o la cerradura?',
    subtitle: 'Empuja la puerta hacia el marco mientras alguien presenta credencial y observa si abre',
    options: [
      QuestionOption(
        id: 'oth_4lm_pressure',
        label: 'Sí, al empujar la puerta sí abrió',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_strike_jammed', weight: 0.95),
        ],
      ),
      QuestionOption(
        id: 'oth_4lm_cable_susp',
        label: 'No, la puerta está libre pero la cerradura no actúa',
        nextQuestionId: 'oth_5_acc_lock_cable',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.7),
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'oth_4lm_other',
        label: 'No puedo verificar',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Cable de la cerradura ───────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_5_acc_lock_cable',
    text: '¿Los terminales de la cerradura y los bornes del panel tienen signos de oxidación o contactos sulfatados?',
    subtitle: 'Revisa los conectores de 2 hilos de la cerradura electromagnética o eléctrica',
    options: [
      QuestionOption(
        id: 'oth_5lc_sulfat',
        label: 'Sí, hay oxidación, manchas verdosas o contactos sulfatados',
        evidence: [
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.95),
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.6),
        ],
      ),
      QuestionOption(
        id: 'oth_5lc_broken',
        label: 'El cable está partido o tiene discontinuidad',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.95),
        ],
      ),
      QuestionOption(
        id: 'oth_5lc_ok',
        label: 'Todo parece en buen estado',
        evidence: [
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.7),
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'oth_5lc_other',
        label: 'No puedo inspeccionar',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Lector de huellas / tarjetas ───────────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_3_acc_reader',
    text: '¿Cuándo comenzó el problema con el lector?',
    options: [
      QuestionOption(
        id: 'oth_3rdr_sudden',
        label: 'De repente, sin cambios previos',
        nextQuestionId: 'oth_4_acc_reader_clean',
      ),
      QuestionOption(
        id: 'oth_3rdr_newusers',
        label: 'Desde que se agregaron nuevos usuarios o tarjetas',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.8),
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'oth_3rdr_install',
        label: 'Nunca funcionó bien desde la instalación',
        evidence: [
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.75),
          EvidenceWeight(hypothesisId: 'rs485_polarity_reversed', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'oth_3rdr_other',
        label: 'No lo sé',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Limpieza del sensor ─────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_4_acc_reader_clean',
    text: '¿El sensor del lector biométrico o la superficie de lectura NFC/RFID está limpia?',
    subtitle: 'Inspecciona si hay polvo, grasa u obstrucciones físicas sobre el sensor',
    options: [
      QuestionOption(
        id: 'oth_4rclean_dirty',
        label: 'Hay polvo, grasa o suciedad visible',
        evidence: [
          EvidenceWeight(hypothesisId: 'reader_sensor_dirty', weight: 0.9),
        ],
      ),
      QuestionOption(
        id: 'oth_4rclean_ok',
        label: 'Está limpio, sigue fallando',
        nextQuestionId: 'oth_5_acc_reader_cable',
        evidence: [
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.6),
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.4),
        ],
      ),
      QuestionOption(
        id: 'oth_4rclean_other',
        label: 'No puedo acceder al lector',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Cable del lector ────────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_5_acc_reader_cable',
    text: '¿El cableado del lector tiene daños o sus bornes presentan corrosión?',
    subtitle: 'Inspecciona el cableado de alimentación y datos del lector (cables a buscar: 12V, GND, Data0, Data1)',
    options: [
      QuestionOption(
        id: 'oth_5rc_sulfat',
        label: 'Bornes o conectores oxidados / sulfatados',
        evidence: [
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.85),
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.6),
        ],
      ),
      QuestionOption(
        id: 'oth_5rc_broken',
        label: 'Cable dañado o sin continuidad',
        evidence: [
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.9),
        ],
      ),
      QuestionOption(
        id: 'oth_5rc_ok',
        label: 'Todo en buen estado',
        evidence: [
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.7),
        ],
      ),
      QuestionOption(
        id: 'oth_5rc_other',
        label: 'No puedo verificar',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Bus RS-485 / Wiegand ────────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_3_acc_rs485',
    text: '¿Los cables D+ y D- del bus RS-485 están conectados correctamente?',
    subtitle: 'Verifica que el positivo (D+) esté en positivo y el negativo (D-) en negativo en todos los puntos del bus',
    options: [
      QuestionOption(
        id: 'oth_3rs4_reversed',
        label: 'No, podrían estar cruzados o invertidos',
        evidence: [
          EvidenceWeight(hypothesisId: 'rs485_polarity_reversed', weight: 0.95),
        ],
      ),
      QuestionOption(
        id: 'oth_3rs4_sulfat',
        label: 'Sí están correctos, pero los bornes están oxidados',
        nextQuestionId: 'oth_4_acc_rs485_term',
        evidence: [
          EvidenceWeight(hypothesisId: 'corrosion_failure', weight: 0.85),
          EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'oth_3rs4_ok',
        label: 'Sí, todo parece correcto y en buen estado',
        nextQuestionId: 'oth_4_acc_rs485_term',
        evidence: [
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.5),
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'oth_3rs4_other',
        label: 'No puedo verificar el cableado',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Resistencia de terminación RS-485 ──────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_4_acc_rs485_term',
    text: '¿El bus RS-485 tiene resistencia de terminación de 120Ω en el último dispositivo?',
    subtitle: 'En instalaciones largas, el bus RS-485 requiere un resistor de 120 Ohmios al final de la línea',
    options: [
      QuestionOption(
        id: 'oth_4rs4_missing',
        label: 'No, no la tiene instalada',
        evidence: [
          EvidenceWeight(hypothesisId: 'rs485_polarity_reversed', weight: 0.7),
          EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'oth_4rs4_has',
        label: 'Sí, tiene resistencia de terminación',
        evidence: [
          EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.6),
          EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5),
        ],
      ),
      QuestionOption(
        id: 'oth_4rs4_other',
        label: 'No sé verificar esto',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Credenciales del panel ──────────────────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_3_acc_cred',
    text: '¿Tienes acceso a las credenciales originales de fábrica o documentadas en la instalación?',
    options: [
      QuestionOption(
        id: 'oth_3cred_doc',
        label: 'Sí, tengo las credenciales de instalación',
        nextQuestionId: 'oth_4_acc_cred_block',
      ),
      QuestionOption(
        id: 'oth_3cred_lost',
        label: 'No, la contraseña se perdió o nunca se documentó',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.9),
        ],
      ),
      QuestionOption(
        id: 'oth_3cred_other',
        label: 'No lo sé',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),

  // ── Bloqueo por intentos fallidos ───────────────────────────────────────────
  DiagnosticQuestion(
    id: 'oth_4_acc_cred_block',
    text: '¿El panel muestra algún mensaje de bloqueo o de intentos fallidos?',
    options: [
      QuestionOption(
        id: 'oth_4cb_blocked',
        label: 'Sí, indica bloqueo por intentos fallidos',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.85),
        ],
      ),
      QuestionOption(
        id: 'oth_4cb_wrong',
        label: 'No, pero las credenciales correctas no funcionan',
        evidence: [
          EvidenceWeight(hypothesisId: 'access_credentials_error', weight: 0.7),
          EvidenceWeight(hypothesisId: 'firmware_bug', weight: 0.3),
        ],
      ),
      QuestionOption(
        id: 'oth_4cb_other',
        label: 'No puedo ver el mensaje del panel',
        icon: Icons.help_outline_rounded,
      ),
    ],
  ),
];
