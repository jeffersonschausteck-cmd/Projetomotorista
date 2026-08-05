// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicles_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vehiclesRepository)
final vehiclesRepositoryProvider = VehiclesRepositoryProvider._();

final class VehiclesRepositoryProvider
    extends
        $FunctionalProvider<
          VehiclesRepository,
          VehiclesRepository,
          VehiclesRepository
        >
    with $Provider<VehiclesRepository> {
  VehiclesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehiclesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehiclesRepositoryHash();

  @$internal
  @override
  $ProviderElement<VehiclesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VehiclesRepository create(Ref ref) {
    return vehiclesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VehiclesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VehiclesRepository>(value),
    );
  }
}

String _$vehiclesRepositoryHash() =>
    r'5a50c13a917bd4ce84a766597c81b17818e77f9b';

@ProviderFor(maintenanceRemindersRepository)
final maintenanceRemindersRepositoryProvider =
    MaintenanceRemindersRepositoryProvider._();

final class MaintenanceRemindersRepositoryProvider
    extends
        $FunctionalProvider<
          MaintenanceRemindersRepository,
          MaintenanceRemindersRepository,
          MaintenanceRemindersRepository
        >
    with $Provider<MaintenanceRemindersRepository> {
  MaintenanceRemindersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceRemindersRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceRemindersRepositoryHash();

  @$internal
  @override
  $ProviderElement<MaintenanceRemindersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MaintenanceRemindersRepository create(Ref ref) {
    return maintenanceRemindersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MaintenanceRemindersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MaintenanceRemindersRepository>(
        value,
      ),
    );
  }
}

String _$maintenanceRemindersRepositoryHash() =>
    r'4cc318b668843553f05538aed9f4b834eb2f2e06';

@ProviderFor(VehiclesList)
final vehiclesListProvider = VehiclesListProvider._();

final class VehiclesListProvider
    extends $AsyncNotifierProvider<VehiclesList, List<Vehicle>> {
  VehiclesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehiclesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehiclesListHash();

  @$internal
  @override
  VehiclesList create() => VehiclesList();
}

String _$vehiclesListHash() => r'f4f1770374198cf691c465ee7112da513b8a7338';

abstract class _$VehiclesList extends $AsyncNotifier<List<Vehicle>> {
  FutureOr<List<Vehicle>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Vehicle>>, List<Vehicle>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Vehicle>>, List<Vehicle>>,
              AsyncValue<List<Vehicle>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(RemindersForVehicle)
final remindersForVehicleProvider = RemindersForVehicleFamily._();

final class RemindersForVehicleProvider
    extends
        $AsyncNotifierProvider<RemindersForVehicle, List<MaintenanceReminder>> {
  RemindersForVehicleProvider._({
    required RemindersForVehicleFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'remindersForVehicleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$remindersForVehicleHash();

  @override
  String toString() {
    return r'remindersForVehicleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RemindersForVehicle create() => RemindersForVehicle();

  @override
  bool operator ==(Object other) {
    return other is RemindersForVehicleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$remindersForVehicleHash() =>
    r'91b3833698b853ad57b8c593bc98ab154e80d289';

final class RemindersForVehicleFamily extends $Family
    with
        $ClassFamilyOverride<
          RemindersForVehicle,
          AsyncValue<List<MaintenanceReminder>>,
          List<MaintenanceReminder>,
          FutureOr<List<MaintenanceReminder>>,
          String
        > {
  RemindersForVehicleFamily._()
    : super(
        retry: null,
        name: r'remindersForVehicleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RemindersForVehicleProvider call(String vehicleId) =>
      RemindersForVehicleProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'remindersForVehicleProvider';
}

abstract class _$RemindersForVehicle
    extends $AsyncNotifier<List<MaintenanceReminder>> {
  late final _$args = ref.$arg as String;
  String get vehicleId => _$args;

  FutureOr<List<MaintenanceReminder>> build(String vehicleId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MaintenanceReminder>>,
              List<MaintenanceReminder>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MaintenanceReminder>>,
                List<MaintenanceReminder>
              >,
              AsyncValue<List<MaintenanceReminder>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(VehicleFormController)
final vehicleFormControllerProvider = VehicleFormControllerProvider._();

final class VehicleFormControllerProvider
    extends $NotifierProvider<VehicleFormController, Failure?> {
  VehicleFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicleFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicleFormControllerHash();

  @$internal
  @override
  VehicleFormController create() => VehicleFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Failure? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Failure?>(value),
    );
  }
}

String _$vehicleFormControllerHash() =>
    r'94d33687774a7399c7ff9e90d4ff75c25d23bc57';

abstract class _$VehicleFormController extends $Notifier<Failure?> {
  Failure? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Failure?, Failure?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Failure?, Failure?>,
              Failure?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ReminderFormController)
final reminderFormControllerProvider = ReminderFormControllerProvider._();

final class ReminderFormControllerProvider
    extends $NotifierProvider<ReminderFormController, Failure?> {
  ReminderFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderFormControllerHash();

  @$internal
  @override
  ReminderFormController create() => ReminderFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Failure? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Failure?>(value),
    );
  }
}

String _$reminderFormControllerHash() =>
    r'978ed57a8f616f7297953341474b63011bf90f8f';

abstract class _$ReminderFormController extends $Notifier<Failure?> {
  Failure? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Failure?, Failure?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Failure?, Failure?>,
              Failure?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
