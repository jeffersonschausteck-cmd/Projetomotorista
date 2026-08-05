/// Espelha `vehicles` (supabase/migrations/0001_init_core_schema.sql).
/// Lembretes de manutenção (revisão, óleo, pneus) vivem em
/// `MaintenanceReminder`, não como colunas aqui — um veículo pode ter N.
class Vehicle {
  const Vehicle({
    required this.id,
    required this.driverId,
    required this.nickname,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.plate,
    this.currentKm,
  });

  final String id;
  final String driverId;
  final String nickname;
  final String? plate;
  final double? currentKm;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}
