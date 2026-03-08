/// Contexto del diagnóstico que se inyecta al chat para personalizar la IA.
class AiChatContext {
  const AiChatContext({
    required this.deviceType,
    this.symptomLabel,
    required this.userName,
  });

  /// Categoría del dispositivo: "Control de Acceso", "CCTV", "Red", etc.
  final String deviceType;

  /// Síntoma seleccionado por el usuario (puede ser null si no completó el flujo).
  final String? symptomLabel;

  /// Nombre del técnico autenticado.
  final String userName;

  /// Construye un contexto vacío cuando no hay información de dispositivo.
  static const empty = AiChatContext(
    deviceType: 'No especificado',
    userName: 'Técnico',
  );
}
