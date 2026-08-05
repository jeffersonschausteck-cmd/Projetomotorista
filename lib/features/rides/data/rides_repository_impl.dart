import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../domain/entities/ride.dart';
import '../domain/repositories/rides_repository.dart';
import 'models/ride_model.dart';

const _statusColumn = {
  RideStatus.accepted: 'accepted_at',
  RideStatus.inProgress: 'started_at',
  RideStatus.completed: 'completed_at',
  RideStatus.cancelled: 'cancelled_at',
};

const _statusDbValue = {
  RideStatus.pending: 'pending',
  RideStatus.accepted: 'accepted',
  RideStatus.declined: 'declined',
  RideStatus.inProgress: 'in_progress',
  RideStatus.completed: 'completed',
  RideStatus.cancelled: 'cancelled',
};

class RidesRepositoryImpl implements RidesRepository {
  RidesRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _table = 'rides';

  @override
  Future<Result<List<Ride>>> getRides({DateTime? from, DateTime? to}) async {
    try {
      var query = _client.from(_table).select().isFilter('deleted_at', null);
      if (from != null) {
        query = query.gte('created_at', from.toIso8601String());
      }
      if (to != null) {
        query = query.lte('created_at', to.toIso8601String());
      }
      final rows = await query.order('created_at', ascending: false);
      return Success(rows.map(rideFromRow).toList());
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Ride>> getRideById(String id) async {
    try {
      final row = await _client.from(_table).select().eq('id', id).single();
      return Success(rideFromRow(row));
    } on PostgrestException catch (e) {
      return Error(NotFoundFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Ride>> createRide(Ride ride) async {
    final driverId = _client.auth.currentUser?.id;
    if (driverId == null) return const Error(AuthFailure('Sessão expirada.'));

    try {
      final row = await _client
          .from(_table)
          .insert(rideToInsertRow(ride, driverId: driverId))
          .select()
          .single();
      return Success(rideFromRow(row));
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Ride>> updateRide(Ride ride) async {
    try {
      final payload = rideToInsertRow(ride, driverId: ride.driverId)
        ..remove('driver_id');
      final row = await _client
          .from(_table)
          .update(payload)
          .eq('id', ride.id)
          .select()
          .single();
      return Success(rideFromRow(row));
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteRide(String id) async {
    try {
      await _client
          .from(_table)
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', id);
      return const Success(null);
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Ride>> updateStatus(String id, RideStatus status) async {
    try {
      final payload = <String, dynamic>{'status': _statusDbValue[status]};
      final timestampColumn = _statusColumn[status];
      if (timestampColumn != null) {
        payload[timestampColumn] = DateTime.now().toIso8601String();
      }
      final row = await _client
          .from(_table)
          .update(payload)
          .eq('id', id)
          .select()
          .single();
      return Success(rideFromRow(row));
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
