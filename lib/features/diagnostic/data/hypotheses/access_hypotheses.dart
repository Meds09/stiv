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
      'Paso 2 — Lector esclavo parpadea verde pero no abre el electroímán. En protocolos wiegand Data0 (Green) / Data1 (White) están cruzados llegando al panel base.',
      'Paso 3 — Medir Ohmios sobre cable RS485 (120 Ohm fin línea resistor) si es largo (miles metros), quizá falta impedancia final.',
      'Paso 4 — Destornillar los bornes de la bornera verde del Wiegand 2 o Reader, pelar cable nuevamente porque la prensa "pellizcó" el forro plástico aislante adrenal de cobre y rompió voltaje al panel de control maestro.',
      'Paso 5 — Verificar tarjeta maestra (Reader Format) configurada a "26 bit Wiegand" versus lecturas modernas de 34 bits del aparato lector.',
    ],
    escalationThreshold: 0.40,
  ),
  // ── Nuevas hipótesis de control de acceso ─────────────────────────────────────────────────────────────
  Hypothesis(
    id: 'access_schedule_error',
    label: 'Horario de acceso mal configurado o expirado',
    description:
        'El panel de acceso funciona correctamente pero los usuarios no pueden entrar porque el horario de acceso asignado a la zona, puerta o grupo de usuarios está deshabilitado, expirado o es incorrecto. Es la causa más frecuente de "credencial válida que no abre".',
    recommendedActions: [
      'Paso 1 — En el software de control de acceso, ir a Configuración > Horarios de Acceso. Verificar que el horario asignado a la puerta y/o grupo de usuarios incluya el día y la hora actual.',
      'Paso 2 — Revisar si la fecha de vigencia del horario o de las credenciales de usuario está vencida: buscar campos "Fecha de inicio" y "Fecha de fin" en el perfil de usuario.',
      'Paso 3 — Verificar que la puerta tenga un horario de acceso asignado: si el campo está vacío o en "Sin horario", la puerta no permitirá acceso en ningún momento.',
      'Paso 4 — Comprobar que el día de la semana actual esté incluido en el horario: muchos horarios están configurados solo para días hábiles y los fines de semana quedan bloqueados.',
      'Paso 5 — Sincronizar el horario del panel con el servidor NTP o ajustar manualmente la hora del controlador: una diferencia de hora entre el software y el panel puede causar denegaciones incorrectas.',
    ],
    escalationThreshold: 0.20,
  ),
  Hypothesis(
    id: 'antipassback_violation',
    label: 'Violación de Antipassback (APB) / Zona bloqueada',
    description:
        'El sistema detectó que un usuario intentó acceder a una zona sin haber registrado la salida correctamente (o viceversa). El antipassback bloquea el acceso hasta que se resuelva la violación.',
    recommendedActions: [
      'Paso 1 — En el software de acceso, buscar el indicador de violación de antipassback del usuario afectado (suele aparecer como un ícono o alerta en el perfil del usuario).',
      'Paso 2 — Limpiar la violación de antipassback desde el software: buscar la opción "Resetear APB", "Limpiar estado de zona" o "Liberar usuario" en el perfil del usuario.',
      'Paso 3 — Si muchos usuarios tienen la misma violación simultáneamente, puede deberse a un reinicio del servidor o panel que perdió el estado de zonas: hacer un reset global de APB.',
      'Paso 4 — Verificar la configuración de antipassback de la puerta: si está en modo "Estricto", no permitirá el acceso hasta que se resuelva. Cambiar a "Suave" solo envía una alerta pero permite el acceso.',
      'Paso 5 — Revisar que todos los lectores de entrada y salida de cada zona estén funcionando correctamente: si un lector de salida falla, los usuarios nunca registran la salida y quedan bloqueados.',
    ],
    escalationThreshold: 0.20,
  ),
  Hypothesis(
    id: 'lock_face_obstruction',
    label: 'Marco de puerta deformado / Hoja desalineada',
    description:
        'La puerta o el marco están físicamente deformados por temperatura, humedad o traslados, causando que la chapa electromagnética o el pestillo no hagan contacto completo con la superficie de fijación.',
    recommendedActions: [
      'Paso 1 — Inspeccionar visualmente el espacio entre la hoja de la puerta y el marco: si hay una separación irregular o si la hoja está torcida, hay desalineamiento.',
      'Paso 2 — Para electromagnéticas: medir con multímetro el voltaje en los terminales de la chapa al activar. Si el voltaje es correcto pero la chapa no retiene, la placa de contacto no está paralela.',
      'Paso 3 — Ajustar la posición de la placa de contacto (armature plate) de la chapa electromagnética: aflojar los tornillos de fijación y realinearla para maximizar el área de contacto.',
      'Paso 4 — Para cerraduras eléctricas de pestillo: lubricar el mecanismo con grasa neutra y verificar que el pestillo retraiga completamente al activar la corriente.',
      'Paso 5 — Si el problema persiste, instalar un ajustador de puerta (bracket de ajuste) o llamar a un cerrajero especializado para corregir el marco.',
    ],
    escalationThreshold: 0.25,
  ),
  Hypothesis(
    id: 'credential_not_enrolled',
    label: 'Tarjeta/Huella no enrolada o enrolada en otro panel',
    description:
        'Las credenciales (tarjetas RFID, huellas dactilares o PINs) no están registradas en el controlador local de acceso, o fueron registradas en un controlador diferente sin sincronización.',
    recommendedActions: [
      'Paso 1 — En el software, verificar si el usuario existe y si sus credenciales están asignadas al panel que controla la puerta afectada.',
      'Paso 2 — Revisar si la credencial fue registrada en otro servidor o panel: en sistemas multi-panel, las credenciales deben estar sincronizadas a todos los controladores.',
      'Paso 3 — Forzar una sincronización desde el software hacia el panel: buscar la opción "Sincronizar", "Descargar al panel" o "Cargar usuarios al dispositivo".',
      'Paso 4 — Si es una huella dactilar, verificar que la huella fue enrolada con la misma mano/dedo que el usuario está usando al intentar acceder.',
      'Paso 5 — En sistemas offline (sin servidor central), asegurarse de que los usuarios fueron exportados e importados correctamente al panel físico mediante la herramienta de configuración del fabricante.',
    ],
    escalationThreshold: 0.20,
  ),
];
