import 'package:stiv/features/diagnostic/models/hypothesis.dart';

/// Nivel de confianza del resultado diagnóstico.
enum ConfidenceLevel {
  /// ≥ 75% — causa clara, acción directa.
  high,

  /// 50–74% — causa probable, verificar antes de actuar.
  medium,

  /// 30–49% — evidencia insuficiente, revisar manualmente.
  low,

  /// < 30% o hipótesis empatadas — escalar a IA.
  escalated,
}

/// Resultado estructurado que el motor de inferencia produce al
/// finalizar un flujo de diagnóstico.
class DiagnosticResult {
  const DiagnosticResult({
    required this.probableCause,
    required this.confidenceScore,
    required this.level,
    required this.recommendations,
    required this.allScores,
    required this.requiresAiEscalation,
    required this.symptomId,
  });

  /// La hipótesis ganadora (puede ser null si la evidencia es insuficiente).
  final Hypothesis? probableCause;

  /// Score normalizado de la hipótesis ganadora (0.0 – 1.0).
  final double confidenceScore;

  /// Nivel de confianza calculado.
  final ConfidenceLevel level;

  /// Acciones recomendadas (provenientes de la hipótesis ganadora, o genéricas).
  final List<String> recommendations;

  /// Mapa completo de scores por hypothesisId para mostrar ranking.
  final Map<String, double> allScores;

  /// Si es true, se debe mostrar la opción de escalar a IA.
  final bool requiresAiEscalation;

  /// ID del síntoma que originó este diagnóstico.
  final String symptomId;

  /// Devuelve el porcentaje de confianza (0–100).
  int get confidencePercent => (confidenceScore * 100).round();

  static ConfidenceLevel levelFromScore(double score) {
    if (score >= 0.75) return ConfidenceLevel.high;
    if (score >= 0.50) return ConfidenceLevel.medium;
    if (score >= 0.30) return ConfidenceLevel.low;
    return ConfidenceLevel.escalated;
  }
}
