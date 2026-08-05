import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../domain/entities/vehicle.dart';
import '../domain/repositories/vehicles_repository.dart';
import 'models/vehicle_model.dart';

class VehiclesRepositoryImpl implements VehiclesRepository {
  VehiclesRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _table = 'vehicles';

  @override
  Future<Result<List<Vehicle>>> getVehicles() async {
    try {
      final rows = await _client
          .from(_table)
          .select()
          .eq('is_active', true)
          .order('nickname');
      final vehicles = rows
          .map((row) => VehicleModel.fromJson(row).toEntity())
          .toList();
      return Success(vehicles);
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Vehicle>> createVehicle(Vehicle vehicle) async {
    final driverId = _client.auth.currentUser?.id;
    if (driverId == null) return const Error(AuthFailure('Sessão expirada.'));

    try {
      final row = await _client
          .from(_table)
          .insert({
            'driver_id': driverId,
            'nickname': vehicle.nickname,
            'plate': vehicle.plate,
            'current_km': vehicle.currentKm,
          })
          .select()
          .single();
      return Success(VehicleModel.fromJson(row).toEntity());
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Vehicle>> updateVehicle(Vehicle vehicle) async {
    try {
      final row = await _client
          .from(_table)
          .update({
            'nickname': vehicle.nickname,
            'plate': vehicle.plate,
            'current_km': vehicle.currentKm,
          })
          .eq('id', vehicle.id)
          .select()
          .single();
      return Success(VehicleModel.fromJson(row).toEntity());
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteVehicle(String id) async {
    try {
      await _client.from(_table).update({'is_active': false}).eq('id', id);
      return const Success(null);
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
