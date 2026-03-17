import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/diagnostic/data/device_diagnostic_data.dart';
import 'package:stiv/features/diagnostic/data/hypotheses_data.dart';
import 'package:stiv/features/diagnostic/domain/evidence_accumulator.dart';
import 'package:stiv/features/diagnostic/domain/inference_engine.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_result.dart';
import 'package:stiv/features/diagnostic/models/hypothesis.dart';

/// Número máximo de preguntas que el flujo puede hacer antes de concluir.
/// La Q de dispositivo y la Q de síntoma no cuentan contra este límite,
/// ya que son preguntas de navegación, no de diagnóstico.
const int _maxDiagnosticQuestions = 7;

/// Prefix de IDs de preguntas de navegación (no cuentan para el límite).
const _navQuestionPrefixes = ['dev_'];

/// Conjunto combinado de todas las hipótesis del sistema (para el flujo unificado).
final _allHypotheses = [
  ...hypothesesBySymptom['power_issue'] ?? [],
  ...hypothesesBySymptom['connectivity_issue'] ?? [],
  ...hypothesesBySymptom['display_issue'] ?? [],
  ...hypothesesBySymptom['audio_issue'] ?? [],
  ...hypothesesBySymptom['camera_issue'] ?? [],
  ...hypothesesBySymptom['other_issue'] ?? [],
].fold<List<Hypothesis>>([], (acc, h) {
  if (!acc.any((existing) => existing.id == h.id)) acc.add(h);
  return acc;
});

/// Estado inmutable del flujo de diagnóstico DSS.
class DiagnosticFlowState {
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
  final Set<String>? allowedQuestionIds;
  /// Contador de preguntas de diagnóstico respondidas (excluye preguntas nav).
  final int diagnosticAnswerCount;

  const DiagnosticFlowState({
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
    this.diagnosticAnswerCount = 0,
  });

  /// Número máximo de preguntas de diagnóstico.
  int get totalSteps => _maxDiagnosticQuestions;

  /// Paso actual visible en la UI (1-based).
  int get currentStep => (diagnosticAnswerCount + 1).clamp(1, totalSteps);

  /// Número total de respuestas (incluyendo navegación).
  int get answeredCount => selectedAnswers.length;

  /// Verdadero si está en la primera pregunta.
  bool get isFirstQuestion => answeredCount == 0;

  /// Pregunta actual.
  DiagnosticQuestion? get currentQuestion {
    if (currentQuestionId == null) return null;
    try {
      return questions.firstWhere((q) => q.id == currentQuestionId);
    } catch (_) {
      return null;
    }
  }

  /// Verdadero si la pregunta actual es de navegación (no cuenta para el límite).
  bool get isCurrentNavQuestion {
    final id = currentQuestionId ?? '';
    return _navQuestionPrefixes.any((prefix) => id.startsWith(prefix));
  }

  /// Opción actualmente seleccionada para la pregunta actual.
  String? get currentSelectedOptionId =>
      currentQuestionId != null ? selectedAnswers[currentQuestionId] : null;

  /// Progreso estimado (0.0 – 1.0).
  double get progress =>
      (diagnosticAnswerCount / totalSteps).clamp(0.0, 1.0);

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

  DiagnosticFlowState copyWith({
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
    int? diagnosticAnswerCount,
  }) {
    return DiagnosticFlowState(
      questions: questions ?? this.questions,
      hypotheses: hypotheses ?? this.hypotheses,
      questionHistory: questionHistory ?? this.questionHistory,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      currentQuestionId: currentQuestionId ?? this.currentQuestionId,
      isComplete: isComplete ?? this.isComplete,
      accumulator: accumulator ?? this.accumulator,
      result: result ?? this.result,
      confidenceHistory: confidenceHistory ?? this.confidenceHistory,
      allowedQuestionIds: clearAllowedIds
          ? null
          : (allowedQuestionIds ?? this.allowedQuestionIds),
      diagnosticAnswerCount:
          diagnosticAnswerCount ?? this.diagnosticAnswerCount,
    );
  }
}

/// Notifier que gestiona la lógica del flujo de diagnóstico unificado.
class DiagnosticFlowNotifier extends Notifier<DiagnosticFlowState> {
  DiagnosticFlowNotifier(String _);

  static const _engine = InferenceEngine(confidenceThreshold: 0.75);

  @override
  DiagnosticFlowState build() {
    return _initialState();
  }

