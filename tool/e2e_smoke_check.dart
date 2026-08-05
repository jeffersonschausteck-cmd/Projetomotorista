// Checagem manual de integração contra um Supabase real (não roda no CI nem
// em `flutter test` — fica fora de test/ de propósito, porque depende de
// rede e de um projeto provisionado). Usa o código de produção das camadas
// data (AuthRepositoryImpl, ClientsRepositoryImpl, RidesRepositoryImpl,
// DashboardRepositoryImpl) para validar signUp/signIn/trigger/RLS e o CRUD
// da Fase 1 de ponta a ponta contra o backend.
//
// Pré-requisito: exista um usuário de teste com e-mail confirmado em
// teste.motorando@exemplo.com / SenhaForte123! (ou ajuste as constantes
// abaixo para outro usuário do seu projeto).
//
// Rodar com:
//   flutter test tool/e2e_smoke_check.dart --dart-define-from-file=dart_define.json

import 'package:driver_platform/core/error/result.dart';
import 'package:driver_platform/features/auth/data/auth_repository_impl.dart';
import 'package:driver_platform/features/clients/data/clients_repository_impl.dart';
import 'package:driver_platform/features/clients/domain/entities/client.dart';
import 'package:driver_platform/features/dashboard/data/dashboard_repository_impl.dart';
import 'package:driver_platform/features/expenses/data/expenses_repository_impl.dart';
import 'package:driver_platform/features/expenses/domain/entities/expense.dart';
import 'package:driver_platform/features/rides/data/rides_repository_impl.dart';
import 'package:driver_platform/features/rides/domain/entities/ride.dart';
import 'package:driver_platform/features/vehicles/data/maintenance_reminders_repository_impl.dart';
import 'package:driver_platform/features/vehicles/data/vehicles_repository_impl.dart';
import 'package:driver_platform/features/vehicles/domain/entities/maintenance_reminder.dart';
import 'package:driver_platform/features/vehicles/domain/entities/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _url = String.fromEnvironment('SUPABASE_URL');
const _key = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
const _testEmail = 'teste.motorando@exemplo.com';
const _testPassword = 'SenhaForte123!';

SupabaseClient _newClient() => SupabaseClient(
  _url,
  _key,
  // authFlowType: implicit evita a asserção de storage assíncrono do PKCE,
  // que só existe porque este harness usa SupabaseClient puro. O app real
  // usa Supabase.initialize() (supabase_flutter), que já provê esse storage.
  authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
);

