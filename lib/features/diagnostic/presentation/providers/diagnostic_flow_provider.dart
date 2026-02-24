import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/diagnostic/data/diagnostic_questions_data.dart';
import 'package:stiv/features/diagnostic/data/hypotheses_data.dart';
import 'package:stiv/features/diagnostic/domain/evidence_accumulator.dart';
import 'package:stiv/features/diagnostic/domain/inference_engine.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_result.dart';
import 'package:stiv/features/diagnostic/models/hypothesis.dart';

/// Número máximo de preguntas que el flujo puede hacer antes de concluir.
const int _maxQuestions = 7;

/// Estado inmutable del flujo de diagnóstico DSS.
class DiagnosticFlowState {
  final String symptomId;
  final List<DiagnosticQuestion> questions;
  final List<Hypothesis> hypotheses;
  final List<String> questionHistory; // pila de IDs visitados
  final Map<String, String> selectedAnswers; // questionId → optionId
  final String? currentQuestionId;
  final bool isComplete;
  final EvidenceAccumulator accumulator;
  final DiagnosticResult? result;
  /// Historial de confianza de las últimas N respuestas (para anti-oscilación).
  final List<double> confidenceHistory;
  /// Conjunto de IDs de preguntas permitidas en el sub-árbol activo.
  /// Se captura al elegir el dispositivo inicial para aislar el contexto
  /// del motor dinámico y evitar que mezcle preguntas de otras ramas (NVR vs UPS).
  final Set<String>? allowedQuestionIds;

  const DiagnosticFlowState({
    required this.symptomId,
    required this.questions,
    required this.hypotheses,
    this.questionHistory = const [],
    this.selectedAnswers = const {},
    this.currentQuestionId,
    this.isComplete = false,
    required this.accumulator,
    this.result,
    this.confidenceHistory = const [],
    this.allowedQuestionIds,
  });

  /// Número máximo de preguntas en el flujo.
  int get totalSteps => _maxQuestions;

  /// Número de preguntas ya respondidas (0-based → 0 al inicio).
  int get answeredCount => selectedAnswers.length;

  /// Paso actual visible en la UI (1-based, clamped a totalSteps).
  int get currentStep => (answeredCount + 1).clamp(1, totalSteps);

  /// Pregunta actual (o null si ya terminó el flujo).
  DiagnosticQuestion? get currentQuestion {
    if (currentQuestionId == null) return null;
    try {
      return questions.firstWhere((q) => q.id == currentQuestionId);
    } catch (_) {
      return null;
    }
  }

  /// Opción actualmente seleccionada para la pregunta actual.
  String? get currentSelectedOptionId =>
      currentQuestionId != null ? selectedAnswers[currentQuestionId] : null;

  /// Progreso estimado (0.0 – 1.0) basado en pasos respondidos vs. máximo.
  double get progress =>
      (answeredCount / totalSteps).clamp(0.0, 1.0);

  /// Verdadero si la opción actualmente seleccionada es un nodo hoja
  /// (según el esquema clásico nextQuestionId == null).
  bool get isCurrentSelectionLeaf {
    final q = currentQuestion;
    final optId = currentSelectedOptionId;
    if (q == null || optId == null) return false;
    try {
      final option = q.options.firstWhere((o) => o.id == optId);
      return option.nextQuestionId == null;
    } catch (_) {
      return false;
    }
  }

  /// Verdadero si está en la primera pregunta (ninguna respondida aún).
  bool get isFirstQuestion => answeredCount == 0;

  DiagnosticFlowState copyWith({
    String? symptomId,
    List<DiagnosticQuestion>? questions,
    List<Hypothesis>? hypotheses,
    List<String>? questionHistory,
    Map<String, String>? selectedAnswers,
    String? currentQuestionId,
    bool? isComplete,
    EvidenceAccumulator? accumulator,
    DiagnosticResult? result,
    List<double>? confidenceHistory,
    Set<String>? allowedQuestionIds,
    bool clearAllowedIds = false,
  }) {
    return DiagnosticFlowState(
      symptomId: symptomId ?? this.symptomId,
      questions: questions ?? this.questions,
      hypotheses: hypotheses ?? this.hypotheses,
      questionHistory: questionHistory ?? this.questionHistory,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      currentQuestionId: currentQuestionId ?? this.currentQuestionId,
      isComplete: isComplete ?? this.isComplete,
      accumulator: accumulator ?? this.accumulator,
      result: result ?? this.result,
      confidenceHistory: confidenceHistory ?? this.confidenceHistory,
      allowedQuestionIds: clearAllowedIds ? null : (allowedQuestionIds ?? this.allowedQuestionIds),
    );
  }
}

