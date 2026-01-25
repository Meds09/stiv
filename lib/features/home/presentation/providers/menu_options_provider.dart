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
      route: 'diag',
      menuIndex: 1,
   
    ),
    MenuOption(
      title: 'Dispositivos',
      icon: Icons.devices, 
      route: 'devices',
    ),
    MenuOption(
      title: 'Historial de reportes',
      icon: Icons.history,
      route: 'reports',  
    ),
    MenuOption(
      title: 'Manuales',
      icon: Icons.menu_book_rounded, 
      route: 'manuals',
    ),
  ];
});
