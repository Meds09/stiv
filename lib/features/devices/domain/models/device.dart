import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device.freezed.dart';
part 'device.g.dart';



@freezed
abstract class Device with _$Device {
  const Device._();
  const factory Device({
    required String id,
    required String name,
    required String model,
    required String brand,
    required String userId,
    String? image,
    required String ip,
    String? location,
    required int categoryId,

  }) = _Device;

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  factory Device.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Device.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}
