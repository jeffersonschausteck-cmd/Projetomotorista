import '../../../../core/error/result.dart';
import '../entities/maintenance_reminder.dart';

abstract interface class MaintenanceRemindersRepository {
  Future<Result<List<MaintenanceReminder>>> getReminders({String? vehicleId});
  Future<Result<MaintenanceReminder>> createReminder(MaintenanceReminder reminder);
  Future<Result<MaintenanceReminder>> updateReminder(MaintenanceReminder reminder);
  Future<Result<void>> deleteReminder(String id);
}
