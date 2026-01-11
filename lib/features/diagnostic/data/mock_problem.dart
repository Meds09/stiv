import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/problem.dart';

const mockProblems = <Problem> [
  Problem(
    id: 1,
    icon: Icon(Icons.power_settings_new_outlined, color: Colors.redAccent, size: 24,),
    title: 'Fallas de energía',
    description: 'El dispositivo no recibe energía eléctrica',
    appliedCategoryIds: {1, 2, 3, 4},
     // CCTV, Red, Energía y Control acceso
  ),
  Problem(
    id: 2,
    icon: Icon(Icons.wifi_off_outlined, color: Colors.redAccent, size: 24,),
    title: 'Fallas de conexión de red',
    description: 'El equipo no se comunica con la red',
    appliedCategoryIds: {1, 2, 4}, // CCTV, Red y Control acceso
  ),
  Problem(
    id: 3,
    icon: Icon(Icons.videocam_off_outlined, color: Colors.redAccent, size: 24,),
    title: 'Fallas de imagen',
    description: 'No hay transmisión de video',
    appliedCategoryIds: {1}, // CCTV
  ),
   //
  Problem( 
    id: 4,
    icon: Icon(Icons.lock_outline, color: Colors.redAccent, size: 24,),
    title: 'Fallas de autenticación',
    description: 'El sistema no permite el ingreso del usuario',
    appliedCategoryIds: {1,2,4},// CCTV, Red y Control acceso
  ),
    Problem(
    id: 5,
    title: 'No estoy seguro del problema',
    description: 'Deseo especificar el problema mediante texto libre e imágenes',
    appliedCategoryIds: {5},// CCTV, Red y Control acceso
  ),
  

];
