// Testes de widget completos (com Supabase mockado) chegam na Fase 1, junto
// com as telas reais. Por ora, valida a lógica pura da camada core/domain.

import 'package:driver_platform/core/error/failure.dart';
import 'package:driver_platform/core/error/result.dart';
import 'package:driver_platform/core/services/whatsapp_launcher.dart';
import 'package:driver_platform/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:driver_platform/features/rides/domain/entities/ride.dart';
import 'package:driver_platform/features/rides/domain/entities/route_point.dart';
import 'package:driver_platform/features/rides/domain/services/ride_receipt_message.dart';
import 'package:driver_platform/features/rides/domain/services/route_distance_calculator.dart';
import 'package:driver_platform/features/vehicles/domain/entities/maintenance_reminder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

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

  group('RouteDistanceCalculator', () {
    test('0 com menos de 2 pontos', () {
      expect(RouteDistanceCalculator.totalDistanceKm([]), 0);
      expect(
        RouteDistanceCalculator.totalDistanceKm([
          RoutePoint(lat: -23.55, lng: -46.63, recordedAt: DateTime(2026)),
        ]),
        0,
      );
    });

    test('soma a distância entre pontos consecutivos (Haversine)', () {
      // Praça da Sé -> Av. Paulista (~2.9km em linha reta).
      final points = [
        RoutePoint(lat: -23.5505, lng: -46.6333, recordedAt: DateTime(2026)),
        RoutePoint(lat: -23.5613, lng: -46.6565, recordedAt: DateTime(2026)),
      ];
      expect(RouteDistanceCalculator.totalDistanceKm(points), closeTo(2.9, 0.3));
    });

    test('pontos idênticos não somam distância', () {
      final points = List.generate(
        5,
        (_) => RoutePoint(lat: -23.55, lng: -46.63, recordedAt: DateTime(2026)),
      );
      expect(RouteDistanceCalculator.totalDistanceKm(points), 0);
    });
  });

  group('normalizeBrazilianPhone', () {
    test('adiciona código do país em número de 11 dígitos (celular com DDD)', () {
      expect(normalizeBrazilianPhone('11999999999'), '5511999999999');
    });

    test('adiciona código do país em número de 10 dígitos (fixo com DDD)', () {
      expect(normalizeBrazilianPhone('1133334444'), '551133334444');
    });

    test('remove formatação antes de normalizar', () {
      expect(normalizeBrazilianPhone('(11) 99999-9999'), '5511999999999');
    });

    test('não duplica código do país já presente', () {
      expect(normalizeBrazilianPhone('5511999999999'), '5511999999999');
    });
  });

  group('buildWhatsAppUri', () {
    test('monta a URL wa.me com o telefone normalizado e a mensagem', () {
      final uri = buildWhatsAppUri(phone: '11999999999', message: 'Olá!');
      expect(uri.host, 'wa.me');
      expect(uri.path, '/5511999999999');
      expect(uri.queryParameters['text'], 'Olá!');
    });

    test('sem mensagem não inclui o parâmetro text', () {
      final uri = buildWhatsAppUri(phone: '11999999999');
      expect(uri.queryParameters.containsKey('text'), isFalse);
    });
  });

  group('buildRideReceiptMessage', () {
    test('inclui origem, destino, valor e nome do cliente', () {
      final ride = Ride(
        id: '1',
        driverId: 'd',
        source: RideSource.manual,
        platform: RidePlatform.particular,
        status: RideStatus.completed,
        originAddress: 'Rua A',
        destinationAddress: 'Rua B',
        grossAmount: 42.5,
        completedAt: DateTime(2026, 1, 10, 14, 30),
        createdAt: DateTime(2026, 1, 10, 14, 30),
        updatedAt: DateTime(2026, 1, 10, 14, 30),
      );

      final message = buildRideReceiptMessage(ride, clientName: 'Maria');

      expect(message, contains('Maria'));
      expect(message, contains('Rua A'));
      expect(message, contains('Rua B'));
      expect(message, contains('R\$'));
      expect(message, contains('10/01/2026'));
    });
  });
}
