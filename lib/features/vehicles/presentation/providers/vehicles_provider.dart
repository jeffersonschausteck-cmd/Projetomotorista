import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/maintenance_reminders_repository_impl.dart';
import '../../data/vehicles_repository_impl.dart';
import '../../domain/entities/maintenance_reminder.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/maintenance_reminders_repository.dart';
import '../../domain/repositories/vehicles_repository.dart';

part 'vehicles_provider.g.dart';

@Riverpod(keepAlive: true)
VehiclesRepository vehiclesRepository(Ref ref) =>
    VehiclesRepositoryImpl(ref.watch(supabaseClientProvider));

@Riverpod(keepAlive: true)
MaintenanceRemindersRepository maintenanceRemindersRepository(Ref ref) =>
    MaintenanceRemindersRepositoryImpl(ref.watch(supabaseClientProvider));

@riverpod
class VehiclesList extends _$VehiclesList {
  @override
  Future<List<Vehicle>> build() async {
    final result = await ref.watch(vehiclesRepositoryProvider).getVehicles();
    return result.when(success: (v) => v, failure: (f) => throw f);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class RemindersForVehicle extends _$RemindersForVehicle {
  @override
  Future<List<MaintenanceReminder>> build(String vehicleId) async {
    final result = await ref
        .watch(maintenanceRemindersRepositoryProvider)
        .getReminders(vehicleId: vehicleId);
    return result.when(success: (r) => r, failure: (f) => throw f);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class VehicleFormController extends _$VehicleFormController {
  @override
  Failure? build() => null;

  Future<bool> save({
    required String nickname,
    String? plate,
    double? currentKm,
    String? existingId,
  }) async {
    state = null;
    final repository = ref.read(vehiclesRepositoryProvider);
    final placeholder = Vehicle(
      id: existingId ?? '',
      driverId: '',
      nickname: nickname,
      plate: plate,
      currentKm: currentKm,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = existingId == null
        ? await repository.createVehicle(placeholder)
        : await repository.updateVehicle(placeholder);

    return result.when(
      success: (_) {
        ref.invalidate(vehiclesListProvider);
        return true;
      },
      failure: (f) {
        state = f;
        return false;
      },
    );
  }
}

@riverpod
class ReminderFormController extends _$ReminderFormController {
  @override
  Failure? build() => null;

  Future<bool> save(MaintenanceReminder reminder, {String? existingId}) async {
    state = null;
    final repository = ref.read(maintenanceRemindersRepositoryProvider);
    final result = existingId == null
        ? await repository.createReminder(reminder)
        : await repository.updateReminder(reminder);

    return result.when(
      success: (_) {
        ref.invalidate(remindersForVehicleProvider(reminder.vehicleId));
        return true;
      },
      failure: (f) {
        state = f;
        return false;
      },
    );
  }
}
