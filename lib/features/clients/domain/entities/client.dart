/// Espelha `clients` (supabase/migrations/0001_init_core_schema.sql).
class Client {
  const Client({
    required this.id,
    required this.driverId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.notes,
  });

  final String id;
  final String driverId;
  final String name;
  final String? phone;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
