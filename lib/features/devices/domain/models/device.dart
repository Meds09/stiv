import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device.freezed.dart';
part 'device.g.dart';

// Reuse the enum from the original file or redefine it here.
// Since we are moving things, let's redefine it properly and we can alias/replace the old one later.
enum DeviceStatus {
  online,
  offline,
  maintenance,
}

@freezed
class Device with _$Device {
  const Device._();

  const factory Device({
    required String id,
    required String name,
    required String model,
    required String brand,
    String? image,
    required String ip,
    String? location,
    required int categoryId,
    @Default(DeviceStatus.offline) DeviceStatus status,
  }) = _Device;

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  factory Device.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Ensure the ID is taken from the document ID if not present in data, 
    // or just generally prefer the document ID.
    return Device.fromJson({
      ...data,
      'id': doc.id,
    });
  }
  
  @override
  // TODO: implement brand
  String get brand => throw UnimplementedError();
  
  @override
  // TODO: implement categoryId
  int get categoryId => throw UnimplementedError();
  
  @override
  // TODO: implement id
  String get id => throw UnimplementedError();
  
  @override
  // TODO: implement image
  String? get image => throw UnimplementedError();
  
  @override
  // TODO: implement ip
  String get ip => throw UnimplementedError();
  
  @override
  // TODO: implement location
  String? get location => throw UnimplementedError();
  
  @override
  // TODO: implement model
  String get model => throw UnimplementedError();
  
  @override
  // TODO: implement name
  String get name => throw UnimplementedError();
  
  @override
  // TODO: implement status
  DeviceStatus get status => throw UnimplementedError();
  
  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
  

}
