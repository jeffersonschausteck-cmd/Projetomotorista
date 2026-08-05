import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/client.dart';

part 'client_model.freezed.dart';
part 'client_model.g.dart';

@freezed
abstract class ClientModel with _$ClientModel {
  const factory ClientModel({
    required String id,
    @JsonKey(name: 'driver_id') required String driverId,
    required String name,
    String? phone,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ClientModel;

  const ClientModel._();

  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);

  Client toEntity() => Client(
    id: id,
    driverId: driverId,
    name: name,
    phone: phone,
    notes: notes,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