/// Notifier que gestiona la lógica del flujo de diagnóstico DSS.
class DiagnosticFlowNotifier extends StateNotifier<DiagnosticFlowState> {
  DiagnosticFlowNotifier(String symptomId)
      : super(_initialState(symptomId));

  static const _engine = InferenceEngine(confidenceThreshold: 0.75);

  static DiagnosticFlowState _initialState(String symptomId) {
    final questions = diagnosticQuestionTrees[symptomId] ?? [];
    final hypotheses = hypothesesBySymptom[symptomId] ?? [];
    final firstId = questions.isNotEmpty ? questions.first.id : null;
    return DiagnosticFlowState(
      symptomId: symptomId,
      questions: questions,
      hypotheses: hypotheses,
      questionHistory: firstId != null ? [firstId] : [],
      currentQuestionId: firstId,
      accumulator: EvidenceAccumulator(),
    );
  }

  /// Selecciona una opción y avanza automáticamente.
  ///
  /// Retorna `true` si el flujo se completó.
  bool selectAndAdvance(String optionId) {
    final qId = state.currentQuestionId;
    if (qId == null) return false;

    // 1. Encontrar la opción seleccionada
    final currentQ = state.currentQuestion;
    if (currentQ == null) return false;

    QuestionOption? selectedOption;
    try {
      selectedOption = currentQ.options.firstWhere((o) => o.id == optionId);
    } catch (_) {
      return false;
    }

    // 2. Registrar la respuesta
    final newAnswers = {...state.selectedAnswers, qId: optionId};

    // 3. Acumular evidencia
    final newAccumulator = EvidenceAccumulator.from(state.accumulator);
    if (selectedOption.evidence.isNotEmpty) {
      newAccumulator.addEvidence(selectedOption.evidence);
    }

    // 4. Detectar sub-árbol activo (solo en la primera respuesta).
    // Extraemos todos los IDs de preguntas alcanzables desde la opción seleccionada.
    Set<String>? newAllowedIds = state.allowedQuestionIds;
    if (newAllowedIds == null && selectedOption.nextQuestionId != null) {
      // Si es la primera pregunta (ninguna respuesta previa), capturamos el sub-árbol completo.
      newAllowedIds = _extractSubtree(state.questions, selectedOption.nextQuestionId!);
    }

    // 5. Actualizar historial de confianza (ventana de 4)
    double currentConfidence = 0.0;
    if (state.hypotheses.isNotEmpty) {
      currentConfidence = newAccumulator.evaluate(state.hypotheses).confidence;
    }
    final newConfidenceHistory = [
      ...state.confidenceHistory,
      currentConfidence,
    ].toList();
    // Mantener solo las últimas 4 lecturas
    if (newConfidenceHistory.length > 4) {
      newConfidenceHistory.removeAt(0);
    }

    state = state.copyWith(
      selectedAnswers: newAnswers,
      accumulator: newAccumulator,
      confidenceHistory: newConfidenceHistory,
      allowedQuestionIds: newAllowedIds,
    );

    // 5. Verificar límite de preguntas respondidas
    final answered = newAnswers.length;
    if (answered >= _maxQuestions) {
      final result = newAccumulator.buildResult(
        allHypotheses: state.hypotheses,
        symptomId: state.symptomId,
      );
      state = state.copyWith(isComplete: true, result: result);
      return true;
    }

    // 6. Verificar si el motor de inferencia quiere concluir por confianza
    if (state.hypotheses.isNotEmpty &&
        _engine.shouldConclude(newAccumulator, state.hypotheses)) {
      final result = newAccumulator.buildResult(
        allHypotheses: state.hypotheses,
        symptomId: state.symptomId,
      );
      state = state.copyWith(isComplete: true, result: result);
      return true;
    }

    // 7. Detección de oscilación de confianza (confianza sube-baja-sube o baja-sube-baja)
    //    Si en 4 lecturas hay 3+ cambios de dirección → concluir.
    if (newConfidenceHistory.length >= 4 && _isOscillating(newConfidenceHistory)) {
      final result = newAccumulator.buildResult(
        allHypotheses: state.hypotheses,
        symptomId: state.symptomId,
      );
      state = state.copyWith(isComplete: true, result: result);
      return true;
    }

    // 8. Seleccionar siguiente pregunta (limitada al sub-árbol activo)
    final nextQ = _engine.nextQuestion(
      allQuestions: state.questions,
      answeredIds: newAnswers.keys.toSet(),
      accumulator: newAccumulator,
      hypotheses: state.hypotheses,
      forcedNextId: selectedOption.nextQuestionId,
      allowedQuestionIds: state.allowedQuestionIds,
    );

    if (nextQ == null) {
      final result = newAccumulator.buildResult(
        allHypotheses: state.hypotheses,
        symptomId: state.symptomId,
      );
      state = state.copyWith(isComplete: true, result: result);
      return true;
    }

    // 9. Avanzar
    final currentIndex = state.questionHistory.indexOf(qId);
    final newHistory = [
      ...state.questionHistory.sublist(0, currentIndex + 1),
      nextQ.id,
    ];

    state = state.copyWith(
      questionHistory: newHistory,
      currentQuestionId: nextQ.id,
    );

    return false;
  }

