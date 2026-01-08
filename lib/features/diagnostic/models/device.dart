
 enum DeviceStatus{
    online,
    offline,
    maintenance,
  }



class Device {
  final int id;
  final String name;
  final String model;
  final String brand;
  final String? image;
  final String ip;
  final String? location;
  final int categoryId;
  final DeviceStatus status;

  Device({
    required this.id,
    required this.name,
    required this.model,
    required this.brand,
    required this.ip,
    this.image,
    this.location,
    required this.categoryId, required this.status,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      model: json['model'],
      brand: json['brand'],
      ip: json['ip'],
      location: json['location'],
      categoryId: json['category'], 
      status: DeviceStatus.values.firstWhere((e) => e.name == json['status']),
    );
  }

 
}
