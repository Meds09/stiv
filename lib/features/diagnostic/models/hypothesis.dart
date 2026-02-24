/// Una hipótesis diagnóstica que el motor de inferencia evalúa durante
/// el flujo. Cada hipótesis representa una causa raíz probable.
class Hypothesis {
  const Hypothesis({
    required this.id,
    required this.label,
    required this.description,
    required this.recommendedActions,
    this.escalationThreshold = 0.40,
  });

  /// Identificador único de la hipótesis (ej: 'cable_failure').
  final String id;

  /// Nombre corto para mostrar en la UI (ej: 'Falla de cableado').
  final String label;

  /// Descripción más detallada de la causa.
  final String description;

  /// Lista de acciones sugeridas si esta hipótesis gana.
  final List<String> recommendedActions;

  /// Si la confianza máxima alcanzable es menor a este umbral,
  /// el sistema escala automáticamente a IA. (0.0 – 1.0)
  final double escalationThreshold;
}
