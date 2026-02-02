// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Device _$DeviceFromJson(Map<String, dynamic> json) => _Device(
  id: json['id'] as String,
  name: json['name'] as String,
  model: json['model'] as String,
  brand: json['brand'] as String,
  image: json['image'] as String?,
  ip: json['ip'] as String,
  location: json['location'] as String?,
  categoryId: (json['categoryId'] as num).toInt(),
  status:
      $enumDecodeNullable(_$DeviceStatusEnumMap, json['status']) ??
      DeviceStatus.offline,
);

Map<String, dynamic> _$DeviceToJson(_Device instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'model': instance.model,
  'brand': instance.brand,
  'image': instance.image,
  'ip': instance.ip,
  'location': instance.location,
  'categoryId': instance.categoryId,
  'status': _$DeviceStatusEnumMap[instance.status]!,
};

const _$DeviceStatusEnumMap = {
  DeviceStatus.online: 'online',
  DeviceStatus.offline: 'offline',
  DeviceStatus.maintenance: 'maintenance',
};
