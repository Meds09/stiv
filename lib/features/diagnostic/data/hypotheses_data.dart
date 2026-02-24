import 'package:stiv/features/diagnostic/models/hypothesis.dart';

/// Hipótesis diagnósticas agrupadas por síntoma.
///
/// Cada árbol de diagnóstico define sus propias hipótesis con acciones
/// recomendadas y umbrales de escalación a IA.
final Map<String, List<Hypothesis>> hypothesesBySymptom = {
  // ══════════════════════════════════════════════════════
  // POWER ISSUE — "No enciende"
  // ══════════════════════════════════════════════════════
  'power_issue': const [
    Hypothesis(
      id: 'poe_failure',
      label: 'Falla de alimentación PoE',
      description: 'El switch o inyector PoE no entrega energía al dispositivo.',
      recommendedActions: [
        'Verificar que el switch PoE esté encendido y operativo.',
        'Probar con otro puerto PoE del switch.',
        'Conectar un inyector PoE independiente para aislar el problema.',
        'Revisar el consumo de watts del equipo vs. capacidad del switch.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'power_adapter_failure',
      label: 'Falla de adaptador de alimentación',
      description: 'El adaptador DC o fuente de poder del equipo está dañado.',
      recommendedActions: [
        'Medir voltaje de salida del adaptador con multímetro.',
        'Probar con un adaptador de reemplazo compatible.',
        'Verificar el conector del adaptador en el equipo.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'cable_failure',
      label: 'Falla de cableado',
      description: 'El cable de red o alimentación tiene un corte o mal contacto.',
      recommendedActions: [
        'Reemplazar el cable por uno nuevo y certificado.',
        'Verificar la terminación RJ45 en ambos extremos.',
        'Probar con un cable de menor longitud.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'equipment_failure',
      label: 'Falla interna del equipo',
      description: 'El equipo tiene un daño interno (placa, fusible, BIOS).',
      recommendedActions: [
        'Realizar reset de fábrica si el equipo tiene botón de reset.',
        'Verificar si hay componentes quemados o con olor.',
        'Enviar el equipo a servicio técnico autorizado.',
      ],
      escalationThreshold: 0.45,
    ),
    Hypothesis(
      id: 'overload',
      label: 'Sobrecarga eléctrica',
      description: 'El UPS o circuito eléctrico está sobrecargado.',
      recommendedActions: [
        'Desconectar equipos hasta reducir la carga al 80% de la capacidad.',
        'Distribuir equipos en varios circuitos.',
        'Revisar el disyuntor o breaker asociado al circuito.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'ups_battery_failure',
      label: 'Batería de UPS agotada/dañada',
      description: 'La batería interna del UPS superó su vida útil.',
      recommendedActions: [
        'Reemplazar la batería interna del UPS (cada 2-3 años).',
        'Verificar el indicador de batería en el panel del UPS.',
        'Actualizar el firmware del UPS si aplica.',
      ],
      escalationThreshold: 0.40,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // CONNECTIVITY ISSUE — "Sin conexión"
  // ══════════════════════════════════════════════════════
  'connectivity_issue': const [
    Hypothesis(
      id: 'ip_conflict',
      label: 'Conflicto de dirección IP',
      description: 'Dos equipos en la red comparten la misma dirección IP.',
      recommendedActions: [
        'Asignar IP estática única fuera del rango DHCP.',
        'Revisar la tabla ARP del switch para detectar duplicados.',
        'Usar DHCP con reserva por MAC address.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'cable_network_failure',
      label: 'Falla de cable de red',
      description: 'El cable de red tiene un daño físico o mal contacto.',
      recommendedActions: [
        'Probar el cable con un tester de red.',
        'Reemplazar el cable y/o los conectores RJ45.',
        'Verificar que el cable no supere los 100 metros sin repetidor.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'switch_port_failure',
      label: 'Puerto del switch dañado',
      description: 'El puerto específico del switch no funciona correctamente.',
      recommendedActions: [
        'Conectar el équipo a otro puerto del switch.',
        'Verificar el estado del puerto en la consola del switch.',
        'Actualizar el firmware del switch.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'misconfiguration',
      label: 'Mala configuración de red',
      description: 'La configuración de VLAN, puerta de enlace o DNS es incorrecta.',
      recommendedActions: [
        'Verificar la configuración IP del dispositivo afectado.',
        'Comparar con la configuración de un dispositivo que sí funciona.',
        'Revisar la configuración de VLAN y trunking en el switch.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'gateway_failure',
      label: 'Falla del router/gateway',
      description: 'El router principal o dispositivo de gateway no funciona.',
      recommendedActions: [
        'Reiniciar el router y esperar 2 minutos.',
        'Verificar el estado de la conexión WAN.',
        'Contactar al proveedor de internet si hay corte de servicio.',
      ],
      escalationThreshold: 0.40,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // DISPLAY ISSUE — "Imagen borrosa"
  // ══════════════════════════════════════════════════════
  'display_issue': const [
    Hypothesis(
      id: 'lens_focus',
      label: 'Problema de enfoque del lente',
      description: 'El anillo de enfoque del lente está mal calibrado.',
      recommendedActions: [
        'Ajustar el anillo de enfoque de la cámara manualmente.',
        'Usar la función de enfoque automático si el modelo lo permite.',
        'Verificar que el vidrio del domo no esté rayado.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'dirty_lens',
      label: 'Lente o domo sucio',
      description: 'El lente o el domo de la cámara está sucio o empañado.',
      recommendedActions: [
        'Limpiar el domo con paño de microfibra y limpiador óptico.',
        'Verificar que no haya humedad dentro del domo.',
        'Inspeccionar el sello de silicona del domo.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'ir_failure',
      label: 'Falla de LEDs infrarrojos',
      description: 'Los LEDs IR de la cámara no encienden correctamente.',
      recommendedActions: [
        'Limpiar los LEDs IR con paño suave.',
        'Verificar si el sensor de luz ambiente funciona.',
        'Actualizar el firmware de la cámara.',
        'Enviar a servicio técnico si los LEDs están quemados.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'signal_degradation',
      label: 'Degradación de señal de video',
      description: 'La señal de video se degrada por cable largo o interferencia.',
      recommendedActions: [
        'Verificar la longitud del cable de video (max 300m coaxial CCTV).',
        'Usar amplificadores de señal o baluns si el cable es muy largo.',
        'Revisar conexiones BNC y cortes en el cable.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'nvr_output_failure',
      label: 'Falla en la salida del NVR/DVR',
      description: 'El problema está en la salida HDMI/VGA del grabador.',
      recommendedActions: [
        'Probar con otro cable HDMI/VGA.',
        'Probar el NVR con otro monitor.',
        'Verificar la configuración de resolución de salida del NVR.',
      ],
      escalationThreshold: 0.35,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // AUDIO ISSUE — "Ruido extraño"
  // ══════════════════════════════════════════════════════
  'audio_issue': const [
    Hypothesis(
      id: 'hdd_failure',
      label: 'Falla del disco duro',
      description: 'El disco duro del NVR/DVR está fallando o a punto de fallar.',
      recommendedActions: [
        'Verificar el estado SMART del disco desde el menú del NVR.',
        'Hacer una copia de seguridad inmediatamente.',
        'Reemplazar el disco duro por uno de especificación para videovigilancia.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'fan_failure',
      label: 'Falla o desgaste del ventilador',
      description: 'El ventilador del equipo está desgastado o bloqueado.',
      recommendedActions: [
        'Limpiar el ventilador y las rejillas con aire comprimido.',
        'Verificar que el ventilador gire libremente.',
        'Reemplazar el ventilador si el ruido persiste.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'ups_battery_failure',
      label: 'Batería de UPS agotada/dañada',
      description: 'La batería interna del UPS superó su vida útil o está defectuosa.',
      recommendedActions: [
        'Reemplazar la batería interna del UPS (recambio recomendado cada 2-3 años).',
        'Verificar el indicador de batería en el panel del UPS.',
        'Asegurarse de usar la batería de reemplazo oficial del fabricante.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'ups_overload',
      label: 'Sobrecarga del UPS',
      description: 'El UPS está conectado a más carga de la que puede soportar.',
      recommendedActions: [
        'Calcular la carga total conectada y compararla con la capacidad del UPS (VA).',
        'Desconectar equipos no críticos hasta que el indicador de sobrecarga desaparezca.',
        'Considerar un UPS de mayor capacidad si la carga no puede reducirse.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'equipment_overheating',
      label: 'Sobrecalentamiento del equipo',
      description: 'El equipo supera su temperatura de operación normal.',
      recommendedActions: [
        'Verificar que el equipo tenga ventilación adecuada en el rack.',
        'Limpiar el interior del equipo con aire comprimido.',
        'Instalar bandejas de ventilación forzada si el gabinete es cerrado.',
      ],
      escalationThreshold: 0.40,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // CAMERA ISSUE — "Cámara falla"
  // ══════════════════════════════════════════════════════
  'camera_issue': const [
    Hypothesis(
      id: 'stream_config_error',
      label: 'Error de configuración de stream',
      description: 'El protocolo de video o los parámetros del stream son incorrectos.',
      recommendedActions: [
        'Verificar el protocolo de stream (RTSP, ONVIF) en la configuración de la cámara.',
        'Revisar el puerto de stream y credenciales de acceso.',
        'Restablecer la configuración de stream a valores por defecto.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'storage_full',
      label: 'Almacenamiento lleno o dañado',
      description: 'El disco del NVR está lleno o con errores de escritura.',
      recommendedActions: [
        'Revisar el espacio disponible en el disco del NVR.',
        'Habilitar la grabación en bucle (overwrite) si no está activa.',
        'Verificar el estado del disco (SMART) desde el menú del NVR.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'ptz_config_error',
      label: 'Error de configuración PTZ',
      description: 'El protocolo o dirección RS-485 del PTZ no está configurado.',
      recommendedActions: [
        'Verificar el protocolo PTZ (Pelco-D, Pelco-P, ONVIF).',
        'Confirmar la velocidad de baudios y la dirección del PTZ.',
        'Probar con otro cable RS-485.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'camera_not_discovered',
      label: 'Cámara no descubierta en el NVR',
      description: 'El NVR no detecta la cámara en la red local.',
      recommendedActions: [
        'Verificar que la cámara y el NVR estén en el mismo segmento de red.',
        'Usar la herramienta IP Search del fabricante para localizar la cámara.',
        'Agregar la cámara manualmente con su IP y credenciales.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'camera_power_failure',
      label: 'Falla de alimentación de la cámara',
      description: 'La cámara no recibe alimentación eléctrica adecuada.',
      recommendedActions: [
        'Verificar el LED de encendido de la cámara.',
        'Probar con otro puerto PoE o adaptador DC.',
        'Medir el voltaje en el conector de alimentación de la cámara.',
      ],
      escalationThreshold: 0.35,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // OTHER ISSUE — "Otro problema"
  // ══════════════════════════════════════════════════════
  'other_issue': const [
    Hypothesis(
      id: 'hardware_fault',
      label: 'Falla de hardware',
      description: 'Componente físico del equipo dañado.',
      recommendedActions: [
        'Inspeccionar visualmente el equipo en busca de daños.',
        'Verificar conectores y tarjetas internas.',
        'Enviar a servicio técnico para diagnóstico profundo.',
      ],
      escalationThreshold: 0.50,
    ),
    Hypothesis(
      id: 'software_config',
      label: 'Error de software / configuración',
      description: 'La configuración del sistema o firmware presenta fallas.',
      recommendedActions: [
        'Restablecer la configuración de fábrica del equipo.',
        'Actualizar el firmware a la última versión estable.',
        'Revisar logs del sistema en busca de errores.',
      ],
      escalationThreshold: 0.50,
    ),
    Hypothesis(
      id: 'environmental_factor',
      label: 'Factor ambiental',
      description: 'Condiciones ambientales adversas afectan el equipo.',
      recommendedActions: [
        'Verificar temperatura y humedad del cuarto técnico.',
        'Instalar aire acondicionado o ventilación si es necesario.',
        'Revisar el ingreso de agua o polvo al gabinete.',
      ],
      escalationThreshold: 0.45,
    ),
  ],
};
