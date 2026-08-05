// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientModel _$ClientModelFromJson(Map<String, dynamic> json) => _ClientModel(
  id: json['id'] as String,
  driverId: json['driver_id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String?,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ClientModelToJson(_ClientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driver_id': instance.driverId,
      'name': instance.name,
      'phone': instance.phone,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
