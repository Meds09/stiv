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
      description:
          'El switch o inyector PoE no entrega suficiente energía al dispositivo. '
          'Puede deberse a un puerto PoE defectuoso, presupuesto de potencia del switch '
          'agotado, o incompatibilidad entre el estándar PoE del switch (802.3af/at/bt) '
          'y los requerimientos del equipo.',
      recommendedActions: [
        'Paso 1 — Confirmar si el LED del puerto PoE en el switch está encendido. '
            'Un LED apagado indica que el puerto no está entregando energía.',
        'Paso 2 — Conectar el equipo a otro puerto PoE en el mismo switch para '
            'descartar que sea un problema de puerto específico.',
        'Paso 3 — Verificar el presupuesto de potencia total del switch: acceder '
            'a la consola del switch y revisar cuántos watts están en uso vs. '
            'la capacidad total (ej. 370W en un switch de 24 puertos).',
        'Paso 4 — Si el switch no tiene suficiente presupuesto, conectar un '
            'inyector PoE pasivo o activo independiente directamente al equipo.',
        'Paso 5 — Confirmar el estándar PoE del equipo (revisar etiqueta o manual): '
            'si requiere 802.3at (PoE+, 30W) y el switch solo soporta 802.3af (15W), '
            'el equipo no encenderá correctamente.',
        'Paso 6 — Si ningún puerto PoE entrega energía, reiniciar el switch y '
            'verificar la configuración de PoE en la consola de administración.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'power_adapter_failure',
      label: 'Falla de adaptador de alimentación',
      description:
          'El adaptador DC o fuente de poder del equipo está dañado, entrega '
          'voltaje incorrecto o el conector tiene mal contacto. Es una de las '
          'causas más comunes y solucionables sin soporte de IA.',
      recommendedActions: [
        'Paso 1 — Revisar visualmente el cable del adaptador buscando dobleces, '
            'cortes o quemaduras cerca del conector.',
        'Paso 2 — Con un multímetro en DC, medir el voltaje en la punta del '
            'adaptador. El valor debe coincidir ±5% con el voltaje indicado en la '
            'etiqueta del adaptador (ej. 12V DC).',
        'Paso 3 — Si el voltaje medido es 0V o muy bajo, el adaptador está dañado: '
            'reemplazarlo por uno del mismo voltaje, amperaje igual o superior, '
            'y polaridad correcta (positivo en el centro).',
        'Paso 4 — Inspeccionar el conector DC en el equipo: verificar que los pines '
            'estén rectos y limpios. Un pin doblado o sucio impide el contacto.',
        'Paso 5 — Al conectar el adaptador de reemplazo, escuchar si el equipo '
            'emite un "clic" de relé o si el LED de encendido parpadea brevemente '
            '(señal de que recibe energía).',
      ],
      escalationThreshold: 0.25,
    ),
    Hypothesis(
      id: 'cable_failure',
      label: 'Falla de cableado (red/alimentación)',
      description:
          'El cable de red UTP o el cable de alimentación tiene un corte interno, '
          'mal contacto en la terminación RJ45, o supera la longitud máxima permitida. '
          'En instalaciones antiguas, la degradación del revestimiento es frecuente.',
      recommendedActions: [
        'Paso 1 — Pasar el cable por un tester de red (cable tester). Un cable '
            'Category 5e o superior debe pasar las 8 líneas. Si alguna falla, '
            'hay un corte o mal crimpado.',
        'Paso 2 — Inspeccionar los conectores RJ45 en ambos extremos bajo buena '
            'luz: los 8 alambres deben verse ordenados y llegar hasta la punta '
            'del conector antes del crimpado.',
        'Paso 3 — Si el cable supera los 90 metros dentro de paredes o conduit '
            '(más 10m de patchcords = 100m total), reemplazarlo o instalar un '
            'switch intermediario.',
        'Paso 4 — Reemplazar el cable sospechoso por un cable de parcheo corto '
            'conocido como bueno y verificar si el equipo enciende.',
        'Paso 5 — En cables de alimentación, revisar el breaker/regleta asociada '
            'y probar el tomacorriente con otro dispositivo para confirmar que '
            'hay corriente eléctrica en el punto.',
      ],
      escalationThreshold: 0.25,
    ),
    Hypothesis(
      id: 'equipment_internal_failure',
      label: 'Falla interna del equipo (placa/fusible)',
      description:
          'El equipo tiene un daño interno como un fusible fundido, condensador '
          'dañado o falla en la placa principal. Puede ocurrir después de '
          'sobretensiones eléctricas o fallas de UPS.',
      recommendedActions: [
        'Paso 1 — Con el equipo desconectado de la energía, inspeccionar '
            'visualmente si hay componentes quemados, abombados o con olor a '
            'quemado (especialmente condensadores en la fuente de poder).',
        'Paso 2 — Si el equipo tiene botón de reset de fábrica, mantenerlo '
            'presionado 10–15 segundos mientras se conecta la energía; algunos '
            'modelos requieren este proceso para recovery.',
        'Paso 3 — Verificar si el fabricante proporciona una página de recovery '
            'de firmware (ej. modo TFTP): consultar la documentación oficial del '
            'modelo específico.',
        'Paso 4 — Si el equipo tiene fusibles accesibles (revisibles con '
            'multímetro en modo continuidad), verificar si alguno está abierto '
            '(sin continuidad) y reemplazarlo con el mismo amperaje.',
        'Paso 5 — Documentar el número de serie y modelo antes de enviarlo a '
            'servicio técnico autorizado. Solicitar diagnóstico escrito.',
      ],
      escalationThreshold: 0.50,
    ),
    Hypothesis(
      id: 'electrical_overload',
      label: 'Sobrecarga eléctrica / disyuntor disparado',
      description:
          'El circuito eléctrico al que está conectado el equipo está sobrecargado '
          'y el disyuntor (breaker) se disparó, cortando la energía. También puede '
          'ser una regleta sobrecargada o con protección térmica activada.',
      recommendedActions: [
        'Paso 1 — Verificar en el tablero eléctrico si algún breaker está en '
            'posición intermedia (ni ON ni OFF del todo): eso indica que se disparó. '
            'Bajarlo completamente y volver a subirlo.',
        'Paso 2 — Revisar la regleta o UPS: algunos tienen un botón de "reset" '
            'de protección térmica que debe presionarse después de una sobrecarga.',
        'Paso 3 — Calcular la carga total del circuito: sumar los vatios de todos '
            'los equipos conectados y comparar con la capacidad del breaker '
            '(ej. breaker de 20A × 120V = 2400W máximo, usar máximo 80% = 1920W).',
        'Paso 4 — Distribuir equipos en diferentes circuitos o fases eléctricas '
            'para balancear la carga.',
        'Paso 5 — Si el breaker se dispara repetidamente, hay un cortocircuito en '
            'el cableado o un equipo defectuoso en el circuito. Desconectar los '
            'equipos uno a uno hasta identificar el causante.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'ups_battery_failure',
      label: 'Batería de UPS agotada o dañada',
      description:
          'La batería interna del UPS superó su vida útil (2–3 años típicamente) '
          'o sufrió un daño por calor o descarga profunda. El UPS puede encender '
          'pero no sostener la carga ante un corte de energía.',
      recommendedActions: [
        'Paso 1 — Revisar el panel frontal del UPS: si hay LED o alarma de '
            '"Replace Battery" o "BATT", la batería debe cambiarse.',
        'Paso 2 — Conectar el UPS a la energía sin carga (desconectar todos los '
            'equipos) y dejarlo cargar 8 horas; luego desconectar la energía '
            'principal y medir cuánto tiempo sostiene la carga del panel.',
        'Paso 3 — Si el tiempo de autonomía es menor al 50% de las especificaciones '
            'del fabricante, la batería está degradada y debe reemplazarse.',
        'Paso 4 — Al reemplazar la batería, usar exactamente el mismo voltaje '
            '(ej. 12V) y capacidad en Ah igual o superior a la original. '
            'Verificar la polaridad antes de conectar.',
        'Paso 5 — Después del reemplazo, dejar el UPS cargando 12 horas antes '
            'de poner equipos críticos en línea.',
        'Paso 6 — Actualizar el firmware del UPS si el fabricante tiene versiones '
            'recientes: puede mejorar la gestión de batería.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'wrong_voltage_region',
      label: 'Incompatibilidad de voltaje / región eléctrica',
      description:
          'El equipo está configurado para una tensión eléctrica diferente a la '
          'de la instalación (ej. equipo de 220V conectado a 110V o viceversa). '
          'También ocurre con adaptadores universales en voltaje incorrecto.',
      recommendedActions: [
        'Paso 1 — Revisar la etiqueta de especificaciones eléctricas del equipo '
            '(usualmente al fondo o en el panel trasero): verificar el rango '
            'de voltaje aceptado (ej. 100–240V o solo 120V).',
        'Paso 2 — Medir el voltaje del tomacorriente con un multímetro en AC: '
            'en Colombia/Latinoamérica debería ser ~110–127V AC, en Europa ~220–240V.',
        'Paso 3 — Si el equipo tiene un selector de voltaje físico (switch '
            'pequeño cerca de la entrada de poder), verificar que esté en la '
            'posición correcta para la región.',
        'Paso 4 — Si el equipo no es compatible con el voltaje local, usar un '
            'transformador de aislamiento o regulador de voltaje apropiado.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'power_strip_trip',
      label: 'Regleta o PDU terciaria disparada / quemada',
      description:
          'La fuente de poder y el UPS están bien, pero la regleta (multitoma) '
          'intermedia donde se conecta el equipo se ha quemado o su mini-breaker '
          'térmico ha saltado.',
      recommendedActions: [
        'Paso 1 — Identificar si el equipo está conectado directamente a la pared, '
            'a un UPS, o mediante una regleta/multitoma de extensión.',
        'Paso 2 — Si hay una regleta, revisar si tiene un pequeño botón de RESET '
            'o un switch con luz. Si la luz está apagada, encenderla o presionar RESET.',
        'Paso 3 — Desconectar el equipo de la regleta y conectarlo temporalmente '
            'directo al tomacorriente de pared para aislar la regleta sospechosa.',
        'Paso 4 — Reemplazar regletas genéricas por PDUs de grado industrial o '
            'con supresor de picos certificado para evitar que micro-cortos la bloqueen.',
        'Paso 5 — Medir la continuidad de la regleta con multímetro desenchufada '
            'para confirmar si el cable interno está fracturado por tirones.',
      ],
      escalationThreshold: 0.25,
    ),
    Hypothesis(
      id: 'ups_inverter_fault',
      label: 'Falla del inversor del UPS (suena pero no da voltaje)',
      description:
          'El UPS recibe energía, la batería retiene carga y el panel enciende, '
          'pero el circuito inversor interno está dañado y no entrega 110V/220V '
          'a las salidas de respaldo.',
      recommendedActions: [
        'Paso 1 — Conectar un probador de voltaje o un cargador de celular '
            'simple a los tomas traseros marcados como "Battery Backup".',
        'Paso 2 — Desconectar el UPS de la pared simulando un corte. Si el UPS '
            'pita indicando que entró en batería pero el probador se apaga '
            'inmediatamente: el inversor está muerto.',
        'Paso 3 — Mudar los cables temporalmente a las tomas marcadas como '
            '"Surge Only" (si el UPS está enchufado a la pared) para mantener '
            'los equipos encendidos mientras se tramita la garantía.',
        'Paso 4 — Apagar el UPS por completo, dejar presionado el botón de '
            'encendido por 10 segundos buscando un hard-reset de la tarjeta lógica.',
        'Paso 5 — El equipo debe ser retirado; extraer la batería para reciclaje '
            'y enviar la tarjeta lógica del UPS a disposición final/reparación autorizada.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'access_battery_backup',
      label: 'Batería de control de acceso drenando voltaje (carga parasitaria)',
      description:
          'El panel de control de acceso tiene una batería de respaldo de ácido-plomo '
          'en corto interno que chupa todo el voltaje de la fuente principal, '
          'tumbando o reiniciando la placa base.',
      recommendedActions: [
        'Paso 1 — Abrir la caja metálica del panel de acceso remoto y localizar '
            'la batería grande de respaldo (típicamente 12V 4Ah o 7Ah).',
        'Paso 2 — Desconectar los terminales F2/F1 (Rojo y Negro) de la batería '
            'y alejarlos de cualquier metal.',
        'Paso 3 — Esperar 10 segundos y verificar si la tarjeta principal revive '
            'o sus LEDs comienzan a parpadear de forma estable.',
        'Paso 4 — Tocar suavemente el exterior de la batería. Si está hinchada, '
            'agrietada o inusualmente tibia al tacto, está en corto circuito.',
        'Paso 5 — Reemplazar la batería de 12V e instalar los terminales. '
            'Medir voltaje de flotación de la placa (debería mandar ~13.5V a '
            'la batería para recarga).',
      ],
      escalationThreshold: 0.35,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // CONNECTIVITY ISSUE — "Sin conexión"
  // ══════════════════════════════════════════════════════
  'connectivity_issue': const [
    Hypothesis(
      id: 'ip_conflict',
      label: 'Conflicto de dirección IP',
      description:
          'Dos o más equipos en la red comparten la misma dirección IP, causando '
          'que ambos pierdan conectividad intermitentemente. Ocurre cuando el DHCP '
          'asigna una IP que ya tiene un equipo con IP estática mal configurada.',
      recommendedActions: [
        'Paso 1 — En el equipo afectado, ejecutar "ipconfig" (Windows) o '
            '"ip addr" (Linux) y anotar la IP actual.',
        'Paso 2 — Desde otro equipo en la misma red, ejecutar "arp -a" y buscar '
            'si hay dos entradas con la misma IP pero distinta MAC: eso confirma conflicto.',
        'Paso 3 — Acceder a la interfaz web del router/switch y revisar la '
            'tabla DHCP: identificar si hay una IP asignada dos veces.',
        'Paso 4 — Asignar al equipo conflictivo una IP estática fuera del rango '
            'DHCP (ej. si DHCP usa 192.168.1.100–200, usar 192.168.1.50).',
        'Paso 5 — Configurar el DHCP con reservas por MAC address para '
            'dispositivos críticos como cámaras y NVR, evitando conflictos futuros.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'cable_network_failure',
      label: 'Falla de cable de red',
      description:
          'El cable UTP tiene un daño físico, mal crimpado, o supera los 100m. '
          'Es la causa más frecuente y solucionable. Un cable con un par abierto '
          'puede dar conectividad intermitente o velocidad reducida.',
      recommendedActions: [
        'Paso 1 — Conectar el cable a un tester de red: todos los pines 1–8 deben '
            'encender en secuencia. Si alguno falla, hay un corte o mal crimpado.',
        'Paso 2 — Inspeccionar ambos conectores RJ45 bajo luz: los 8 alambres '
            'deben verse ordenados y llegar hasta el extremo del conector.',
        'Paso 3 — Reemplazar temporalmente por un patchcord conocido como bueno '
            'para verificar si el problema desaparece.',
        'Paso 4 — Si el cable está dentro de paredes/conduit y no se puede '
            'reemplazar de inmediato, instalar un switch intermediario en la '
            'mitad del recorrido si la longitud supera los 90m.',
        'Paso 5 — Documentar el tendido del cable afectado en el plano de red '
            'para programar su reemplazo preventivo.',
      ],
      escalationThreshold: 0.25,
    ),
    Hypothesis(
      id: 'switch_port_failure',
      label: 'Puerto del switch dañado o deshabilitado',
      description:
          'El puerto físico del switch está dañado, deshabilitado por política '
          'de seguridad (port security), o en estado de error-disabled por '
          'detección de bucle (STP) o violación de MAC.',
      recommendedActions: [
        'Paso 1 — Conectar el equipo a un puerto diferente del switch y verificar '
            'si la conectividad se restaura.',
        'Paso 2 — Desde la consola del switch, ejecutar "show interfaces fa0/X" '
            '(Cisco) o equivalente: verificar si el puerto está "err-disabled".',
        'Paso 3 — Si el puerto está "err-disabled", ejecutar "shutdown" y luego '
            '"no shutdown" para resetear el estado del puerto.',
        'Paso 4 — Verificar si el switch tiene "Port Security" habilitado: '
            'si el equipo fue reemplazado, la nueva MAC puede estar bloqueada.',
        'Paso 5 — Revisar los LEDs del switch: LED ámbar constante en un puerto '
            'indica que STP bloqueó el puerto por detección de bucle.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'misconfiguration',
      label: 'Mala configuración IP / VLAN / DNS',
      description:
          'La configuración de red del equipo tiene parámetros incorrectos: '
          'IP fuera del segmento, máscara errónea, gateway incorrecto o DNS '
          'no configurado. También incluye configuración de VLAN incorrecta en el switch.',
      recommendedActions: [
        'Paso 1 — En el equipo afectado, verificar: dirección IP, máscara de '
            'subred, puerta de enlace y DNS. Comparar con un equipo que sí funciona '
            'en el mismo segmento.',
        'Paso 2 — Hacer ping a la puerta de enlace (ej. 192.168.1.1): si no '
            'responde, el problema es la IP/gateway. Si responde, el problema '
            'puede ser DNS o routing.',
        'Paso 3 — Hacer ping a 8.8.8.8 (Google DNS): si responde pero no hay '
            'navegación web, el problema es DNS. Cambiar el DNS a 8.8.8.8 o 1.1.1.1.',
        'Paso 4 — Si el equipo está en una VLAN específica, verificar en el '
            'switch que el puerto esté en el modo correcto (access/trunk) y '
            'en la VLAN correcta.',
        'Paso 5 — Verificar que el servidor DHCP esté operativo: reiniciar el '
            'servicio DHCP o asignar IP estática temporalmente para aislar el problema.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'gateway_failure',
      label: 'Falla del router / gateway',
      description:
          'El router o dispositivo de gateway no está enrutando tráfico '
          'correctamente. Puede estar reiniciando por calor, con tabla de '
          'enrutamiento corrupta, o con la interfaz WAN caída.',
      recommendedActions: [
        'Paso 1 — Verificar el LED de la interfaz WAN del router: debe estar '
            'encendido o parpadeando. Si está apagado, hay un problema con el '
            'enlace del proveedor.',
        'Paso 2 — Reiniciar el router (apagar 30 segundos, encender) y esperar '
            '2 minutos antes de probar conectividad.',
        'Paso 3 — Desde un PC conectado directamente al router, hacer ping '
            'a la IP WAN y a 8.8.8.8. Si falla el ping a 8.8.8.8, el problema '
            'es el enlace WAN o el ISP.',
        'Paso 4 — Contactar al ISP con el número de ticket generado. Solicitar '
            'verificación de señal en el modem/ONT.',
        'Paso 5 — Si el router tiene configuración NAT o firewall, verificar '
            'que las reglas no estén bloqueando tráfico interno.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'firewall_blocking',
      label: 'Bloqueo por firewall o ACL',
      description:
          'Una regla de firewall, lista de control de acceso (ACL) o política '
          'de seguridad está bloqueando el tráfico del equipo. Muy común '
          'después de cambios de red o actualizaciones de firmware.',
      recommendedActions: [
        'Paso 1 — Verificar si el equipo puede hacer ping a la puerta de enlace '
            'pero no acceder a servicios específicos: eso apunta a bloqueo por firewall.',
        'Paso 2 — Revisar las reglas del firewall o ACL en el router/switch: '
            'buscar reglas que bloqueen la IP o MAC del equipo afectado.',
        'Paso 3 — Temporalmente, deshabilitar el firewall o crear una regla de '
            'permiso temporal para la IP del equipo y verificar si se restaura la conectividad.',
        'Paso 4 — Revisar el log del firewall para ver si aparecen paquetes '
            'rechazados desde la IP del equipo.',
        'Paso 5 — Si el equipo fue recientemente movido a otra subred o VLAN, '
            'actualizar las reglas del firewall para la nueva ubicación.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'wifi_interference',
      label: 'Interferencia o cobertura WiFi insuficiente',
      description:
          'Si el equipo se conecta por WiFi, la señal puede ser débil por '
          'distancia, paredes, interferencia de otros dispositivos o saturación '
          'del canal inalámbrico.',
      recommendedActions: [
        'Paso 1 — Verificar la potencia de señal WiFi en el equipo: debe estar '
            'por encima de -70 dBm para conexión confiable. Debajo de -80 dBm '
            'la conexión será inestable.',
        'Paso 2 — Usar una app de análisis WiFi para ver qué canales están '
            'saturados en 2.4 GHz y cambiar el AP a un canal menos congestionado '
            '(1, 6 o 11 en 2.4 GHz).',
        'Paso 3 — Si hay muchos equipos WiFi conectados al mismo AP, considerar '
            'instalar un AP adicional o usar la banda de 5 GHz para equipos '
            'cercanos (mayor velocidad, menor alcance).',
        'Paso 4 — Verificar que el equipo no esté usando el mismo canal que '
            'redes WiFi vecinas: la interferencia co-canal reduce significativamente '
            'el rendimiento.',
        'Paso 5 — Para dispositivos críticos de videovigilancia, usar siempre '
            'conexión cableada en lugar de WiFi cuando sea posible.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'dirty_ethernet_port',
      label: 'Puerto de red o conector RJ45 sucio o sulfatado',
      description:
          'Los pines de cobre internos del puerto hembra RJ45 o del conector '
          'macho están cubiertos de polvo, telarañas o pátina verde (sulfatación '
          'por humedad), causando falsos contactos LAN o interrupción del PoE.',
      recommendedActions: [
        'Paso 1 — Desconectar el cable RJ45 del equipo e inspeccionar visualmente '
            'con una linterna el fondo del puerto. Buscar 8 pelos de cobre alineados '
            'y libres de pátina o suciedad.',
        'Paso 2 — Si hay corrosión o polvo prensado, usar limpia-contactos '
            'dieléctrico en spray (nunca agua ni WD-40 normal) aplicando un chorro '
            'directo al puerto apagado.',
        'Paso 3 — Frotar iterativamente conectando y desconectando el cable '
            'varias veces para arrancar mecánicamente la sulfatación de los pines.',
        'Paso 4 — Inspeccionar también la cabeza plástica RJ45 (macho). Si el oro '
            'de las cuchillas se ve negro u opaco, cortar y ponchar un plug nuevo.',
        'Paso 5 — Si la instalación es en exterior sin la protección IP correcta '
            '(prensaestopas pasacables), sellar finalmente con cinta vulcanizante.',
      ],
      escalationThreshold: 0.20,
    ),
    Hypothesis(
      id: 'mac_filtering_locked',
      label: 'Bloqueo por seguridad MAC (Port Security)',
      description:
          'El equipo fue cambiado recientemente por mantenimiento, pero el switch '
          'administrable bloqueó el puerto automáticamente porque detectó una '
          'dirección MAC no autorizada diferente a la original.',
      recommendedActions: [
        'Paso 1 — Indagar cronológicamente si el equipo final (Cámara, PC o Biométrico) '
            'acaba de ser reemplazado por otro nuevo en la misma roseta/cable.',
        'Paso 2 — Revisar el comportamiento del LED del switch en ese puerto. '
            'En Cisco y Fortinet, un LED naranja/rojo fijo repentino significa '
            'infracción de Port-Security (err-disable state).',
        'Paso 3 — Acceder a la consola del switch y listar las violaciones '
            '(Show port-security address). Tomar la nueva MAC Address del dispositivo '
            'e ingresarla a la lista blanca.',
        'Paso 4 — Limpiar la tabla ARP antigua del router/core y aplicar un '
            'comando de reseteo del puerto: "shutdown" seguido de "no shutdown".',
        'Paso 5 — Si no era equipo nuevo, validar si alguien clonó o está haciendo '
            'MAC Spoofing en la red corporativa.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'dhcp_pool_exhausted',
      label: 'Agotamiento del pool DHCP (Saturación de IP)',
      description:
          'La red no puede dar más direcciones IP a los equipos debido a que el '
          'rango (Pool DHCP) fue llenado por visitantes temporales, celulares '
          'o porque la concesión (Lease Time) es demasiado larga y no recicla IPs.',
      recommendedActions: [
        'Paso 1 — Si los equipos pre-existentes fijos tienen red pero los equipos '
            'nuevos o reiniciados se quedan sin IP (obteniendo APIPA 169.254.x.x), '
            'la sospecha de DHCP es absoluta.',
        'Paso 2 — Entrar en la interfaz del Router/Firewall y revisar las '
            '"Estadísticas DHCP" o "DHCP Leases". Si el contador "Free" está en 0, '
            'estamos sin IP.',
        'Paso 3 — Bajar el tiempo de concesión (DHCP Lease Time) de 24 horas a '
            '2-4 horas (o 30 minutos para redes de invitados como hoteles/aeropuertos).',
        'Paso 4 — Modificar la máscara de subred para ampliar el Scope o limpiar '
            'manualmente las concesiones expiradas atoradas (Clear DHCP bindings).',
        'Paso 5 — Sugerencia: pasar todas las cámaras, controladoras e impresoras '
            'a IP Fija (Static) fuera del rango del pool, para que no compitan.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'loopback_storm',
      label: 'Tormenta de broadcast (Bucle de red en switch)',
      description:
          'Alguien conectó por accidente ambos extremos de un solo cable de red '
          'a dos puertos del mismo switch, o puenteó dos switches redundantes '
          'sin protección Spanning-Tree (STP), hundiendo toda la red local.',
      recommendedActions: [
        'Paso 1 — Observar todos los LEDs de los switches. Si parpadean locamente, '
            'al unísono y a una frecuencia vertiginosa generalizada: ¡hay un bucle activo!',
        'Paso 2 — Todos los equipos perderán ping al mismo tiempo en el edificio. '
            'Empezar a desconectar cables uno a uno visualmente en el panel '
            'mientras se hace PING sostenido al router.',
        'Paso 3 — Identificar si hay mini-switches tontos (unmanaged) debajo de '
            'los escritorios (cascada) donde los usuarios mezclan sus conexiones.',
        'Paso 4 — Activar de inmediato la protección BPDU Guard y RSTP (Rapid '
            'Spanning Tree) en la administración de todos los switches corporativos '
            '(para evitar que se repita en el futuro).',
        'Paso 5 — Aislar el dispositivo causante (una vez descubierto) e instruir '
            'al personal sobre no manipular cables no etiquetados.',
      ],
      escalationThreshold: 0.25,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // DISPLAY ISSUE — "Imagen borrosa / sin video"
  // ══════════════════════════════════════════════════════
  'display_issue': const [
    Hypothesis(
      id: 'lens_focus',
      label: 'Problema de enfoque del lente',
      description:
          'El anillo de enfoque del lente está mal calibrado, causando imagen '
          'borrosa o fuera de foco. Ocurre después de instalación nueva, vibración '
          'o si se manipuló el lente sin bloquearlo después.',
      recommendedActions: [
        'Paso 1 — Acceder a la imagen en tiempo real desde el NVR o la interfaz '
            'web de la cámara para ver claramente el estado del enfoque.',
        'Paso 2 — Localizar el anillo de enfoque en el lente (marcado como FOCUS). '
            'Girarlo lentamente en ambas direcciones mientras se observa la imagen.',
        'Paso 3 — Si la cámara tiene función de enfoque automático (AF), activarla '
            'desde el menú de configuración de imagen del NVR o app del fabricante.',
        'Paso 4 — Verificar que el vidrio del domo no esté rayado ni tenga '
            'humedad en el interior: la condensación produce efecto de desenfoque '
            'que no se puede corregir ajustando el lente.',
        'Paso 5 — Si es un lente varifocal motorizado (zoom remote), ajustar también '
            'el anillo de zoom (ZOOM) antes de ajustar el enfoque: zoom primero, '
            'enfoque después.',
      ],
      escalationThreshold: 0.25,
    ),
    Hypothesis(
      id: 'dirty_lens',
      label: 'Lente o domo sucio / con humedad',
      description:
          'El lente o el domo de la cámara está sucio, empañado o con condensación '
          'interna. La suciedad en el lente provoca imagen borrosa uniforme; la '
          'condensación interna crea manchas o velo en la imagen.',
      recommendedActions: [
        'Paso 1 — Limpiar el exterior del domo con un paño de microfibra limpio '
            '(seco o ligeramente humedecido con agua destilada). Nunca usar '
            'solventes agresivos que puedan rayar el domo.',
        'Paso 2 — Si hay empañamiento interno (condensación dentro del domo), '
            'abrir el domo y verificar si el sello de silicona está roto o deteriorado.',
        'Paso 3 — Revisar si la cámara tiene bolsas desecantes (gel de sílice) '
            'internas: si están saturadas (color rosado/azul oscuro), reemplazarlas.',
        'Paso 4 — Sellar correctamente el domo con silicona neutra aprobada para '
            'electrónica después de la limpieza interna.',
        'Paso 5 — En cámaras tipo bullet o PTZ exteriores, limpiar también el '
            'parasol (sunshield) para evitar reflexión de luz que cause sobreexposición.',
      ],
      escalationThreshold: 0.20,
    ),
    Hypothesis(
      id: 'ir_failure',
      label: 'Falla de LEDs infrarrojos (visión nocturna)',
      description:
          'Los LEDs IR de la cámara no encienden correctamente, causando imagen '
          'completamente negra o muy oscura en la noche. Puede ser falla del sensor '
          'de luz (fotoresistor) o quemadura de los LEDs IR.',
      recommendedActions: [
        'Paso 1 — Cubrir el sensor de luz de la cámara con la mano o un objeto '
            'oscuro: si los LEDs IR encienden, el sensor funciona. Si no encienden, '
            'hay falla en los LEDs o el circuito IR.',
        'Paso 2 — Verificar en el menú de la cámara si el modo IR está en '
            '"Auto" o "Manual". Si está en Manual-OFF, cambiarlo a Auto.',
        'Paso 3 — Limpiar los LEDs IR con un paño suave y seco: la acumulación '
            'de suciedad puede bloquear la emisión infrarroja.',
        'Paso 4 — Actualizar el firmware de la cámara: algunos fabricantes '
            'corrigen bugs de control IR en actualizaciones de firmware.',
        'Paso 5 — Si los LEDs IR están físicamente oscuros o tienen manchas '
            'quemadas visibles, el hardware requiere reparación en servicio técnico.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'signal_degradation',
      label: 'Degradación de señal analógica (coaxial)',
      description:
          'En sistemas DVR/analógicos, la señal de video se degrada por cables '
          'coaxiales de longitud excesiva, conectores BNC oxidados, o interferencia '
          'electromagnética de cables de potencia cercanos.',
      recommendedActions: [
        'Paso 1 — Medir la longitud del cable coaxial: RG59 soporta hasta 300m '
            'en CVBS, RG6 hasta 400m. Si se supera, instalar un amplificador de '
            'señal de video (distribuidor activo).',
        'Paso 2 — Inspeccionar los conectores BNC en ambos extremos: desconectar '
            'y reconectar para romper oxidación. Si hay corrosión visible, '
            'reemplazar el conector BNC.',
        'Paso 3 — Verificar que el cable coaxial no esté tendido paralelo a '
            'cables de alimentación eléctrica (genera interferencia). Mantener '
            'al menos 5cm de separación o usar cable blindado.',
        'Paso 4 — Para sistemas HD-CVI/TVI/AHD, verificar que el tipo de cable '
            'coaxial sea compatible (RG59 o RG6, no RG58 delgado).',
        'Paso 5 — Si hay baluns instalados para video sobre UTP, verificar que '
            'sean de la misma marca y calidad en ambos extremos.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'nvr_output_failure',
      label: 'Falla en salida HDMI/VGA del NVR',
      description:
          'El NVR no envía señal de video al monitor. Puede ser el cable HDMI/VGA '
          'dañado, la configuración de resolución de salida incompatible, o la '
          'salida de video del NVR defectuosa.',
      recommendedActions: [
        'Paso 1 — Probar con un cable HDMI o VGA diferente: los cables HDMI '
            'de baja calidad pueden fallar sin señal visible de daño.',
        'Paso 2 — Conectar el NVR a otro monitor para descartar que el monitor '
            'original sea el problema.',
        'Paso 3 — Si al encender el NVR el monitor muestra el logo de arranque '
            'pero luego se apaga, el problema es la resolución configurada. '
            'Mantener presionado el botón de resolución del NVR 5 segundos para '
            'resetear a resolución base (1080p/720p).',
        'Paso 4 — Verificar en la configuración del NVR (si es accesible remotamente) '
            'la resolución y frecuencia de salida: debe coincidir con las '
            'especificaciones del monitor.',
        'Paso 5 — Si el NVR tiene salida HDMI y VGA simultáneas, probar con '
            'ambas para identificar cuál falla.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'overexposure_backlight',
      label: 'Sobreexposición o contraluz excesivo',
      description:
          'La imagen de la cámara aparece muy brillante o con zonas quemadas '
          'por exceso de luz. Esto ocurre cuando el punto de instalación tiene '
          'una fuente de luz intensa de fondo (ventanas, luces directas).',
      recommendedActions: [
        'Paso 1 — Evaluar si la cámara está apuntando directamente a una ventana, '
            'bombilla o fuente de luz: reposicionarla o reorientarla si es posible.',
        'Paso 2 — Activar la función WDR (Wide Dynamic Range) o BLC (Back Light '
            'Compensation) en la configuración de imagen de la cámara.',
        'Paso 3 — Ajustar manualmente el nivel de exposición y ganancia en el '
            'menú de imagen de la cámara/NVR.',
        'Paso 4 — Si la sobreexposición ocurre solo de noche, verificar si los '
            'LEDs IR están reflejando en una pared o superficie brillante cercana: '
            'alejar la cámara de la pared o reducir la potencia IR.',
        'Paso 5 — Para cámaras sin WDR, instalar un parasol o visera adicional '
            'para bloquear la fuente de luz problemática.',
      ],
      escalationThreshold: 0.25,
    ),
    Hypothesis(
      id: 'physical_damage',
      label: 'Daño físico o golpe severo (Óptica/Sensor dañado)',
      description:
          'La cámara ha recibido un golpe físico por vandalismo, caída, o aves. '
          'Esto puede desfasar lentes internos, romper el cristal frontal creando '
          'aberraciones (líneas, rayas torcidas) o desplazar el sensor CMOS.',
      recommendedActions: [
        'Paso 1 — Observar en físico si la carcasa exterior tiene hundimientos, '
            'si el cristal está estrellado, agrietado o apuntando al suelo suelto.',
        'Paso 2 — Si la imagen se ve cruzada con grietas fijas oscuras que '
            'nunca se mueven, el cristal dome está fisurado ante la lente.',
        'Paso 3 — Destapar la carcasa (si es seguro) para ver si el módulo del '
            'lente se desprendió de los pines internos del circuito impreso principal.',
        'Paso 4 — Las líneas de colores (verdes, moradas) completamente congeladas '
            'y ruidosas suelen indicar un golpe que fracturó o desoldó el chip CMOS.',
        'Paso 5 — Reemplazar el equipo documentando el siniestro, ya que los daños '
            'en placas o celdas CMOS rara vez son rentables de resoldar o cambiar.',
      ],
      escalationThreshold: 0.20,
    ),
    Hypothesis(
      id: 'sensor_burn_ir_reflection',
      label: 'Sensor quemado (Láser/Sol) o Reflejo Ciego IR',
      description:
          'Líneas rectas moradas/negras permanentes significan láser/sol que ha '
          'quemado de por vida el sensor de imagen. Si falla solo de noche viéndose '
          'blanca fantasmal, es el domo ciego reflejando sus propios rayos IR.',
      recommendedActions: [
        'Paso 1 — Identidad del daño: Línea vertical / punto negro fijo en todo '
            'momento -> Quemadura láser. No reparable, sensor freído.',
        'Paso 2 — Identidad de reflejo (Solo nocturno): Al tapar el aro de goma '
            'negra (gasket) de la lente del domo interior, la luz IR rebota al cristal.',
        'Paso 3 — Desmontar el cristal domo exterior de plástico, limpiarlo interna '
            'y externamente. Asegurar que el anillo de espuma del lente toque firmemente '
            'el domo contra reflejos perimetrales al tapar.',
        'Paso 4 — Remover plásticos y calcomanías de fábrica que nunca se quitaron '
            'del lente y que durante meses causan destellos borrosos.',
        'Paso 5 — Si no es reflejo de noche, sino falla persistente diurna por '
            'quemadura de hardware CMOS, retirar cámara para reciclaje electrónico.',
      ],
      escalationThreshold: 0.25,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // AUDIO ISSUE — "Ruido extraño / problema de sonido"
  // ══════════════════════════════════════════════════════
  'audio_issue': const [
    Hypothesis(
      id: 'hdd_failure',
      label: 'Falla del disco duro (ruido mecánico)',
      description:
          'El disco duro del NVR/DVR está fallando y emite ruidos de clic, '
          'rasguño o golpeteo. Estos sonidos indican falla inminente del cabezal '
          'o platos del disco. Requiere acción inmediata.',
      recommendedActions: [
        'Paso 1 — Acceder al menú de estado del disco en el NVR: buscar la '
            'sección "HDD Info" o "Storage" y revisar el estado SMART del disco.',
        'Paso 2 — Si el SMART reporta errores de sectores reasignados o de '
            'lectura/escritura, el disco está en fase de falla: hacer backup '
            'inmediato de las grabaciones críticas.',
        'Paso 3 — Apagar el NVR correctamente, esperar 2 minutos y encender: '
            'escuchar si el sonido de clic desaparece. Si persiste, el disco '
            'tiene daño mecánico.',
        'Paso 4 — Reemplazar el disco por uno certificado para videovigilancia '
            '(WD Purple, Seagate SkyHawk): estos discos están diseñados para '
            'escritura continua 24/7.',
        'Paso 5 — Verificar la temperatura del disco en el menú del NVR: '
            'debe estar por debajo de 55°C. Si supera esta temperatura, '
            'mejorar la ventilación del gabinete.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'fan_failure',
      label: 'Falla o desgaste del ventilador',
      description:
          'El ventilador del NVR, DVR, UPS o switch emite ruido excesivo '
          'por desgaste de los rodamientos o por acumulación de polvo que '
          'bloquea las aspas.',
      recommendedActions: [
        'Paso 1 — Identificar qué equipo emite el ruido apagando o alejando '
            'el oído de cada uno por separado.',
        'Paso 2 — Con el equipo encendido (cuidado), limpiar las rejillas '
            'de ventilación con aire comprimido en spray (latas para electrónica), '
            'dirigiendo el aire hacia afuera del equipo.',
        'Paso 3 — Apagar el equipo y verificar manualmente que el ventilador '
            'gire libremente sin resistencia. Un ventilador trabado genera '
            'ruido de motor.',
        'Paso 4 — Si el ruido persiste después de la limpieza, el rodamiento '
            'del ventilador está desgastado: reemplazar el ventilador por uno '
            'del mismo voltaje y dimensiones (ej. 12V DC, 80mm).',
        'Paso 5 — Asegurarse de que el equipo tenga espacio de al menos 10cm '
            'a los lados y atrás para ventilación adecuada después del reemplazo.',
      ],
      escalationThreshold: 0.25,
    ),
    Hypothesis(
      id: 'ups_battery_noise',
      label: 'Batería de UPS agotada (pitido de alarma)',
      description:
          'El UPS emite pitidos continuos o intermitentes indicando batería baja, '
          'falla de batería o sobrecarga. El patrón de pitidos varía por fabricante '
          'e indica distintos problemas.',
      recommendedActions: [
        'Paso 1 — Consultar el manual del UPS para identificar qué significa '
            'el patrón de pitidos (ej. 4 pitidos cada 30s = batería baja en APC).',
        'Paso 2 — Verificar el panel LCD del UPS (si tiene): mostrará un código '
            'de error específico que indica el tipo de falla.',
        'Paso 3 — Conectar el UPS sin carga de equipos y verificar si el pitido '
            'cesa: si cesa, hay sobrecarga. Si continúa, la batería está fallando.',
        'Paso 4 — Revisar la antigüedad de la batería: si tiene más de 2 años '
            'en uso continuo, reemplazarla preventivamente.',
        'Paso 5 — Algunos UPS permiten silenciar la alarma temporalmente desde '
            'el panel frontal mientras se gestiona el reemplazo de batería.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'ups_overload',
      label: 'Sobrecarga del UPS (alarma activa)',
      description:
          'El UPS está conectado a más carga (watts/VA) de la que puede soportar, '
          'activando la alarma de sobrecarga. Si no se corrige, el UPS puede '
          'apagarse abruptamente cortando la energía a todos los equipos.',
      recommendedActions: [
        'Paso 1 — Verificar el LED o indicador de sobrecarga en el panel del UPS '
            '(generalmente un LED rojo o ícono de rayo).',
        'Paso 2 — Calcular la carga total: sumar el consumo en Watts de todos los '
            'equipos conectados. La carga no debe superar el 80% de la capacidad '
            'del UPS (ej. UPS de 1000VA/600W → máximo 480W).',
        'Paso 3 — Desconectar equipos no críticos del UPS (monitores, impresoras) '
            'hasta que la alarma de sobrecarga desaparezca.',
        'Paso 4 — Redistribuir equipos usando una regleta convencional para los '
            'equipos que no necesitan respaldo (monitores, teclados).',
        'Paso 5 — Si la carga legitima supera la capacidad, instalar un UPS '
            'adicional de mayor capacidad o reemplazar el actual.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'equipment_overheating',
      label: 'Sobrecalentamiento (ventilador a máxima velocidad)',
      description:
          'El equipo supera su temperatura de operación normal, causando que '
          'el ventilador funcione a máxima velocidad generando ruido. Ocurre '
          'por ventilación insuficiente, ambiente caliente o polvo obstruyendo las rejillas.',
      recommendedActions: [
        'Paso 1 — Verificar la temperatura del cuarto técnico: debe estar entre '
            '18°C y 27°C según ASHRAE. Si está sobre 30°C, el equipo trabajará '
            'con el ventilador al máximo permanentemente.',
        'Paso 2 — Revisar que el equipo no esté instalado con los laterales '
            'tapados: necesita al menos 1U de espacio libre arriba y abajo en el rack.',
        'Paso 3 — Limpiar las rejillas de entrada y salida de aire con aire '
            'comprimido. En NVR/DVR de escritorio, limpiar también el interior '
            'con especial cuidado alrededor del procesador.',
        'Paso 4 — Verificar la temperatura interna desde el menú del equipo '
            '(si está disponible) y comparar con la temperatura máxima del '
            'fabricante (típicamente 40–55°C).',
        'Paso 5 — Si el gabinete es cerrado, instalar bandejas de ventilación '
            'forzada (rack fan) para extracción de aire caliente por la parte superior.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'ground_loop_audio',
      label: 'Interferencia de bucle a tierra (audio/video)',
      description:
          'Zumbido de 60Hz o líneas de interferencia en pantalla causadas por '
          'diferencia de potencial entre equipos conectados a distintos circuitos '
          'eléctricos o sin adecuada puesta a tierra.',
      recommendedActions: [
        'Paso 1 — Verificar si el zumbido o interferencia desaparece al '
            'desconectar el cable de video/audio entre los equipos: si desaparece, '
            'es un bucle a tierra.',
        'Paso 2 — Conectar todos los equipos del sistema al mismo circuito '
            'eléctrico y el mismo punto de tierra cuando sea posible.',
        'Paso 3 — Instalar un aislador de bucle a tierra (ground loop isolator) '
            'en el cable de video o audio afectado.',
        'Paso 4 — Verificar que el UPS tenga conexión a tierra correcta: un UPS '
            'sin tierra puede inducir ruido en toda la instalación.',
        'Paso 5 — En instalaciones con baluns de video sobre UTP, usar baluns '
            'con aislamiento galvánico para eliminar el bucle a tierra.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'ups_bypass_mode',
      label: 'UPS bloqueado en Modo Bypass / Relay atorado',
      description:
          'El UPS está encendido y tiene un ruido de sirena constante o clic seco, '
          'pero no respalda porque un corto interno provocó que el relé principal '
          'quede "pegado" tirando toda la protección al desvío directo de AC.',
      recommendedActions: [
        'Paso 1 — Fijarse en el display LED principal del UPS. Si está rotulado '
            'como "Bypass On" "Fault" o un diagrama dibujando una línea recta de '
            'entrada a salida.',
        'Paso 2 — Cortar suministro, el equipo de atrás se apagará también. El Bypass '
            'significa que su batería y regulación están inertes temporalmente por '
            'falla trágica de sobrecalentamiento/hardware.',
        'Paso 3 — Despejar todo el polvo del UPS e intentar dejarlo enfriando apagado '
            '1 hora e intentar reiniciarlo. Muchos circuitos ByPass se liberan.',
        'Paso 4 — Si el ruido "clic-clac" rápido suena en el UPS sin estabilizarse, '
            'es el relé de transferencia averiado. Debe repararse electrónicamente.',
        'Paso 5 — Cambiar de toma a la pared los servidores inmediatamente porque '
            'permanecen sin filtrado transitorio.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'socket_ground_fault',
      label: 'Defecto de toma mural a tierra / Ruido fantasma',
      description:
          'La pared donde está enchufado el NVR o gabinete genera arcos ruidosos, '
          'chispas audibles dentro de la caja o carece de la 3ra clavija (polo '
          'tierra), retransmitiendo inducción estática al chasis de metal o audio.',
      recommendedActions: [
        'Paso 1 — Acercar el oído a la roseta/toma eléctrica de la pared. Si '
            'vibra tipo chicharra asimétrica ("fritura"), hay falso contacto suelto.',
        'Paso 2 — Usar un probador de tomas (Receptacle Tester de 3 LEDs) para '
            'ver si la tierra está ausente o si Neutro/Fase están invertidos.',
        'Paso 3 — Desconectar de inmediato si huele a ozono (pescado quemado), es '
            'fuego latente atrás del plástico del enchufe.',
        'Paso 4 — Reparar la roseta abriendo y atornillando bien el neutro y tierra. '
            'No cortar el tercer pin (tierra) de los cables de poder jamás.',
        'Paso 5 — En racks grandes, instalar una barra cobrizada sólida y '
            'amarrar un cable AWG 8 a la estructura del piso.',
      ],
      escalationThreshold: 0.30,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // CAMERA ISSUE — "Cámara falla / no graba"
  // ══════════════════════════════════════════════════════
  'camera_issue': const [
    Hypothesis(
      id: 'stream_config_error',
      label: 'Error de configuración de stream RTSP/ONVIF',
      description:
          'El protocolo de video, puerto, credenciales o resolución del stream '
          'son incorrectos. Ocurre frecuentemente al agregar cámaras de terceros '
          'a un NVR de diferente fabricante.',
      recommendedActions: [
        'Paso 1 — Acceder a la interfaz web de la cámara directamente con su IP '
            '(en navegador: http://IP_CAMARA) y verificar el stream RTSP '
            'configurado (ruta, puerto, usuario y contraseña).',
        'Paso 2 — En el NVR, al agregar la cámara manualmente verificar: '
            'protocolo (ONVIF/RTSP), IP, puerto (usualmente 554 para RTSP u '
            '80/8000 para ONVIF), usuario y contraseña correctos.',
        'Paso 3 — Probar el stream con VLC Player: ir a "Abrir de red" y '
            'escribir rtsp://usuario:contraseña@IP_CAMARA:554/stream1 para '
            'confirmar que el stream funciona fuera del NVR.',
        'Paso 4 — Restablecer la configuración de stream de la cámara a valores '
            'por defecto desde su interfaz web y reconfigurar.',
        'Paso 5 — Verificar la compatibilidad ONVIF: algunos dispositivos '
            'requieren habilitar ONVIF explícitamente en la configuración de '
            '"Servicios de red" de la cámara.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'storage_full',
      label: 'Almacenamiento lleno o disco dañado en NVR',
      description:
          'El disco del NVR está lleno (sin grabación en bucle) o tiene '
          'sectores defectuosos que impiden la escritura. La cámara puede verse '
          'en vivo pero no grabar.',
      recommendedActions: [
        'Paso 1 — Acceder al menú de almacenamiento del NVR: verificar el '
            'porcentaje de uso del disco. Si está al 100%, habilitar sobrescritura '
            '(overwrite/loop recording) en la configuración.',
        'Paso 2 — Revisar el estado SMART del disco en el NVR: ir a '
            '"Mantenimiento > HDD Info" y verificar que el estado sea "Normal".',
        'Paso 3 — Formatear el disco desde el menú del NVR si el estado SMART '
            'reporta errores corregibles (no en caso de errores críticos).',
        'Paso 4 — Verificar que las cámaras tengan programación de grabación '
            'correcta: si el horario de grabación está deshabilitado o mal '
            'configurado, el NVR no grabará aunque el disco esté libre.',
        'Paso 5 — Si el disco tiene errores graves, reemplazarlo y formatear '
            'el nuevo desde el menú del NVR antes de asignar cámaras.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'ptz_config_error',
      label: 'Error de configuración PTZ / RS-485',
      description:
          'El control PTZ no funciona porque el protocolo, la dirección o la '
          'velocidad de baudios del bus RS-485 no coinciden entre la cámara y el DVR.',
      recommendedActions: [
        'Paso 1 — Verificar en la cámara PTZ (etiqueta o menú DIP switches) '
            'el protocolo configurado: Pelco-D, Pelco-P, ONVIF u otro.',
        'Paso 2 — En el DVR, ir a configuración de PTZ del canal correspondiente '
            'y asegurarse de que el protocolo, la dirección (ID) y la velocidad '
            'de baudios (9600 para Pelco-D por defecto) coincidan exactamente.',
        'Paso 3 — Verificar el cableado RS-485: los terminales A(+) y B(-) '
            'deben estar correctamente conectados en ambos extremos. '
            'Un cable invertido evita el control PTZ.',
        'Paso 4 — Si hay múltiples cámaras PTZ en el bus RS-485, verificar '
            'que cada una tenga una dirección única (1, 2, 3, etc.) y que '
            'haya resistencia de terminación de 120Ω en el último dispositivo.',
        'Paso 5 — Para PTZ IP (ONVIF), asegurarse de que la cámara esté '
            'agregada correctamente en el NVR con sus credenciales.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'camera_not_discovered',
      label: 'Cámara IP no descubierta por el NVR',
      description:
          'El NVR no detecta la cámara IP en el escaneo de red automático. '
          'Puede ser por diferente segmento de red, ONVIF deshabilitado, o '
          'credenciales por defecto cambiadas.',
      recommendedActions: [
        'Paso 1 — Verificar que la cámara está en el mismo segmento de red '
            'que el NVR: ambos deben tener IPs del mismo rango '
            '(ej. NVR: 192.168.1.100, Cámara: 192.168.1.101).',
        'Paso 2 — Usar la herramienta de búsqueda de IPs del fabricante '
            '(ej. SADP para Hikvision, IP Finder para Dahua) para localizar '
            'la cámara y ajustar su IP si es necesario.',
        'Paso 3 — Agregar la cámara manualmente en el NVR: ingresar IP, '
            'protocolo, puerto, usuario y contraseña directamente.',
        'Paso 4 — Verificar que el servicio ONVIF esté habilitado en la '
            'cámara (menú de Servicios de red en la interfaz web de la cámara).',
        'Paso 5 — Si la cámara fue reseteada de fábrica, las credenciales '
            'por defecto suelen ser admin/admin o admin/12345: '
            'actualizar las credenciales después de agregarla al NVR.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'camera_power_failure',
      label: 'Falla de alimentación eléctrica de la cámara',
      description:
          'La cámara no recibe alimentación eléctrica adecuada: PoE insuficiente, '
          'adaptador DC defectuoso o cable de alimentación con falla.',
      recommendedActions: [
        'Paso 1 — Verificar el LED de encendido de la cámara: si no enciende '
            'ningún LED, la cámara no está recibiendo energía.',
        'Paso 2 — Probar con otro puerto PoE del switch o con un inyector PoE '
            'independiente para descartar el puerto del switch.',
        'Paso 3 — Si la cámara usa adaptador DC, medir el voltaje de salida '
            'del adaptador con multímetro: debe coincidir ±5% con el voltaje '
            'indicado en la etiqueta.',
        'Paso 4 — Verificar que el estándar PoE del switch sea compatible '
            'con la cámara (revisarlo en las especificaciones del modelo).',
        'Paso 5 — Revisar el cable UTP para PoE: si el par de alimentación '
            'tiene continuidad pero alta resistencia, la caída de voltaje '
            'puede ser insuficiente para la cámara en cables largos.',
      ],
      escalationThreshold: 0.30,
    ),
    Hypothesis(
      id: 'firmware_bug',
      label: 'Bug de firmware / malfunction por software',
      description:
          'La cámara o el NVR tiene un comportamiento anómalo causado por '
          'un bug en la versión de firmware instalada. Se manifiesta con '
          'cierres inesperados, pérdida de configuración o funciones que no responden.',
      recommendedActions: [
        'Paso 1 — Realizar un reinicio del equipo desde el menú de administración '
            '(no desconectar la energía abruptamente): ir a "Mantenimiento > Reiniciar".',
        'Paso 2 — Consultar el sitio web del fabricante y verificar si existe '
            'una actualización de firmware disponible para el modelo exacto.',
        'Paso 3 — Descargar el firmware oficial y actualizarlo desde el menú '
            '"Mantenimiento > Actualización de firmware". NUNCA usar firmware '
            'de un modelo diferente aunque sea de la misma marca.',
        'Paso 4 — Si el problema persiste después de la actualización, realizar '
            'un restablecimiento de fábrica y reconfigurar el equipo.',
        'Paso 5 — Documentar el comportamiento anómalo (fecha, hora, descripción) '
            'y reportar al soporte técnico del fabricante si el bug persiste '
            'en la última versión de firmware.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'hdd_sata_fault',
      label: 'Falla del Bus SATA / Cableado interno del DVR',
      description:
          'El DVR arroja pitos de alarma de disco duro pero el disco duro se ha '
          'probado y está sano. La verdadera causa es el cable de datos planito '
          '(SATA) interno o su línea de poder desoldada por vibraciones.',
      recommendedActions: [
        'Paso 1 — Retirar los tornillos de la tapa del NVR/DVR. Ubicar el cable '
            'SATA plano (usualmente rojo o negro) que va de PCB al HDD.',
        'Paso 2 — Retirarlo y limpiar conectores. Muchos cables SATA de fábrica '
            'fallan a los meses por torsión. Reemplazarlo por un cable tipo clip.',
        'Paso 3 — Extraer también el conector cuadradito de cables de colores '
            '(molex-SATA de alimentación) y volverlo a clavar firme en el disco duro.',
        'Paso 4 — Si la placa NVR tiene doble puerto SATA, probar mudando el disco '
            'duro e ingresando un nuevo cable al puerto secundario.',
        'Paso 5 — Si tras colocar cables nuevos, conectores firmes, el DVR '
            'sigue "No Detectando Storage/0MB", la controladora sur de la placa base '
            'murió y requiere reemplazar hardware NVR.',
      ],
      escalationThreshold: 0.25,
    ),
    Hypothesis(
      id: 'camera_mount_loose',
      label: 'Basculamiento o Base floja (Vibración excesiva/Movimiento Roto)',
      description:
          'A través de la cámara domo o PTZ se ve que la imagen pierde foco '
          'sistemáticamente o se desencaja por culpa de las vibraciones del '
          'tránsito, viento u obras contiguas, dando el falso síntoma de PTZ Roto a software.',
      recommendedActions: [
        'Paso 1 — Ir al mástil o brazo de soporte exterior de la cámara para '
            'ejercer apalancamiento suave. ¿Tiembla o suena metal?',
        'Paso 2 — Muchos problemas de motorización "PTZ" donde no sigue recorridos '
            'ocurre por base desajustada soltando la corona de plástico que alinea el eje.',
        'Paso 3 — Desmontar el collarín, reapretar chazos u anclajes plásticos '
            'con pernos, poner arandelas de resorte.',
        'Paso 4 — En cámaras LPR (Lectura placa de auto) es letal. Reubicar mástil a un '
            'suelo libre de vibraciones vehiculares pesadas.',
        'Paso 5 — Solo tras asegurar su fijación pétrea, usar el menú de la interfaz '
            '"PTZ Calibration" / Restablecer topes mecánicos.',
      ],
      escalationThreshold: 0.20,
    ),
  ],

  // ══════════════════════════════════════════════════════
  // OTHER ISSUE — "Otro problema"
  // ══════════════════════════════════════════════════════
  'other_issue': const [
    Hypothesis(
      id: 'hardware_fault',
      label: 'Falla de hardware (componente físico)',
      description:
          'Componente físico del equipo dañado por golpe, sobretensión eléctrica, '
          'humedad o desgaste natural. Puede ser un conector, placa secundaria '
          'o componente electrónico puntual.',
      recommendedActions: [
        'Paso 1 — Inspeccionar visualmente el equipo buscando señales de daño: '
            'quemaduras, condensadores abombados, conectores doblados, '
            'piezas sueltas o marcas de humedad.',
        'Paso 2 — Verificar todos los cables de conexión interna (si el equipo '
            'permite abrirse de forma segura): cables de datos y alimentación '
            'al disco duro, ventilador y placa principal.',
        'Paso 3 — Probar los módulos reemplazables por separado: cambiar el '
            'disco, la memoria (si aplica) o la fuente de poder por unidades '
            'conocidas como buenas.',
        'Paso 4 — Documentar el número de serie, modelo y descripción exacta '
            'del problema antes de enviar a servicio técnico.',
        'Paso 5 — Solicitar presupuesto de reparación por escrito al servicio '
            'técnico: si el costo supera el 60% del equipo nuevo, evaluar reemplazo.',
      ],
      escalationThreshold: 0.50,
    ),
    Hypothesis(
      id: 'software_firmware_config',
      label: 'Error de firmware / configuración de sistema',
      description:
          'La configuración del sistema, firmware desactualizado o parámetros '
          'incorrectos causan el mal funcionamiento. Es más común después de '
          'cortes de energía abruptos o actualizaciones fallidas.',
      recommendedActions: [
        'Paso 1 — Revisar los logs del sistema en el menú "Mantenimiento > Logs": '
            'buscar errores recurrentes o eventos en el momento del problema.',
        'Paso 2 — Actualizar el firmware del equipo a la versión más reciente '
            'estable disponible en el sitio oficial del fabricante.',
        'Paso 3 — Si el comportamiento es errático después de una actualización, '
            'verificar si el fabricante publicó un rollback o versión anterior.',
        'Paso 4 — Realizar un restablecimiento de fábrica ("Default") y '
            'reconfigurar el equipo desde cero: exportar la configuración '
            'actual antes si el equipo lo permite.',
        'Paso 5 — Implementar un UPS para proteger el equipo de cortes de energía '
            'abruptos que corrompen la configuración o el firmware.',
      ],
      escalationThreshold: 0.45,
    ),
    Hypothesis(
      id: 'environmental_factor',
      label: 'Factor ambiental (temperatura / humedad / polvo)',
      description:
          'Condiciones ambientales adversas afectan el rendimiento o vida útil '
          'del equipo: temperatura alta, humedad excesiva, polvo acumulado o '
          'vibración constante en el entorno de instalación.',
      recommendedActions: [
        'Paso 1 — Medir la temperatura del cuarto técnico con un termómetro: '
            'el rango ideal es 18–24°C. Temperaturas sobre 30°C reducen '
            'significativamente la vida útil de los componentes electrónicos.',
        'Paso 2 — Medir la humedad relativa: debe estar entre 40–60% RH. '
            'Por encima del 80% hay riesgo de condensación y corrosión.',
        'Paso 3 — Verificar que los gabinetes o racks tengan grado de protección '
            'adecuado para el entorno: IP65/IP66 para exteriores o ambientes con polvo.',
        'Paso 4 — Realizar limpieza preventiva de polvo en todos los equipos '
            'del gabinete cada 3 meses en ambientes industriales o con mucho polvo.',
        'Paso 5 — Instalar aire acondicionado de precisión en el cuarto técnico '
            'o bandejas de ventilación forzada en el rack para controlar la temperatura.',
      ],
      escalationThreshold: 0.40,
    ),
    Hypothesis(
      id: 'access_credentials_error',
      label: 'Credenciales de acceso incorrectas o bloqueadas',
      description:
          'No es posible acceder al equipo porque la contraseña fue cambiada, '
          'el usuario fue bloqueado por múltiples intentos fallidos, '
          'o las credenciales por defecto nunca fueron configuradas correctamente.',
      recommendedActions: [
        'Paso 1 — Verificar si el equipo tiene un período de bloqueo por '
            'intentos fallidos: esperar 5–30 minutos y volver a intentar '
            'con las credenciales correctas.',
        'Paso 2 — Consultar el inventario de contraseñas del proyecto: '
            'muchas organizaciones documentan las credenciales de acceso '
            'en el momento de la instalación.',
        'Paso 3 — Intentar con las credenciales por defecto del fabricante '
            '(documentadas en el manual): admin/admin, admin/12345, etc.',
        'Paso 4 — Si la contraseña fue olvidada definitivamente, realizar '
            'el proceso de recuperación de contraseña del fabricante: '
            'algunos requieren fecha de exportación de configuración, '
            'otros un código GUID del dispositivo.',
        'Paso 5 — Como último recurso, hacer reset de fábrica (botón físico): '
            'esto borrará toda la configuración y grabaciones del equipo.',
      ],
      escalationThreshold: 0.35,
    ),
    Hypothesis(
      id: 'remote_access_failure',
      label: 'Falla de acceso remoto (P2P / puerto)',
      description:
          'El sistema funciona localmente pero no es accesible de forma remota '
          'desde la app móvil o navegador externo. Problema de reenvío de puertos, '
          'IP dinámica o servicio P2P no activo.',
      recommendedActions: [
        'Paso 1 — Verificar primero que el sistema funcione correctamente '
            'en la red local (LAN): si no funciona localmente, el problema no '
            'es de acceso remoto.',
        'Paso 2 — Comprobar si el servicio P2P/Cloud del NVR está habilitado '
            'y conectado: en el menú de red debe aparecer "Online" o con ícono verde.',
        'Paso 3 — Si usa reenvío de puertos (Port Forwarding) en el router, '
            'verificar que los puertos del NVR (80, 8000, 554 típicamente) '
            'estén redirigidos correctamente a la IP interna del NVR.',
        'Paso 4 — Si la IP pública es dinámica (cambia periódicamente), '
            'configurar un servicio DDNS (ej. DynDNS, No-IP, o el DDNS del '
            'propio fabricante) para mantener acceso estable.',
        'Paso 5 — Verificar con el ISP si el servicio contratado tiene IP '
            'pública dedicada o si está detrás de CG-NAT (Carrier-Grade NAT): '
            'el CG-NAT impide el acceso remoto por port forwarding.',
      ],
      escalationThreshold: 0.45,
    ),
    Hypothesis(
      id: 'access_strike_jammed',
      label: 'Cerradura o torniquete electromecánico atascado (Click / No apertura)',
      description:
          'La controladora da paso, se oye el click del relé, pero la barrera '
          'vehicular, torniquete u chapa de puerta se rehúsa a empujar físicamente.',
      recommendedActions: [
        'Paso 1 — Empujar fuertemente la puerta hacia el marco (contra el pestillo) '
            'y pedir que "abran". Muchas chapas eléctricas de cilindro están '
            'prensadas por presión de viento/peso y empujarlas libera el motor.',
        'Paso 2 — Bajar al suelo del electroimán y certificar alineación de la placa. '
            'Un margen asimétrico detiene la atracción, aflojar placa pivote con llave '
            'Alen central para darle margen de movimiento.',
        'Paso 3 — En barreras vehiculares automáticas, pasarla a modo manual '
            'con manija roja rotatoria y detectar resistencia u obstrucción en el muelle.',
        'Paso 4 — Medir voltaje final depositado sobre terminal de chapa magnética. '
            '12V al salir no significa que llegue lo mismo. Si llegan <9V, el cable '
            'UTP trenzado está degradado en distancia.',
        'Paso 5 — Lubrique partes del resbalón o motor del torniquete con grasa '
            'lítica. (No wd40). Reemplace si piezas mecánicas están limadas.',
      ],
      escalationThreshold: 0.25,
    ),
    Hypothesis(
      id: 'reader_sensor_dirty',
      label: 'Lector Biométrico Ciego (Polvo / Rayones)',
      description:
          'El control de asistencia prende, está en red y pinguea bien, pero '
          'la luz de escaneo de huella/iris ignora a los usuarios causando falsos negativos continuos.',
      recommendedActions: [
        'Paso 1 — Humedecer alcohol isopropílico sobre hisopo y lavar profundamente '
            'el cristal de prisma del ojo biométrico huellero. Una capa sutil de gel '
            'graso humano obstaculiza refracción de luz óptica.',
        'Paso 2 — Revisarlo contra reflejos o sol picado directo del atardecer. '
            'Luz infrarroja intensa del sol inunda el sensor impidiendo perfilar las crestas '
            'de huellas. Taparlo y probar.',
        'Paso 3 — Entrar por software y buscar opción tipo "Sensor Adjust / Calibrate" '
            'para recálculo de opacidad base si es ZK u homólogos.',
        'Paso 4 — Si la placa plástica o de lector NFC acrílica presenta ranurado y rayas '
            'blancas profundas no funcionales, se requiere pulitura con químicos acrílicos '
            'o reemplazo de frontal plástico.',
        'Paso 5 — Subir tolerancia 1:N threshold (Nivel algorítmico) a más relajado tipo '
            '"35" o "40" si es sitio polvoriento y duro trabajador.',
      ],
      escalationThreshold: 0.20,
    ),
    Hypothesis(
      id: 'rs485_polarity_reversed',
      label: 'Bus esclavo RS485 o Protocolo Wiegand Invertido',
      description:
          'Lector secundario no permite abrir. Cables D0/D1 Wiegand, o RS-485 (TX/RX) '
          'apuntando al controlador fueron conectados chuecos durante un remiendo.',
      recommendedActions: [
        'Paso 1 — RS-485 se monta en cadena Margarita: Positivo al Positivo (D+) '
            'Negativo al Negativo (D-). Voltear e intentar; estos chips MAX485 '
            'suelen protegerse solos de polarizaciones inversas erradas.',
        'Paso 2 — Lector esclavo parpadea verde pero no abre el electroimán. En '
            'protocolos wiegand Data0 (Green) / Data1 (White) están cruzados llegando '
            'al panel base.',
        'Paso 3 — Medir Ohmios sobre cable RS485 (120 Ohm fin línea resistor) '
            'si es largo (miles metros), quizá falta impedancia final.',
        'Paso 4 — Destornillar los bornes de la bornera verde del Wiegand 2 o Reader, '
            'pelar cable nuevamente porque la prensa "pellizcó" el forro plástico aislante '
            'adrenal de cobre y rompió voltaje al panel de control maestro.',
        'Paso 5 — Verificar tarjeta maestra (Reader Format) configurada a "26 bit Wiegand" '
            'versus lecturas modernas de 34 bits del aparato lector.',
      ],
      escalationThreshold: 0.40,
    ),
  ],
};
