import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/vehicle.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

@freezed
abstract class VehicleModel with _$VehicleModel {
  const factory VehicleModel({
    required String id,
    @JsonKey(name: 'driver_id') required String driverId,
    required String nickname,
    String? plate,
    @JsonKey(name: 'current_km') double? currentKm,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _VehicleModel;

  const VehicleModel._();

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Vehicle toEntity() => Vehicle(
    id: id,
    driverId: driverId,
    nickname: nickname,
    plate: plate,
    currentKm: currentKm,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
