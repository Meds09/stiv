import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PREGUNTAS DE RED / NETWORKING
// Cubre síntomas: power (switch/router), connectivity
// ─────────────────────────────────────────────────────────────────────────────

// ── Power: Switch/Router ──────────────────────────────────────────────────────
const networkPowerQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'pow_2_net', text: '¿Qué equipo de red no enciende?', options: [
    QuestionOption(id: 'pow_2n_switch', label: 'Switch', icon: Icons.device_hub_rounded, nextQuestionId: 'pow_3_net_device'),
    QuestionOption(id: 'pow_2n_router', label: 'Router / Gateway', icon: Icons.router_rounded, nextQuestionId: 'pow_3_net_device'),
    QuestionOption(id: 'pow_2n_ap', label: 'Access Point WiFi', icon: Icons.wifi_rounded, nextQuestionId: 'pow_3_net_ap'),
    QuestionOption(id: 'pow_2n_other', label: 'Otro / No sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_3_net_device', text: '¿Todos los LEDs del equipo están apagados?', options: [
    QuestionOption(id: 'pow_3nd_yes', label: 'Sí, completamente apagado', nextQuestionId: 'pow_4_net_power'),
    QuestionOption(id: 'pow_3nd_part', label: 'Algunos LEDs encienden pero el equipo no opera', nextQuestionId: 'pow_4_net_partial'),
    QuestionOption(id: 'pow_3nd_other', label: 'Otro comportamiento', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_3_net_ap', text: '¿El AP se alimenta vía PoE o adaptador?', options: [
    QuestionOption(id: 'pow_3na_poe', label: 'PoE desde switch', nextQuestionId: 'pow_4_net_poe'),
    QuestionOption(id: 'pow_3na_adapter', label: 'Adaptador DC', nextQuestionId: 'pow_4_net_power'),
    QuestionOption(id: 'pow_3na_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_4_net_power', text: '¿El tomacorriente al que está conectado funciona?', options: [
    QuestionOption(id: 'pow_4np_yes', label: 'Sí, otros equipos conectados ahí funcionan', nextQuestionId: 'pow_5_net_cable'),
    QuestionOption(id: 'pow_4np_no', label: 'No, el tomacorriente está muerto', evidence: [EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.8), EvidenceWeight(hypothesisId: 'power_strip_trip', weight: 0.7)]),
    QuestionOption(id: 'pow_4np_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_4_net_poe', text: '¿El switch PoE funciona y otros puertos están activos?', options: [
    QuestionOption(id: 'pow_4npo_yes', label: 'Sí, otros puertos PoE funcionan', nextQuestionId: 'pow_5_net_cable'),
    QuestionOption(id: 'pow_4npo_no', label: 'No, el switch tampoco enciende', nextQuestionId: 'pow_4_net_power'),
    QuestionOption(id: 'pow_4npo_all_fail', label: 'Todos los puertos PoE fallaron', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.9), EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.5)]),
    QuestionOption(id: 'pow_4npo_other', label: 'No puedo verificar', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_4_net_partial', text: '¿El equipo acepta configuración o se reinicia en bucle?', options: [
    QuestionOption(id: 'pow_4na_config', label: 'Acepta conexión pero ningún puerto funciona', evidence: [EvidenceWeight(hypothesisId: 'switch_port_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'equipment_failure', weight: 0.4)]),
    QuestionOption(id: 'pow_4na_reboot', label: 'Se reinicia cada pocos segundos', evidence: [EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.6), EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.5)]),
    QuestionOption(id: 'pow_4na_other', label: 'Otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'pow_5_net_cable', text: '¿El cable o adaptador de alimentación está en buen estado?', options: [
    QuestionOption(id: 'pow_5nc_yes', label: 'Sí, visualmente en buen estado', evidence: [EvidenceWeight(hypothesisId: 'equipment_internal_failure', weight: 0.7), EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.3)]),
    QuestionOption(id: 'pow_5nc_no', label: 'No, tiene daños visibles o está caliente', evidence: [EvidenceWeight(hypothesisId: 'cable_failure', weight: 0.8), EvidenceWeight(hypothesisId: 'power_adapter_failure', weight: 0.6)]),
    QuestionOption(id: 'pow_5nc_other', label: 'No he revisado el cable', icon: Icons.help_outline_rounded),
  ]),
];

// ── Connectivity: Network ────────────────────────────────────────────────────
const networkConnectivityQuestions = <DiagnosticQuestion>[
  DiagnosticQuestion(id: 'con_2_net', text: '¿Qué tipo de pérdida de conectividad tienes?', options: [
    QuestionOption(id: 'con_2n_total', label: 'Sin internet en toda la red', icon: Icons.cloud_off_rounded, nextQuestionId: 'con_3_net_isp'),
    QuestionOption(id: 'con_2n_partial', label: 'Algunos equipos sin conexión', nextQuestionId: 'con_3_net_segment'),
    QuestionOption(id: 'con_2n_intermit', label: 'Conexión intermitente/lenta', nextQuestionId: 'con_3_net_intermit'),
    QuestionOption(id: 'con_2n_single', label: 'Solo un equipo sin red', nextQuestionId: 'con_3_net_single'),
    QuestionOption(id: 'con_2n_other', label: 'Otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_3_net_isp', text: '¿El router/modem WAN tiene todos sus LEDs apagados o en rojo?', options: [
    QuestionOption(id: 'con_3ni_yes', label: 'Sí, la señal WAN está caída', nextQuestionId: 'con_4_net_isp'),
    QuestionOption(id: 'con_3ni_no', label: 'No, el WAN está verde pero sin internet', nextQuestionId: 'con_4_net_routing'),
    QuestionOption(id: 'con_3ni_other', label: 'No tengo acceso al router', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_3_net_segment', text: '¿Los equipos sin conexión están en el mismo switch de piso?', options: [
    QuestionOption(id: 'con_3ns_yes', label: 'Sí, todos en el mismo switch', nextQuestionId: 'con_4_net_switch'),
    QuestionOption(id: 'con_3ns_no', label: 'No, están en distintos switches', nextQuestionId: 'con_4_net_vlan'),
    QuestionOption(id: 'con_3ns_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_3_net_intermit', text: '¿Has detectado picos de actividad en los LEDs de los switches?', options: [
    QuestionOption(id: 'con_3nit_storm', label: 'Sí, parpadean todos al mismo tiempo caóticamente', nextQuestionId: 'con_4_net_loop'),
    QuestionOption(id: 'con_3nit_slow', label: 'Parpadean pero todo va muy lento', nextQuestionId: 'con_4_net_band'),
    QuestionOption(id: 'con_3nit_other', label: 'Comportamiento normal en los LEDs', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_3_net_single', text: '¿El equipo tiene conexión por cable o WiFi?', options: [
    QuestionOption(id: 'con_3nsi_cable', label: 'Cable UTP', nextQuestionId: 'con_4_net_cable_check'),
    QuestionOption(id: 'con_3nsi_wifi', label: 'WiFi', nextQuestionId: 'con_4_net_wifi'),
    QuestionOption(id: 'con_3nsi_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_4_net_isp', text: '¿Tienes ticket activo con el proveedor de internet?', options: [
    QuestionOption(id: 'con_4ni_yes', label: 'Sí, el ISP está al tanto', evidence: [EvidenceWeight(hypothesisId: 'gateway_failure', weight: 0.9)]),
    QuestionOption(id: 'con_4ni_no', label: 'No, no hemos llamado al ISP aún', evidence: [EvidenceWeight(hypothesisId: 'gateway_failure', weight: 0.7)]),
    QuestionOption(id: 'con_4ni_other', label: 'Es enlace propio / radio punto a punto', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_4_net_routing', text: '¿El router responde a ping desde un equipo conectado?', options: [
    QuestionOption(id: 'con_4nr_yes', label: 'Sí, responde ping al gateway', evidence: [EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.6), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5)]),
    QuestionOption(id: 'con_4nr_no', label: 'No, no responde ni al gateway', evidence: [EvidenceWeight(hypothesisId: 'gateway_failure', weight: 0.8)]),
    QuestionOption(id: 'con_4nr_other', label: 'No sé hacer ping', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_4_net_switch', text: '¿El switch de ese piso/segmento tiene los LEDs activos?', options: [
    QuestionOption(id: 'con_4ns_yes', label: 'Sí, el switch parece activo', nextQuestionId: 'con_5_net_port'),
    QuestionOption(id: 'con_4ns_no', label: 'No, el switch está apagado o reiniciando', evidence: [EvidenceWeight(hypothesisId: 'poe_failure', weight: 0.8), EvidenceWeight(hypothesisId: 'electrical_overload', weight: 0.5)]),
    QuestionOption(id: 'con_4ns_other', label: 'No puedo acceder al rack', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_4_net_vlan', text: '¿Se realizaron cambios de VLAN recientemente?', options: [
    QuestionOption(id: 'con_4nv_yes', label: 'Sí, se hicieron cambios de VLAN o segmentación', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.9), EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.4)]),
    QuestionOption(id: 'con_4nv_no', label: 'No, no hubo cambios', evidence: [EvidenceWeight(hypothesisId: 'switch_port_failure', weight: 0.6), EvidenceWeight(hypothesisId: 'dhcp_pool_exhausted', weight: 0.5)]),
    QuestionOption(id: 'con_4nv_other', label: 'No tengo información', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_4_net_loop', text: '¿Desconectaste los cables uno a uno para aislar el bucle?', options: [
    QuestionOption(id: 'con_4nl_yes', label: 'Sí, al desconectar uno la red se normalizó', evidence: [EvidenceWeight(hypothesisId: 'loopback_storm', weight: 0.95)]),
    QuestionOption(id: 'con_4nl_no', label: 'No, aún no lo he intentado', evidence: [EvidenceWeight(hypothesisId: 'loopback_storm', weight: 0.7)]),
    QuestionOption(id: 'con_4nl_other', label: 'No aplica / otro', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_4_net_band', text: '¿Hay algún equipo nuevo en la red desde que empezó el problema?', options: [
    QuestionOption(id: 'con_4nb_yes', label: 'Sí, se agregó un equipo nuevo', evidence: [EvidenceWeight(hypothesisId: 'bandwidth_issue', weight: 0.7), EvidenceWeight(hypothesisId: 'ip_conflict', weight: 0.5)]),
    QuestionOption(id: 'con_4nb_no', label: 'No, configuración sin cambios', evidence: [EvidenceWeight(hypothesisId: 'equipment_overheating', weight: 0.5), EvidenceWeight(hypothesisId: 'switch_port_failure', weight: 0.4)]),
    QuestionOption(id: 'con_4nb_other', label: 'No lo sé', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_4_net_cable_check', text: '¿El tester de red da verde en todos los pares?', options: [
    QuestionOption(id: 'con_4ncc_yes', label: 'Sí, cable ok', nextQuestionId: 'con_5_net_ip'),
    QuestionOption(id: 'con_4ncc_no', label: 'No, algún par falla', evidence: [EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.9)]),
    QuestionOption(id: 'con_4ncc_notest', label: 'No tengo tester', evidence: [EvidenceWeight(hypothesisId: 'cable_network_failure', weight: 0.5), EvidenceWeight(hypothesisId: 'dirty_ethernet_port', weight: 0.4)]),
    QuestionOption(id: 'con_4ncc_other', label: 'No aplica', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_4_net_wifi', text: '¿La señal WiFi del equipo tiene al menos 3 barras?', options: [
    QuestionOption(id: 'con_4nw_yes', label: 'Sí, señal fuerte', nextQuestionId: 'con_5_net_ip'),
    QuestionOption(id: 'con_4nw_no', label: 'No, señal débil o intermitente', evidence: [EvidenceWeight(hypothesisId: 'wifi_interference', weight: 0.8)]),
    QuestionOption(id: 'con_4nw_other', label: 'No puedo ver la señal', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_5_net_port', text: '¿Probando la conexión en un puerto diferente del switch, funciona?', options: [
    QuestionOption(id: 'con_5np_yes', label: 'Sí, en otro puerto funciona', evidence: [EvidenceWeight(hypothesisId: 'switch_port_failure', weight: 0.9)]),
    QuestionOption(id: 'con_5np_no', label: 'No, sigue sin funcionar', evidence: [EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.6), EvidenceWeight(hypothesisId: 'ip_conflict', weight: 0.5)]),
    QuestionOption(id: 'con_5np_other', label: 'No hay puertos disponibles', icon: Icons.help_outline_rounded),
  ]),
  DiagnosticQuestion(id: 'con_5_net_ip', text: '¿El equipo tiene una IP válida (no 169.254.x.x)?', options: [
    QuestionOption(id: 'con_5ni_yes', label: 'Sí, tiene IP válida', evidence: [EvidenceWeight(hypothesisId: 'firewall_blocking', weight: 0.6), EvidenceWeight(hypothesisId: 'misconfiguration', weight: 0.5)]),
    QuestionOption(id: 'con_5ni_no', label: 'No, tiene IP APIPA (169.254.x.x)', evidence: [EvidenceWeight(hypothesisId: 'dhcp_pool_exhausted', weight: 0.9)]),
    QuestionOption(id: 'con_5ni_other', label: 'No lo sé / no puedo revisar', icon: Icons.help_outline_rounded),
  ]),
];
