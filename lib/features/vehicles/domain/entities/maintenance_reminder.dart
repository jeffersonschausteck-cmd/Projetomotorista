/// Espelha `maintenance_reminders` (supabase/migrations/0005_expenses_and_maintenance.sql).
enum MaintenanceType { oilChange, revision, tires, insurance, ipva, documentation, other }

enum ReminderStatus { ok, upcoming, overdue }

class MaintenanceReminder {
  const MaintenanceReminder({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.type,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.dueKm,
    this.dueDate,
    this.lastDoneAt,
    this.notes,
  });

  final String id;
  final String driverId;
  final String vehicleId;
  final MaintenanceType type;
  final double? dueKm;
  final DateTime? dueDate;
  final DateTime? lastDoneAt;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  static const _upcomingKmThreshold = 500;
  static const _upcomingDaysThreshold = 15;

  /// [currentKm] vem do `Vehicle.currentKm` — o lembrete não guarda isso,
  /// só o limiar (`dueKm`), pra não duessincronizar com o odômetro real.
  ReminderStatus statusFor({double? currentKm, DateTime? now}) {
    final today = now ?? DateTime.now();

    final overdueByDate = dueDate != null && dueDate!.isBefore(today);
    final overdueByKm =
        dueKm != null && currentKm != null && currentKm >= dueKm!;
    if (overdueByDate || overdueByKm) return ReminderStatus.overdue;

    final upcomingByDate =
        dueDate != null && dueDate!.difference(today).inDays <= _upcomingDaysThreshold;
    final upcomingByKm = dueKm != null &&
        currentKm != null &&
        (dueKm! - currentKm) <= _upcomingKmThreshold;
    if (upcomingByDate || upcomingByKm) return ReminderStatus.upcoming;

    return ReminderStatus.ok;
  }
}
