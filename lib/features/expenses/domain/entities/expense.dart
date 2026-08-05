/// Espelha `expenses` (supabase/migrations/0005_expenses_and_maintenance.sql).
enum ExpenseCategory { fuel, toll, wash, insurance, ipva, tires, oilChange, maintenance, other }

class Expense {
  const Expense({
    required this.id,
    required this.driverId,
    required this.category,
    required this.amount,
    required this.expenseDate,
    required this.createdAt,
    required this.updatedAt,
    this.vehicleId,
    this.odometerKm,
    this.notes,
  });

  final String id;
  final String driverId;
  final String? vehicleId;
  final ExpenseCategory category;
  final double amount;
  final DateTime expenseDate;
  final double? odometerKm;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
