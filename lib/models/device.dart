class Device {
  final String id;
  final String name;
  final String model;
  final String brand;
  final String ip;
  final String? location;
  final String category;

  Device({
    required this.id,
    required this.name,
    required this.model,
    required this.brand,
    required this.ip,
    this.location,
    required this.category,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      brand: json['brand'],
      ip: json['ip'],
      location: json['location'],
      category: json['category'],
    );
  }
}

final List<Device> devicesData = [
  Device(
    id: '1',
    name: 'Cámara Frontal',
    model: 'Q6225-LE',
    brand: 'Axis',
    ip: '237.84.2.178',
    location: 'Torre Control',
    category: 'Camaras',
  ),
  Device(
    id: '2',
    name: 'Router Principal',
    model: 'NetMaster 3000',
    brand: 'Aruba',
    ip: '38.0.101.76',
    category: 'Redes',
  ),
  Device(
    id: '3',
    name: 'Molinete Entrada Norte',
    model: 'RBH A50',
    brand: 'Gunnebo',
    ip: '244.178.44.111',
    category: 'Control de acceso',
  ),
];
