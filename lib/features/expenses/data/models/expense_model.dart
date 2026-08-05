import '../../domain/entities/expense.dart';

const _categoryValues = {
  ExpenseCategory.fuel: 'fuel',
  ExpenseCategory.toll: 'toll',
  ExpenseCategory.wash: 'wash',
  ExpenseCategory.insurance: 'insurance',
  ExpenseCategory.ipva: 'ipva',
  ExpenseCategory.tires: 'tires',
  ExpenseCategory.oilChange: 'oil_change',
  ExpenseCategory.maintenance: 'maintenance',
  ExpenseCategory.other: 'other',
};

ExpenseCategory _categoryFromDb(String value) {
  for (final entry in _categoryValues.entries) {
    if (entry.value == value) return entry.key;
  }
  return ExpenseCategory.other;
}

double? _parseDouble(num? value) => value?.toDouble();

Expense expenseFromRow(Map<String, dynamic> row) {
  return Expense(
    id: row['id'] as String,
    driverId: row['driver_id'] as String,
    vehicleId: row['vehicle_id'] as String?,
    category: _categoryFromDb(row['category'] as String),
    amount: (row['amount'] as num).toDouble(),
    expenseDate: DateTime.parse(row['expense_date'] as String),
    odometerKm: _parseDouble(row['odometer_km'] as num?),
    notes: row['notes'] as String?,
    createdAt: DateTime.parse(row['created_at'] as String),
    updatedAt: DateTime.parse(row['updated_at'] as String),
  );
}

Map<String, dynamic> expenseToRow(Expense expense, {required String driverId}) {
  return {
    'driver_id': driverId,
    'vehicle_id': expense.vehicleId,
    'category': _categoryValues[expense.category],
    'amount': expense.amount,
    'expense_date': expense.expenseDate.toIso8601String().substring(0, 10),
    'odometer_km': expense.odometerKm,
    'notes': expense.notes,
  };
}
