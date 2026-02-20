import 'package:flutter/material.dart';

/// Modelo ligero para representar un síntoma en la UI.
class Symptom {
  const Symptom({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
  });

  final String id;
  final String label;
  final String description;
  final IconData icon;
}
