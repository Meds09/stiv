import 'package:stiv/features/diagnostic/domain/evidence_accumulator.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';
import 'package:stiv/features/diagnostic/models/hypothesis.dart';

/// Motor de inferencia del flujo de diagnóstico DSS.
///
/// Dado el estado actual de evidencia y el historial de preguntas respondidas,
/// decide:
///   1. Si hay suficiente confianza para concluir el flujo.
///   2. Cuál es la siguiente pregunta más relevante a mostrar.
class InferenceEngine {
  const InferenceEngine({
    this.confidenceThreshold = 0.75,
  });

  /// Si la confianza supera este umbral, el flujo puede concluir. (0.0 – 1.0)
  final double confidenceThreshold;

  /// Retorna `true` si la evidencia acumulada es suficiente para concluir.
  bool shouldConclude(
    EvidenceAccumulator accumulator,
    List<Hypothesis> hypotheses,
  ) {
    final evaluation = accumulator.evaluate(hypotheses);
    return evaluation.confidence >= confidenceThreshold;
  }

  /// Selecciona la siguiente pregunta a presentar.
  ///
  /// Estrategia:
  ///   1. Si la opción seleccionada tiene `nextQuestionId`, se usa como primer
  ///      destino (respeta el árbol definido explícitamente).
  ///   2. De lo contrario, busca preguntas no respondidas DENTRO del mismo
  ///      sub-árbol ([allowedQuestionIds]) cuya evidencia sea relevante para las
  ///      hipótesis con mayor score actual.
  ///   3. Si no hay preguntas relevantes disponibles, retorna `null` (flujo completo).
  DiagnosticQuestion? nextQuestion({
    required List<DiagnosticQuestion> allQuestions,
    required Set<String> answeredIds,
    required EvidenceAccumulator accumulator,
    required List<Hypothesis> hypotheses,
    String? forcedNextId, // nextQuestionId de la opción seleccionada
    Set<String>? allowedQuestionIds, // conjunto de IDs de preguntas en la rama activa
  }) {
    // Fallback explícito — respeta el árbol original si está definido.
    if (forcedNextId != null) {
      try {
        return allQuestions.firstWhere((q) => q.id == forcedNextId);
      } catch (_) {
        // Si el ID no existe, continúa con la lógica dinámica.
      }
    }

    // Preguntas disponibles = no respondidas.
    var available =
        allQuestions.where((q) => !answeredIds.contains(q.id)).toList();

    // Filtramos las preguntas disponibles para que solo pregunten sobre
    // el contexto activo (el dispositivo seleccionado inicialmente).
    if (allowedQuestionIds != null && allowedQuestionIds.isNotEmpty) {
      available = available.where((q) => allowedQuestionIds.contains(q.id)).toList();
    }

    if (available.isEmpty) return null;

    // Obtiene las hipótesis activas (score > 0) ordenadas por score descendente.
    final activeHypothesisIds = accumulator.scores.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topHypothesisIds =
        activeHypothesisIds.take(2).map((e) => e.key).toSet();

    // Prioriza preguntas cuya evidencia impacte las hipótesis activas.
    if (topHypothesisIds.isNotEmpty) {
      final relevant = available.where((q) {
        return q.options.any((opt) =>
            opt.evidence.any((e) => topHypothesisIds.contains(e.hypothesisId)));
      }).toList();

      if (relevant.isNotEmpty) return relevant.first;
    }

    // Fallback: siguiente en el listado que no se haya respondido.
    return available.firstOrNull;
  }
}
