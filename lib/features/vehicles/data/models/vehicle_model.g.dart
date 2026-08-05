// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) =>
    _VehicleModel(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      nickname: json['nickname'] as String,
      plate: json['plate'] as String?,
      currentKm: (json['current_km'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$VehicleModelToJson(_VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driver_id': instance.driverId,
      'nickname': instance.nickname,
      'plate': instance.plate,
      'current_km': instance.currentKm,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