void main() {
  group('Auth (Fase 0)', () {
    late SupabaseClient client;
    late AuthRepositoryImpl repository;

    setUpAll(() {
      client = _newClient();
      repository = AuthRepositoryImpl(client);
    });

    test('signInWithPassword autentica o usuário de teste real', () async {
      final result = await repository.signInWithPassword(
        email: _testEmail,
        password: _testPassword,
      );

      expect(result, isA<Success<void>>());
      expect(repository.currentUser, isNotNull);
      expect(repository.currentUser!.email, _testEmail);
    });

    test('signOut limpa a sessão', () async {
      await repository.signOut();
      expect(repository.currentUser, isNull);
    });

    test('signInWithPassword falha com senha errada', () async {
      final result = await repository.signInWithPassword(
        email: _testEmail,
        password: 'senha-errada',
      );

      expect(result, isA<Error<void>>());
    });

    test('signUpWithPassword cria o usuário (trigger cria profiles à parte)', () async {
      final email = 'e2e-${DateTime.now().microsecondsSinceEpoch}@exemplo.com';
      final result = await repository.signUpWithPassword(
        email: email,
        password: _testPassword,
        fullName: 'Usuário E2E',
      );

      result.when(
        success: (_) {},
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );
    });
  });

  group('Clients + Rides + Dashboard (Fase 1)', () {
    late SupabaseClient client;
    late ClientsRepositoryImpl clientsRepository;
    late RidesRepositoryImpl ridesRepository;
    late DashboardRepositoryImpl dashboardRepository;
    late String createdClientId;
    late String createdRideId;

    setUpAll(() async {
      client = _newClient();
      await client.auth.signInWithPassword(email: _testEmail, password: _testPassword);
      clientsRepository = ClientsRepositoryImpl(client);
      ridesRepository = RidesRepositoryImpl(client);
      dashboardRepository = DashboardRepositoryImpl(client);
    });

    tearDownAll(() async {
      await client.auth.signOut();
    });

    test('createClient grava e getClients traz o cliente criado', () async {
      final draft = Client(
        id: '',
        driverId: '',
        name: 'Cliente E2E ${DateTime.now().microsecondsSinceEpoch}',
        phone: '11999999999',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await clientsRepository.createClient(draft);
      created.when(
        success: (c) => createdClientId = c.id,
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );

      final list = await clientsRepository.getClients();
      list.when(
        success: (clients) =>
            expect(clients.any((c) => c.id == createdClientId), isTrue),
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );
    });

    test('createRide grava vinculada ao cliente criado', () async {
      final draft = Ride(
        id: '',
        driverId: '',
        clientId: createdClientId,
        source: RideSource.manual,
        platform: RidePlatform.particular,
        status: RideStatus.completed,
        originAddress: 'Origem E2E',
        destinationAddress: 'Destino E2E',
        grossAmount: 55,
        paymentMethod: PaymentMethod.pix,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await ridesRepository.createRide(draft);
      created.when(
        success: (r) {
          createdRideId = r.id;
          expect(r.clientId, createdClientId);
          expect(r.status, RideStatus.completed);
        },
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );
    });

    test('updateStatus (via CancelRideUseCase) seta cancelled_at', () async {
      final result = await ridesRepository.updateStatus(
        createdRideId,
        RideStatus.cancelled,
      );
      result.when(
        success: (r) {
          expect(r.status, RideStatus.cancelled);
          expect(r.cancelledAt, isNotNull);
        },
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );
    });

    test('getSummary (RPC get_dashboard_summary) agrega corridas completed', () async {
      // a corrida criada acima já foi cancelada — cria outra completed para
      // garantir que o RPC tem o que agregar neste período.
      await ridesRepository.createRide(
        Ride(
          id: '',
          driverId: '',
          clientId: createdClientId,
          source: RideSource.manual,
          platform: RidePlatform.particular,
          status: RideStatus.completed,
          grossAmount: 30,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final now = DateTime.now();
      final result = await dashboardRepository.getSummary(
        from: DateTime(now.year, now.month, now.day),
        to: now.add(const Duration(minutes: 1)),
      );

      result.when(
        success: (summary) => expect(summary.totalRides, greaterThanOrEqualTo(1)),
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );
    });

    test('deleteClient faz soft delete (some da listagem)', () async {
      final deleted = await clientsRepository.deleteClient(createdClientId);
      expect(deleted, isA<Success<void>>());

      final list = await clientsRepository.getClients();
      list.when(
        success: (clients) =>
            expect(clients.any((c) => c.id == createdClientId), isFalse),
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );
    });
  });

  group('Vehicles + Maintenance + Expenses + lucro líquido (Fase 2)', () {
    late SupabaseClient client;
    late VehiclesRepositoryImpl vehiclesRepository;
    late MaintenanceRemindersRepositoryImpl remindersRepository;
    late ExpensesRepositoryImpl expensesRepository;
    late RidesRepositoryImpl ridesRepository;
    late DashboardRepositoryImpl dashboardRepository;
    late String createdVehicleId;

    setUpAll(() async {
      client = _newClient();
      await client.auth.signInWithPassword(email: _testEmail, password: _testPassword);
      vehiclesRepository = VehiclesRepositoryImpl(client);
      remindersRepository = MaintenanceRemindersRepositoryImpl(client);
      expensesRepository = ExpensesRepositoryImpl(client);
      ridesRepository = RidesRepositoryImpl(client);
      dashboardRepository = DashboardRepositoryImpl(client);
    });

    tearDownAll(() async {
      await client.auth.signOut();
    });

    test('createVehicle grava e getVehicles traz o veículo criado', () async {
      final draft = Vehicle(
        id: '',
        driverId: '',
        nickname: 'Onix E2E',
        currentKm: 9800,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await vehiclesRepository.createVehicle(draft);
      created.when(
        success: (v) => createdVehicleId = v.id,
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );

      final list = await vehiclesRepository.getVehicles();
      list.when(
        success: (vehicles) =>
            expect(vehicles.any((v) => v.id == createdVehicleId), isTrue),
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );
    });

    test('createReminder grava vinculado ao veículo e status bate com o KM real', () async {
      final draft = MaintenanceReminder(
        id: '',
        driverId: '',
        vehicleId: createdVehicleId,
        type: MaintenanceType.oilChange,
        dueKm: 10000,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await remindersRepository.createReminder(draft);
      created.when(
        success: (r) => expect(r.statusFor(currentKm: 9800), ReminderStatus.upcoming),
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );

      final list = await remindersRepository.getReminders(vehicleId: createdVehicleId);
      list.when(
        success: (reminders) => expect(reminders, isNotEmpty),
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );
    });

    test('createExpense grava e entra no cálculo de lucro líquido do dashboard', () async {
      final now = DateTime.now();

      // garante uma corrida completed hoje para ter receita bruta > 0
      await ridesRepository.createRide(
        Ride(
          id: '',
          driverId: '',
          source: RideSource.manual,
          platform: RidePlatform.particular,
          status: RideStatus.completed,
          grossAmount: 100,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final expenseDraft = Expense(
        id: '',
        driverId: '',
        vehicleId: createdVehicleId,
        category: ExpenseCategory.fuel,
        amount: 40,
        expenseDate: now,
        createdAt: now,
        updatedAt: now,
      );
      final createdExpense = await expensesRepository.createExpense(expenseDraft);
      expect(createdExpense, isA<Success<Expense>>());

      final summary = await dashboardRepository.getSummary(
        from: DateTime(now.year, now.month, now.day),
        to: now.add(const Duration(minutes: 1)),
      );

      summary.when(
        success: (s) {
          expect(s.totalExpenses, greaterThanOrEqualTo(40));
          expect(s.netAmount, closeTo(s.grossAmount - s.totalExpenses, 0.01));
        },
        failure: (f) => fail('${f.runtimeType}: ${f.message}'),
      );
    });
  });
}