  /// Retorna `true` si la secuencia de confianzas oscila (3+ cambios de dirección).
  bool _isOscillating(List<double> history) {
    if (history.length < 4) return false;
    int directionChanges = 0;
    for (int i = 1; i < history.length - 1; i++) {
      final prev = history[i] - history[i - 1];
      final next = history[i + 1] - history[i];
      // Cambio de dirección si uno sube y el otro baja (o viceversa)
      if (prev.abs() > 0.04 && next.abs() > 0.04 && prev * next < 0) {
        directionChanges++;
      }
    }
    return directionChanges >= 2;
  }

  /// Retrocede a la pregunta anterior, revirtiendo la evidencia acumulada.
  void goBack() {
    final currentIndex =
        state.questionHistory.indexOf(state.currentQuestionId ?? '');
    if (currentIndex <= 0) return;

    final prevId = state.questionHistory[currentIndex - 1];

    // Revertir evidencia de la respuesta de la pregunta ACTUAL (que se deshace)
    final currentOptId = state.selectedAnswers[state.currentQuestionId];
    if (currentOptId != null) {
      final currentQ = state.currentQuestion;
      if (currentQ != null) {
        try {
          final option = currentQ.options.firstWhere((o) => o.id == currentOptId);
          if (option.evidence.isNotEmpty) {
            final newAccumulator = EvidenceAccumulator.from(state.accumulator);
            newAccumulator.removeEvidence(option.evidence);
            // También eliminamos la respuesta del mapa
            final newAnswers = Map<String, String>.from(state.selectedAnswers)
              ..remove(state.currentQuestionId);
            // Revertir confianza history
            final newHistory = state.confidenceHistory.isNotEmpty
                ? state.confidenceHistory.sublist(
                    0, state.confidenceHistory.length - 1)
                : <double>[];
            state = state.copyWith(
              accumulator: newAccumulator,
              selectedAnswers: newAnswers,
              confidenceHistory: newHistory,
            );
          }
        } catch (_) {}
      }
    }

    state = state.copyWith(
      currentQuestionId: prevId,
      isComplete: false,
      result: null,
    );
  }

  /// Reinicia todo el flujo.
  void reset() {
    state = _initialState(state.symptomId);
  }

  /// Recorre el árbol de opciones (BFS) para encontrar todos los IDs 
  /// contextualmente enlazados a partir de [startNodeId].
  Set<String> _extractSubtree(List<DiagnosticQuestion> allQuestions, String startNodeId) {
    final visited = <String>{};
    final queue = [startNodeId];

    while (queue.isNotEmpty) {
      final currentId = queue.removeAt(0);
      if (visited.contains(currentId)) continue;
      visited.add(currentId);

      final qIndex = allQuestions.indexWhere((q) => q.id == currentId);
      if (qIndex != -1) {
        final q = allQuestions[qIndex];
        for (final opt in q.options) {
          if (opt.nextQuestionId != null) {
            queue.add(opt.nextQuestionId!);
          }
        }
      }
    }
    return visited;
  }
}

/// Provider family que crea un notifier por symptomId.
final diagnosticFlowProvider = StateNotifierProvider.autoDispose
    .family<DiagnosticFlowNotifier, DiagnosticFlowState, String>(
  (ref, symptomId) => DiagnosticFlowNotifier(symptomId),
);
