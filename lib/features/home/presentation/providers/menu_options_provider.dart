import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/home/presentation/widgets/menu_grid_section.dart';

/// Provider que define las opciones del menú principal
/// Facilita la gestión y modificación de las opciones desde un solo lugar
final menuOptionsProvider = Provider<List<MenuOption>>((ref) {
  return [
    MenuOption(
      title: 'Diagnóstico Rápido',
      icon: Icons.import_contacts_rounded,
      onTap: () {
        // TODO: Navegar a diagnóstico rápido
      },
    ),
    MenuOption(
      title: 'Dispositivos',
      icon: Icons.devices,
      onTap: () {
        // TODO: Navegar a dispositivos
      },
    ),
    MenuOption(
      title: 'Historial de reportes',
      icon: Icons.history,
      onTap: () {
        // TODO: Navegar a historial
      },
    ),
    MenuOption(
      title: 'Manuales',
      icon: Icons.menu_book_rounded,
      onTap: () {
        // TODO: Navegar a manuales
      },
    ),
  ];
});

