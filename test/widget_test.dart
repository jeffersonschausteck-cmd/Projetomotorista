// Testes de widget completos (com Supabase mockado) chegam na Fase 1, junto
// com as telas reais. Por ora, valida a lógica pura da camada core/domain.

import 'package:driver_platform/core/error/failure.dart';
import 'package:driver_platform/core/error/result.dart';
import 'package:driver_platform/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:driver_platform/features/vehicles/domain/entities/maintenance_reminder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('success carrega o valor', () {
      const result = Success<int>(42);
      expect(result.when(success: (v) => v, failure: (_) => -1), 42);
    });

    test('error carrega a falha', () {
      const result = Error<int>(NetworkFailure());
      expect(result.when(success: (_) => -1, failure: (f) => f.message), 'Falha de conexão. Tente novamente.');
    });
  });

  group('DashboardSummary', () {
    test('amountPerKm divide bruto por km rodado', () {
      final summary = DashboardSummary(
        periodStart: DateTime(2026, 8),
        periodEnd: DateTime(2026, 8, 2),
        totalRides: 10,
        grossAmount: 500,
        totalKm: 100,
        totalExpenses: 80,
        netAmount: 420,
      );
      expect(summary.amountPerKm, 5);
    });

    test('amountPerKm retorna 0 quando não rodou km', () {
      final summary = DashboardSummary(
        periodStart: DateTime(2026, 8),
        periodEnd: DateTime(2026, 8, 2),
        totalRides: 0,
        grossAmount: 0,
        totalKm: 0,
        totalExpenses: 0,
        netAmount: 0,
      );
      expect(summary.amountPerKm, 0);
    });
  });

  group('MaintenanceReminder.statusFor', () {
    MaintenanceReminder reminder({double? dueKm, DateTime? dueDate}) => MaintenanceReminder(
      id: '1',
      driverId: 'd',
      vehicleId: 'v',
      type: MaintenanceType.oilChange,
      dueKm: dueKm,
      dueDate: dueDate,
      isActive: true,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    test('ok quando está longe do limite de KM', () {
      final r = reminder(dueKm: 10000);
      expect(r.statusFor(currentKm: 5000), ReminderStatus.ok);
    });

    test('upcoming quando falta menos de 500km', () {
      final r = reminder(dueKm: 10000);
      expect(r.statusFor(currentKm: 9600), ReminderStatus.upcoming);
    });

    test('overdue quando já passou do KM', () {
      final r = reminder(dueKm: 10000);
      expect(r.statusFor(currentKm: 10001), ReminderStatus.overdue);
    });

    test('overdue quando a data já passou', () {
      final r = reminder(dueDate: DateTime(2026, 1, 1));
      expect(r.statusFor(now: DateTime(2026, 1, 2)), ReminderStatus.overdue);
    });

    test('upcoming quando a data está a menos de 15 dias', () {
      final r = reminder(dueDate: DateTime(2026, 1, 15));
      expect(r.statusFor(now: DateTime(2026, 1, 5)), ReminderStatus.upcoming);
    });

    test('ok quando não há KM nem data atual pra comparar', () {
      final r = reminder(dueKm: 10000);
      expect(r.statusFor(), ReminderStatus.ok);
    });
  });
}
