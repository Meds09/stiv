import 'package:stiv/features/diagnostic/models/hypothesis.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HIPÓTESIS DE CONTROL DE ACCESO — cerraduras, biométrico, RS485, cableado
// ─────────────────────────────────────────────────────────────────────────────

const accessOtherHypotheses = <Hypothesis>[
  Hypothesis(
    id: 'corrosion_failure',
    label: 'Contactos sulfatados o corroídos (cableado de acceso)',
    description:
        'Los terminales de alimentación, cerradura o lector del sistema de control de acceso tienen oxidación, sulfatación o corrosión que genera alta resistencia o interrupción intermitente del circuito. Es común en instalaciones expuestas a humedad, cambios de temperatura o entornos industriales.',
    recommendedActions: [
      'Paso 1 — Desconectar la energía del panel de acceso antes de inspeccionar cualquier borne o terminal.',
      'Paso 2 — Inspeccionar visualmente los bornes de alimentación (12V/GND), los terminales de la cerradura y los conectores del lector buscando manchas verdosas, blanquecinas o negras sobre el cobre.',
      'Paso 3 — Con un cepillo de cerdas metálicas o lija fina (800), limpiar suavemente los contactos oxidados hasta exponer el cobre brillante.',
      'Paso 4 — Aplicar spray dieléctrico o grasa conductora sobre los bornes limpios para prevenir nueva oxidación.',
      'Paso 5 — Si los cables están muy degradados o la oxidación penetró hacia el interior del conductor, cortar y reemplazar el segmento afectado con cable nuevo del mismo calibre.',
      'Paso 6 — Verificar que los bornes queden bien apretados; un borne flojo favorece la oxidación por micro-arcos eléctricos.',
    ],
    escalationThreshold: 0.20,
  ),
  Hypothesis(
    id: 'access_battery_backup',
    label: 'Batería de control de acceso drenando voltaje (carga parasitaria)',
    description:
        'El panel de control de acceso tiene una batería de respaldo de ácido-plomo en corto interno que chupa todo el voltaje de la fuente principal, tumbando o reiniciando la placa base.',
    recommendedActions: [
      'Paso 1 — Abrir la caja metálica del panel de acceso remoto y localizar la batería grande de respaldo (típicamente 12V 4Ah o 7Ah).',
      'Paso 2 — Desconectar los terminales F2/F1 (Rojo y Negro) de la batería y alejarlos de cualquier metal.',
      'Paso 3 — Esperar 10 segundos y verificar si la tarjeta principal revive o sus LEDs comienzan a parpadear de forma estable.',
      'Paso 4 — Tocar suavemente el exterior de la batería. Si está hinchada, agrietada o inusualmente tibia al tacto, está en corto circuito.',
      'Paso 5 — Reemplazar la batería de 12V e instalar los terminales. Medir voltaje de flotación de la placa (debería mandar ~13.5V a la batería para recarga).',
    ],
    escalationThreshold: 0.35,
  ),
  Hypothesis(
    id: 'access_strike_jammed',
    label: 'Cerradura o torniquete electromecánico atascado (Click / No apertura)',
    description:
        'La controladora da paso, se oye el click del relé, pero la barrera vehicular, torniquete u chapa de puerta se rehúsa a empujar físicamente.',
    recommendedActions: [
      'Paso 1 — Empujar fuertemente la puerta hacia el marco (contra el pestillo) y pedir que "abran". Muchas chapas eléctricas de cilindro están prensadas por presión de viento/peso y empujarlas libera el motor.',
      'Paso 2 — Bajar al suelo del electroimán y certificar alineación de la placa. Un margen asimétrico detiene la atracción, aflojar placa pivote con llave Alen central para darle margen de movimiento.',
      'Paso 3 — En barreras vehiculares automáticas, pasarla a modo manual con manija roja rotatoria y detectar resistencia u obstrucción en el muelle.',
      'Paso 4 — Medir voltaje final depositado sobre terminal de chapa magnética. 12V al salir no significa que llegue lo mismo. Si llegan <9V, el cable UTP trenzado está degradado en distancia.',
      'Paso 5 — Lubrique partes del resbalón o motor del torniquete con grasa lítica. (No wd40). Reemplace si piezas mecánicas están limadas.',
    ],
    escalationThreshold: 0.25,
  ),
  Hypothesis(
    id: 'reader_sensor_dirty',
    label: 'Lector Biométrico Ciego (Polvo / Rayones)',
    description:
        'El control de asistencia prende, está en red y pinguea bien, pero la luz de escaneo de huella/iris ignora a los usuarios causando falsos negativos continuos.',
    recommendedActions: [
      'Paso 1 — Humedecer alcohol isopropílico sobre hisopo y lavar profundamente el cristal de prisma del ojo biométrico huellero. Una capa sutil de gel graso humano obstaculiza refracción de luz óptica.',
      'Paso 2 — Revisarlo contra reflejos o sol picado directo del atardecer. Luz infrarroja intensa del sol inunda el sensor impidiendo perfilar las crestas de huellas. Taparlo y probar.',
      'Paso 3 — Entrar por software y buscar opción tipo "Sensor Adjust / Calibrate" para recálculo de opacidad base si es ZK u homólogos.',
      'Paso 4 — Si la placa plástica o de lector NFC acrílica presenta ranurado y rayas blancas profundas no funcionales, se requiere pulitura con químicos acrílicos o reemplazo de frontal plástico.',
      'Paso 5 — Subir tolerancia 1:N threshold (Nivel algorítmico) a más relajado tipo "35" o "40" si es sitio polvoriento y duro trabajador.',
    ],
    escalationThreshold: 0.20,
  ),
  Hypothesis(
    id: 'rs485_polarity_reversed',
    label: 'Bus esclavo RS485 o Protocolo Wiegand Invertido',
    description:
        'Lector secundario no permite abrir. Cables D0/D1 Wiegand, o RS-485 (TX/RX) apuntando al controlador fueron conectados chuecos durante un remiendo.',
    recommendedActions: [
      'Paso 1 — RS-485 se monta en cadena Margarita: Positivo al Positivo (D+) Negativo al Negativo (D-). Voltear e intentar; estos chips MAX485 suelen protegerse solos de polarizaciones inversas erradas.',
      'Paso 2 — Lector esclavo parpadea verde pero no abre el electroimán. En protocolos wiegand Data0 (Green) / Data1 (White) están cruzados llegando al panel base.',
      'Paso 3 — Medir Ohmios sobre cable RS485 (120 Ohm fin línea resistor) si es largo (miles metros), quizá falta impedancia final.',
      'Paso 4 — Destornillar los bornes de la bornera verde del Wiegand 2 o Reader, pelar cable nuevamente porque la prensa "pellizcó" el forro plástico aislante adrenal de cobre y rompió voltaje al panel de control maestro.',
      'Paso 5 — Verificar tarjeta maestra (Reader Format) configurada a "26 bit Wiegand" versus lecturas modernas de 34 bits del aparato lector.',
    ],
    escalationThreshold: 0.40,
  ),
];
