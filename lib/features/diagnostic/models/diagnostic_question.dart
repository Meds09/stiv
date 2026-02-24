import 'package:flutter/material.dart';

/// Peso de evidencia que una opción aporta a una hipótesis diagnóstica.
///
/// Un [weight] positivo favorece la hipótesis. Un valor negativo la descarta.
class EvidenceWeight {
  const EvidenceWeight({
    required this.hypothesisId,
    required this.weight,
  });

  /// ID de la hipótesis a la que se aporta evidencia.
  final String hypothesisId;

  /// Peso de evidencia. Rango sugerido: -1.0 a +1.0.
  final double weight;
}

/// Representa una pregunta dentro del flujo de diagnóstico rápido.
///
/// Cada pregunta tiene un conjunto de [options] que el usuario puede elegir.
/// Las opciones pueden apuntar a otra pregunta (via [nextQuestionId]) o ser
/// una hoja del árbol de decisiones (nextQuestionId == null).
class DiagnosticQuestion {
  final String id;
  final String text;
  final String? subtitle;
  final List<QuestionOption> options;

  const DiagnosticQuestion({
    required this.id,
    required this.text,
    this.subtitle,
    required this.options,
  });
}

/// Una opción de respuesta para una [DiagnosticQuestion].
class QuestionOption {
  final String id;
  final String label;
  final String? description;
  final IconData? icon;

  /// ID de la siguiente pregunta. Si es `null`, esta opción es una hoja
  /// y el flujo habrá terminado al seleccionarla y dar "Siguiente".
  ///
  /// Si el motor de inferencia está activo, este campo actúa como fallback.
  final String? nextQuestionId;

  /// Evidencia que esta opción aporta al motor de inferencia DSS.
  ///
  /// Puede ser vacío para preguntas no migradas aún (backward compat).
  final List<EvidenceWeight> evidence;

  const QuestionOption({
    required this.id,
    required this.label,
    this.description,
    this.icon,
    this.nextQuestionId,
    this.evidence = const [],
  });
}
