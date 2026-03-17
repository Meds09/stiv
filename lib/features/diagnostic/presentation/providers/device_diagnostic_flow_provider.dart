import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/diagnostic/data/device_diagnostic_data.dart';
import 'package:stiv/features/diagnostic/data/hypotheses_data.dart';
import 'package:stiv/features/diagnostic/domain/evidence_accumulator.dart';
import 'package:stiv/features/diagnostic/domain/inference_engine.dart';
import 'package:stiv/features/diagnostic/models/diagnostic_question.dart';
import 'package:stiv/features/diagnostic/models/hypothesis.dart';
import 'package:stiv/features/diagnostic/presentation/providers/diagnostic_flow_provider.dart'
    show DiagnosticFlowState;

/// Parámetros para iniciar un diagnóstico específico por dispositivo.
class DeviceDiagnosticParams {
  final String deviceId;
  final String deviceName;
  final int categoryId;
  final String startQuestionId; // ej: 'pow_2_cctv'
  final String symptomKey;      // ej: 'power_issue'
  final String symptomLabel;    // ej: 'No enciende o sin señal'

  const DeviceDiagnosticParams({
    required this.deviceId,
    required this.deviceName,
    required this.categoryId,
    required this.startQuestionId,
    required this.symptomKey,
    required this.symptomLabel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceDiagnosticParams &&
          deviceId == other.deviceId &&
          startQuestionId == other.startQuestionId;

  @override
  int get hashCode => Object.hash(deviceId, startQuestionId);
}

// ─────────────────────────────────────────────────────────────────────────────
// Privados
// ─────────────────────────────────────────────────────────────────────────────

const int _maxDiagnosticQuestions = 7;

/// Extrae todos los IDs del sub-árbol de preguntas a partir de [startNodeId].
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

/// Combina las hipótesis relevantes al síntoma dado.
List<Hypothesis> _hypothesesForSymptom(String symptomKey) {
  final raw = hypothesesBySymptom[symptomKey] ?? [];
  // Deduplicar por ID
  final seen = <String>{};
  return raw.where((h) => seen.add(h.id)).toList();
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

/// Gestiona la lógica del flujo de diagnóstico contextualizado por dispositivo.
/// Reutiliza [DiagnosticFlowState] para compatibilidad con los widgets existentes.
class DeviceDiagnosticFlowNotifier
    extends Notifier<DiagnosticFlowState> {
  final DeviceDiagnosticParams _params;

  DeviceDiagnosticFlowNotifier(this._params);

  static const _engine = InferenceEngine(confidenceThreshold: 0.75);

  @override
  DiagnosticFlowState build() {
    return _buildInitialState(_params);
  }

  static DiagnosticFlowState _buildInitialState(DeviceDiagnosticParams p) {
    final questions = deviceDiagnosticQuestions;
    final hypotheses = _hypothesesForSymptom(p.symptomKey);
    final allowedIds = _extractSubtree(questions, p.startQuestionId);

    return DiagnosticFlowState(
      questions: questions,
      hypotheses: hypotheses,
      questionHistory: [p.startQuestionId],
      currentQuestionId: p.startQuestionId,
      accumulator: EvidenceAccumulator(),
      allowedQuestionIds: allowedIds,
      diagnosticAnswerCount: 0,
    );
  }

  // ─── selectAndAdvance ────────────────────────────────────────────────────

  /// Selecciona una opción y avanza en el flujo.
  /// Devuelve `true` si el diagnóstico se completó.
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

    // 2. Acumular evidencia
    final newAccumulator = EvidenceAccumulator.from(state.accumulator);
    if (selectedOption.evidence.isNotEmpty) {
      newAccumulator.addEvidence(selectedOption.evidence);
    }

    // 3. Incrementar contador de diagnóstico
    final newDiagCount = state.diagnosticAnswerCount + 1;

    // 4. Historial de confianza (ventana de 4)
    double currentConfidence = 0.0;
    if (state.hypotheses.isNotEmpty) {
      currentConfidence =
          newAccumulator.evaluate(state.hypotheses).confidence;
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
      diagnosticAnswerCount: newDiagCount,
    );

    // 5. Límite de preguntas
    if (newDiagCount >= _maxDiagnosticQuestions) {
      return _conclude(newAccumulator);
    }

    // 6. Opción sin siguiente pregunta → concluir
    if (selectedOption.nextQuestionId == null) {
      return _conclude(newAccumulator);
    }

    // 7. Motor de inferencia decide concluir
    if (state.hypotheses.isNotEmpty &&
        _engine.shouldConclude(newAccumulator, state.hypotheses)) {
      return _conclude(newAccumulator);
    }

    // 8. Detección de oscilación
    if (newConfidenceHistory.length >= 4 &&
        _isOscillating(newConfidenceHistory)) {
      return _conclude(newAccumulator);
    }

    // 9. Avanzar a la siguiente pregunta
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
      return _conclude(newAccumulator);
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

  bool _conclude(EvidenceAccumulator acc) {
    final result = acc.buildResult(
      allHypotheses: state.hypotheses,
      symptomId: 'device_flow',
    );
    state = state.copyWith(isComplete: true, result: result);
    return true;
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

  // ─── goBack ─────────────────────────────────────────────────────────────

  void goBack() {
    final currentIndex =
        state.questionHistory.indexOf(state.currentQuestionId ?? '');
    if (currentIndex <= 0) return;

    final prevId = state.questionHistory[currentIndex - 1];

    // Revertir evidencia de la pregunta actual
    final currentOptId = state.selectedAnswers[state.currentQuestionId];
    if (currentOptId != null) {
      final currentQ = state.currentQuestion;
      if (currentQ != null) {
        try {
          final option =
              currentQ.options.firstWhere((o) => o.id == currentOptId);
          if (option.evidence.isNotEmpty) {
            final newAccumulator =
                EvidenceAccumulator.from(state.accumulator);
            newAccumulator.removeEvidence(option.evidence);
            final newAnswers =
                Map<String, String>.from(state.selectedAnswers)
                  ..remove(state.currentQuestionId);
            final newHistory = state.confidenceHistory.isNotEmpty
                ? state.confidenceHistory
                    .sublist(0, state.confidenceHistory.length - 1)
                : <double>[];
            final newCount =
                (state.diagnosticAnswerCount - 1).clamp(0, _maxDiagnosticQuestions);

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

    // Eliminar respuesta sin evidencia (si quedó)
    if (state.selectedAnswers.containsKey(state.currentQuestionId)) {
      final newAnswers =
          Map<String, String>.from(state.selectedAnswers)
            ..remove(state.currentQuestionId);
      final newCount =
          (state.diagnosticAnswerCount - 1).clamp(0, _maxDiagnosticQuestions);
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

  // ─── reset ──────────────────────────────────────────────────────────────

  void reset(DeviceDiagnosticParams params) {
    state = _buildInitialState(params);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

/// Provider autoDispose que gestiona el flujo DSS específico por dispositivo.
/// El parámetro es [DeviceDiagnosticParams] (deviceId + symptomKey + etc.)
final deviceDiagnosticFlowProvider = NotifierProvider.autoDispose
    .family<DeviceDiagnosticFlowNotifier, DiagnosticFlowState,
        DeviceDiagnosticParams>(
  DeviceDiagnosticFlowNotifier.new,
);
