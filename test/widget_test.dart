// Testes de widget completos (com Supabase mockado) chegam na Fase 1, junto
// com as telas reais. Por ora, valida a lógica pura da camada core/domain.

import 'package:driver_platform/core/error/failure.dart';
import 'package:driver_platform/core/error/result.dart';
import 'package:driver_platform/features/dashboard/domain/entities/dashboard_summary.dart';
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
      );
      expect(summary.amountPerKm, 0);
    });
  });
}
