import '../../domain/entities/maintenance_reminder.dart';

const _typeValues = {
  MaintenanceType.oilChange: 'oil_change',
  MaintenanceType.revision: 'revision',
  MaintenanceType.tires: 'tires',
  MaintenanceType.insurance: 'insurance',
  MaintenanceType.ipva: 'ipva',
  MaintenanceType.documentation: 'documentation',
  MaintenanceType.other: 'other',
};

MaintenanceType _typeFromDb(String value) {
  for (final entry in _typeValues.entries) {
    if (entry.value == value) return entry.key;
  }
  return MaintenanceType.other;
}

DateTime? _parseDate(String? value) => value == null ? null : DateTime.parse(value);
double? _parseDouble(num? value) => value?.toDouble();

MaintenanceReminder maintenanceReminderFromRow(Map<String, dynamic> row) {
  return MaintenanceReminder(
    id: row['id'] as String,
    driverId: row['driver_id'] as String,
    vehicleId: row['vehicle_id'] as String,
    type: _typeFromDb(row['type'] as String),
    dueKm: _parseDouble(row['due_km'] as num?),
    dueDate: _parseDate(row['due_date'] as String?),
    lastDoneAt: _parseDate(row['last_done_at'] as String?),
    notes: row['notes'] as String?,
    isActive: row['is_active'] as bool,
    createdAt: DateTime.parse(row['created_at'] as String),
    updatedAt: DateTime.parse(row['updated_at'] as String),
  );
}

Map<String, dynamic> maintenanceReminderToRow(
  MaintenanceReminder reminder, {
  required String driverId,
}) {
  return {
    'driver_id': driverId,
    'vehicle_id': reminder.vehicleId,
    'type': _typeValues[reminder.type],
    'due_km': reminder.dueKm,
    'due_date': reminder.dueDate?.toIso8601String().substring(0, 10),
    'last_done_at': reminder.lastDoneAt?.toIso8601String().substring(0, 10),
    'notes': reminder.notes,
    'is_active': reminder.isActive,
  };
}