  static DiagnosticFlowState _initialState() {
    final questions = deviceDiagnosticQuestions;
    const firstId = 'dev_0';
    return DiagnosticFlowState(
      questions: questions,
      hypotheses: _allHypotheses,
      questionHistory: [firstId],
      currentQuestionId: firstId,
      accumulator: EvidenceAccumulator(),
    );
  }

  /// Selecciona una opción y avanza automáticamente.
  /// Retorna `true` si el flujo se completó.
  bool selectAndAdvance(String optionId) {
    final qId = state.currentQuestionId;
    if (qId == null) return false;

    final currentQ = state.currentQuestion;
    if (currentQ == null) return false;

    QuestionOption? selectedOption;
    try {
      selectedOption = currentQ.options.firstWhere((o) => o.id == optionId);
    } catch (_) {
      return false;
    }

    // 1. Registrar la respuesta
    final newAnswers = {...state.selectedAnswers, qId: optionId};

    // 2. Acumular evidencia (solo si no es pregunta de navegación)
    final newAccumulator = EvidenceAccumulator.from(state.accumulator);
    if (selectedOption.evidence.isNotEmpty) {
      newAccumulator.addEvidence(selectedOption.evidence);
    }

    // 3. Contador de diagnóstico (no cuenta preguntas de navegación)
    final isNav = _navQuestionPrefixes.any((p) => qId.startsWith(p));
    final newDiagCount =
        state.diagnosticAnswerCount + (isNav ? 0 : 1);

    // 4. Detectar sub-árbol activo: solo cuando salimos de la Q de síntoma
    //    (primera vez que la siguiente pregunta NO es de navegación).
    Set<String>? newAllowedIds = state.allowedQuestionIds;
    if (newAllowedIds == null &&
        selectedOption.nextQuestionId != null &&
        !_navQuestionPrefixes
            .any((p) => selectedOption!.nextQuestionId!.startsWith(p))) {
      newAllowedIds =
          _extractSubtree(state.questions, selectedOption.nextQuestionId!);
      // Incluir también las preguntas de navegación para que goBack funcione
      newAllowedIds.addAll(['dev_0', 'dev_cctv_sym', 'dev_net_sym',
          'dev_nrg_sym', 'dev_acc_sym']);
    }

    // 5. Actualizar historial de confianza (ventana de 4)
    double currentConfidence = 0.0;
    if (!isNav && state.hypotheses.isNotEmpty) {
      currentConfidence = newAccumulator.evaluate(state.hypotheses).confidence;
    }
    final newConfidenceHistory = [
      ...state.confidenceHistory,
      currentConfidence,
    ].toList();
    if (newConfidenceHistory.length > 4) {
      newConfidenceHistory.removeAt(0);
    }

    state = state.copyWith(
      selectedAnswers: newAnswers,
      accumulator: newAccumulator,
      confidenceHistory: newConfidenceHistory,
      allowedQuestionIds: newAllowedIds,
      diagnosticAnswerCount: newDiagCount,
    );

    // 6. Verificar límite de preguntas de diagnóstico
    if (newDiagCount >= _maxDiagnosticQuestions) {
      final result = newAccumulator.buildResult(
        allHypotheses: state.hypotheses,
        symptomId: 'device_flow',
      );
      state = state.copyWith(isComplete: true, result: result);
      return true;
    }

    // 7. Si la opción no tiene siguiente pregunta → concluir
    if (selectedOption.nextQuestionId == null) {
      final result = newAccumulator.buildResult(
        allHypotheses: state.hypotheses,
        symptomId: 'device_flow',
      );
      state = state.copyWith(isComplete: true, result: result);
      return true;
    }

    // 8. Verificar si el motor de inferencia decide concluir (solo fuera de nav)
    if (!isNav &&
        state.hypotheses.isNotEmpty &&
        _engine.shouldConclude(newAccumulator, state.hypotheses)) {
      final result = newAccumulator.buildResult(
        allHypotheses: state.hypotheses,
        symptomId: 'device_flow',
      );
      state = state.copyWith(isComplete: true, result: result);
      return true;
    }

    // 9. Detección de oscilación (solo fuera de nav)
    if (!isNav &&
        newConfidenceHistory.length >= 4 &&
        _isOscillating(newConfidenceHistory)) {
      final result = newAccumulator.buildResult(
        allHypotheses: state.hypotheses,
        symptomId: 'device_flow',
      );
      state = state.copyWith(isComplete: true, result: result);
      return true;
    }

    // 10. Avanzar a la siguiente pregunta
    //     Si la opción tiene nextQuestionId explícito, usarlo directamente;
    //     de lo contrario usar el motor de inferencia.
    final String? nextId = selectedOption.nextQuestionId;
    DiagnosticQuestion? nextQ;

    if (nextId != null) {
      try {
        nextQ = state.questions.firstWhere((q) => q.id == nextId);
      } catch (_) {}
    }

    nextQ ??= _engine.nextQuestion(
      allQuestions: state.questions,
      answeredIds: newAnswers.keys.toSet(),
      accumulator: newAccumulator,
      hypotheses: state.hypotheses,
      forcedNextId: nextId,
      allowedQuestionIds: state.allowedQuestionIds,
    );

    if (nextQ == null) {
      final result = newAccumulator.buildResult(
        allHypotheses: state.hypotheses,
        symptomId: 'device_flow',
      );
      state = state.copyWith(isComplete: true, result: result);
      return true;
    }

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

  bool _isOscillating(List<double> history) {
    if (history.length < 4) return false;
    int directionChanges = 0;
    for (int i = 1; i < history.length - 1; i++) {
      final prev = history[i] - history[i - 1];
      final next = history[i + 1] - history[i];
      if (prev.abs() > 0.04 && next.abs() > 0.04 && prev * next < 0) {
        directionChanges++;
      }
    }
    return directionChanges >= 2;
  }

  void goBack() {
    final currentIndex =
        state.questionHistory.indexOf(state.currentQuestionId ?? '');
    if (currentIndex <= 0) return;

    final prevId = state.questionHistory[currentIndex - 1];

    // Revertir evidencia de la respuesta de la pregunta actual
    final currentOptId = state.selectedAnswers[state.currentQuestionId];
    if (currentOptId != null) {
      final currentQ = state.currentQuestion;
      if (currentQ != null) {
        try {
          final option =
              currentQ.options.firstWhere((o) => o.id == currentOptId);
          if (option.evidence.isNotEmpty) {
            final newAccumulator = EvidenceAccumulator.from(state.accumulator);
            newAccumulator.removeEvidence(option.evidence);
            final newAnswers =
                Map<String, String>.from(state.selectedAnswers)
                  ..remove(state.currentQuestionId);
            final newHistory = state.confidenceHistory.isNotEmpty
                ? state.confidenceHistory
                    .sublist(0, state.confidenceHistory.length - 1)
                : <double>[];

            // Revertir contador de diagnóstico si la pregunta no era de nav
            final wasNav = _navQuestionPrefixes
                .any((p) => (state.currentQuestionId ?? '').startsWith(p));
            final newCount = wasNav
                ? state.diagnosticAnswerCount
                : (state.diagnosticAnswerCount - 1).clamp(0, _maxDiagnosticQuestions);

            state = state.copyWith(
              accumulator: newAccumulator,
              selectedAnswers: newAnswers,
              confidenceHistory: newHistory,
              diagnosticAnswerCount: newCount,
            );
          }
        } catch (_) {}
      }
    }

    // Si también hay respuesta previa sin evidencia (preguntas de navegación)
    // solo eliminamos la respuesta del mapa
    if (state.selectedAnswers.containsKey(state.currentQuestionId)) {
      final newAnswers =
          Map<String, String>.from(state.selectedAnswers)
            ..remove(state.currentQuestionId);
      final wasNav = _navQuestionPrefixes
          .any((p) => (state.currentQuestionId ?? '').startsWith(p));
      final newCount = wasNav
          ? state.diagnosticAnswerCount
          : (state.diagnosticAnswerCount - 1).clamp(0, _maxDiagnosticQuestions);
      state = state.copyWith(
        selectedAnswers: newAnswers,
        diagnosticAnswerCount: newCount,
      );
    }

    state = state.copyWith(
      currentQuestionId: prevId,
      isComplete: false,
      result: null,
    );
  }

  /// Reinicia todo el flujo.
  void reset() {
    state = _initialState();
  }

  Set<String> _extractSubtree(
      List<DiagnosticQuestion> allQuestions, String startNodeId) {
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

/// Provider family (autoDispose) del flujo diagnóstico unificado.
/// El parámetro String es ignorado — siempre se usa el árbol de dispositivos.
final diagnosticFlowProvider = NotifierProvider.autoDispose
    .family<DiagnosticFlowNotifier, DiagnosticFlowState, String>(
  DiagnosticFlowNotifier.new,
);
