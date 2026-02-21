import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/diagnostic/data/diagnostic_questions_data.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';

/// Estado inmutable del flujo de diagnóstico.
class DiagnosticFlowState {
  final String symptomId;
  final List<DiagnosticQuestion> questions;
  final List<String> questionHistory; // pila de IDs visitados
  final Map<String, String> selectedAnswers; // questionId → optionId
  final String? currentQuestionId;
  final bool isComplete;

  const DiagnosticFlowState({
    required this.symptomId,
    required this.questions,
    this.questionHistory = const [],
    this.selectedAnswers = const {},
    this.currentQuestionId,
    this.isComplete = false,
  });

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

  /// Índice en la historia (0-based) — cuántas preguntas respondió.
  int get stepIndex => questionHistory.indexOf(currentQuestionId ?? '');

  /// Número de paso actual (1-based para UI).
  int get currentStep => stepIndex + 1;

  /// Progreso estimado (0.0 – 1.0).
  /// Basado en la profundidad real del historial de preguntas recorrido.
  double get progress {
    if (questionHistory.isEmpty) return 0;
    // Si es el último paso (la opción seleccionada es hoja), progreso 100%.
    if (isCurrentSelectionLeaf) return 1.0;
    // Progreso basado en historial: cada paso recorrido / total estimado.
    // Total estimado = pasos recorridos + 1 (por lo menos queda uno más).
    final stepsCompleted = stepIndex;
    final estimatedTotal = questionHistory.length + 1;
    return (stepsCompleted + 1) / estimatedTotal;
  }

  /// Verdadero si la opción actualmente seleccionada es un nodo hoja.
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

  /// Verdadero si está en la primera pregunta.
  bool get isFirstQuestion =>
      questionHistory.isEmpty ||
      (questionHistory.isNotEmpty &&
          currentQuestionId == questionHistory.first);

  DiagnosticFlowState copyWith({
    String? symptomId,
    List<DiagnosticQuestion>? questions,
    List<String>? questionHistory,
    Map<String, String>? selectedAnswers,
    String? currentQuestionId,
    bool? isComplete,
  }) {
    return DiagnosticFlowState(
      symptomId: symptomId ?? this.symptomId,
      questions: questions ?? this.questions,
      questionHistory: questionHistory ?? this.questionHistory,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      currentQuestionId: currentQuestionId ?? this.currentQuestionId,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

/// Notifier que gestiona la lógica del flujo de diagnóstico.
class DiagnosticFlowNotifier extends StateNotifier<DiagnosticFlowState> {
  DiagnosticFlowNotifier(String symptomId)
      : super(_initialState(symptomId));

  static DiagnosticFlowState _initialState(String symptomId) {
    final questions = diagnosticQuestionTrees[symptomId] ?? [];
    final firstId = questions.isNotEmpty ? questions.first.id : null;
    return DiagnosticFlowState(
      symptomId: symptomId,
      questions: questions,
      questionHistory: firstId != null ? [firstId] : [],
      currentQuestionId: firstId,
    );
  }

  /// Selecciona una opción para la pregunta actual.
  void selectOption(String optionId) {
    final qId = state.currentQuestionId;
    if (qId == null) return;

    state = state.copyWith(
      selectedAnswers: {...state.selectedAnswers, qId: optionId},
    );
  }

  /// Selecciona una opción y avanza automáticamente.
  /// Retorna `true` si el flujo se completó (opción hoja).
  bool selectAndAdvance(String optionId) {
    selectOption(optionId);
    goNext();
    return state.isComplete;
  }

  /// Avanza a la siguiente pregunta basándose en la opción seleccionada.
  void goNext() {
    final qId = state.currentQuestionId;
    if (qId == null) return;

    final selectedOptionId = state.selectedAnswers[qId];
    if (selectedOptionId == null) return;

    final currentQ = state.currentQuestion;
    if (currentQ == null) return;

    // Buscar la opción seleccionada
    QuestionOption? selectedOption;
    try {
      selectedOption =
          currentQ.options.firstWhere((o) => o.id == selectedOptionId);
    } catch (_) {
      return;
    }

    final nextId = selectedOption.nextQuestionId;

    if (nextId == null) {
      // Hoja del árbol — flujo completo
      state = state.copyWith(isComplete: true);
      return;
    }

    // Verificar que la siguiente pregunta existe
    final nextExists = state.questions.any((q) => q.id == nextId);
    if (!nextExists) {
      debugPrint('DiagnosticFlow: nextQuestionId "$nextId" no encontrado');
      state = state.copyWith(isComplete: true);
      return;
    }

    // Truncar el historial si el usuario había retrocedido
    final currentIndex = state.questionHistory.indexOf(qId);
    final newHistory = [
      ...state.questionHistory.sublist(0, currentIndex + 1),
      nextId,
    ];

    state = state.copyWith(
      questionHistory: newHistory,
      currentQuestionId: nextId,
    );
  }

  /// Retrocede a la pregunta anterior.
  void goBack() {
    final currentIndex =
        state.questionHistory.indexOf(state.currentQuestionId ?? '');
    if (currentIndex <= 0) return;

    final prevId = state.questionHistory[currentIndex - 1];
    state = state.copyWith(
      currentQuestionId: prevId,
      isComplete: false,
    );
  }

  /// Reinicia todo el flujo.
  void reset() {
    state = _initialState(state.symptomId);
  }
}

/// Provider family que crea un notifier por symptomId.
final diagnosticFlowProvider = StateNotifierProvider.autoDispose
    .family<DiagnosticFlowNotifier, DiagnosticFlowState, String>(
  (ref, symptomId) => DiagnosticFlowNotifier(symptomId),
);
