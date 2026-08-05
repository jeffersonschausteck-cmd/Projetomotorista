import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../domain/entities/maintenance_reminder.dart';
import '../domain/repositories/maintenance_reminders_repository.dart';
import 'models/maintenance_reminder_model.dart';

class MaintenanceRemindersRepositoryImpl implements MaintenanceRemindersRepository {
  MaintenanceRemindersRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _table = 'maintenance_reminders';

  @override
  Future<Result<List<MaintenanceReminder>>> getReminders({String? vehicleId}) async {
    try {
      var query = _client.from(_table).select().eq('is_active', true);
      if (vehicleId != null) {
        query = query.eq('vehicle_id', vehicleId);
      }
      final rows = await query.order('due_date');
      return Success(rows.map(maintenanceReminderFromRow).toList());
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<MaintenanceReminder>> createReminder(MaintenanceReminder reminder) async {
    final driverId = _client.auth.currentUser?.id;
    if (driverId == null) return const Error(AuthFailure('Sessão expirada.'));

    try {
      final row = await _client
          .from(_table)
          .insert(maintenanceReminderToRow(reminder, driverId: driverId))
          .select()
          .single();
      return Success(maintenanceReminderFromRow(row));
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<MaintenanceReminder>> updateReminder(MaintenanceReminder reminder) async {
    try {
      final payload = maintenanceReminderToRow(reminder, driverId: reminder.driverId)
        ..remove('driver_id');
      final row = await _client
          .from(_table)
          .update(payload)
          .eq('id', reminder.id)
          .select()
          .single();
      return Success(maintenanceReminderFromRow(row));
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteReminder(String id) async {
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
