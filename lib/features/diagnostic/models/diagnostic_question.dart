import 'package:flutter/material.dart';

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
  final String? nextQuestionId;

  const QuestionOption({
    required this.id,
    required this.label,
    this.description,
    this.icon,
    this.nextQuestionId,
  });
}
