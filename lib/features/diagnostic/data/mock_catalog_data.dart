//Esto vendria a ser como una fake BD para poder hacer implementaciones y pruebas en el codigo real sin tener que tener una BD creada en el momento que se esta desarrollando esto

import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/diagnostic/models/device.dart';

const mockCategories = <Category>[
  Category(id: 1, name: 'CCTV y Videovigilancia', emoji: '📷'),
  Category(id: 2, name: 'Red y Conectividad', emoji: '🌐'),
  Category(id: 3, name: 'Energía y Respaldo', emoji: '⚡'),
  Category(id: 4, name: 'Control de Acceso', emoji: '🔐'),

];

final mockDevices = <Device>[
  Device(
    id: 1,
    name: 'Cámara Bullet Dahua',
    categoryId: 1,
    brand: 'Dahua',
    model: 'HFW-XXX',
    ip: '192.168.19.129',
  ),
  Device(
    id: 2,
    name: 'Cámara PTZ Hikvision',
    categoryId: 1,
    brand: 'Hikvision',
    model: 'DS-2DEXXXX',
    ip: '192.168.2.128',
  ),

  Device(
    id: 4,
    name: 'UPS Online 3 kVA',
    categoryId: 3,
    brand: 'APC',
    model: 'APC',
    ip: '172.120.124.12',
  ),

  Device(
    id: 5,
    name: 'Controladora acceso ZKTeco',
    categoryId: 4,
    brand: 'ZKTeco',
    model: 'Zkteco 1',
    ip: '192.168.1.2',
  ),

  Device(
    id: 3,
    name: 'Switch PoE 24 puertos',
    categoryId: 2,
    brand: 'Dahua',
    model: 'Dahua fenix',
    ip: '192.168.1.5',
  ),

];
