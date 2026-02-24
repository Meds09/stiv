import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_result.dart';
import 'package:stiv/features/diagnostic/models/hypothesis.dart';

/// Acumula evidencia a medida que el usuario responde preguntas.
///
/// Cada opción seleccionada puede aportar pesos positivos o negativos
/// a distintas hipótesis. Al final, [evaluate] calcula la hipótesis
/// dominante y normaliza la confianza.
class EvidenceAccumulator {
  EvidenceAccumulator();

  /// Copiar constructor para usar en Riverpod con states inmutables.
  EvidenceAccumulator.from(EvidenceAccumulator other)
      : _scores = Map.from(other._scores);

  // ignore: prefer_final_fields — mutable by design (addEvidence/removeEvidence)
  Map<String, double> _scores = {};

  /// Scores actuales (hypothesisId → score acumulado).
  Map<String, double> get scores => Map.unmodifiable(_scores);

  /// Acumula la evidencia de una lista de [EvidenceWeight].
  void addEvidence(List<EvidenceWeight> weights) {
    for (final w in weights) {
      _scores.update(
        w.hypothesisId,
        (v) => v + w.weight,
        ifAbsent: () => w.weight,
      );
    }
  }

  /// Elimina la evidencia previamente aportada por [weights].
  /// Útil al navegar hacia atrás (goBack) en el flujo.
  void removeEvidence(List<EvidenceWeight> weights) {
    for (final w in weights) {
      _scores.update(
        w.hypothesisId,
        (v) => v - w.weight,
        ifAbsent: () => 0,
      );
    }
  }

  /// Evalúa las hipótesis y retorna la ganadora con su nivel de confianza.
  ///
  /// La confianza se normaliza dividiendo el score del ganador entre la
  /// suma de todos los scores positivos (evita distorsión por negativos).
  ({Hypothesis? hypothesis, double confidence}) evaluate(
    List<Hypothesis> allHypotheses,
  ) {
    if (_scores.isEmpty) return (hypothesis: null, confidence: 0.0);

    // Filtra solo scores con valor positivo para la normalización.
    final positives = _scores.entries.where((e) => e.value > 0).toList();
    if (positives.isEmpty) return (hypothesis: null, confidence: 0.0);

    final totalPositive = positives.fold(0.0, (acc, e) => acc + e.value);

    final best = positives.reduce((a, b) => a.value > b.value ? a : b);
    final confidence = totalPositive == 0 ? 0.0 : best.value / totalPositive;

    final winner = allHypotheses.cast<Hypothesis?>().firstWhere(
          (h) => h?.id == best.key,
          orElse: () => null,
        );

    return (hypothesis: winner, confidence: confidence);
  }

  /// Construye un [DiagnosticResult] completo dado las hipótesis disponibles.
  DiagnosticResult buildResult({
    required List<Hypothesis> allHypotheses,
    required String symptomId,
  }) {
    final evaluation = evaluate(allHypotheses);
    final winner = evaluation.hypothesis;
    final score = evaluation.confidence;
    final level = DiagnosticResult.levelFromScore(score);

    final recommendations = winner?.recommendedActions ??
        const ['Contactar soporte técnico especializado.'];

    return DiagnosticResult(
      probableCause: winner,
      confidenceScore: score,
      level: level,
      recommendations: recommendations,
      allScores: Map.from(_scores),
      requiresAiEscalation: level == ConfidenceLevel.escalated ||
          (winner != null && score < winner.escalationThreshold),
      symptomId: symptomId,
    );
  }

  /// Limpia todos los scores acumulados.
  void reset() => _scores.clear();
}
