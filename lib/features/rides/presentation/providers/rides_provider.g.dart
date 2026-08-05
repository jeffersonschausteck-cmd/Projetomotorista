// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rides_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ridesRepository)
final ridesRepositoryProvider = RidesRepositoryProvider._();

final class RidesRepositoryProvider
    extends
        $FunctionalProvider<RidesRepository, RidesRepository, RidesRepository>
    with $Provider<RidesRepository> {
  RidesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ridesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ridesRepositoryHash();

  @$internal
  @override
  $ProviderElement<RidesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RidesRepository create(Ref ref) {
    return ridesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RidesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RidesRepository>(value),
    );
  }
}

String _$ridesRepositoryHash() => r'eb7693a8848c9b3e5b5fa743db1491c8d7700933';

@ProviderFor(acceptRideUseCase)
final acceptRideUseCaseProvider = AcceptRideUseCaseProvider._();

final class AcceptRideUseCaseProvider
    extends
        $FunctionalProvider<
          AcceptRideUseCase,
          AcceptRideUseCase,
          AcceptRideUseCase
        >
    with $Provider<AcceptRideUseCase> {
  AcceptRideUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceptRideUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceptRideUseCaseHash();

  @$internal
  @override
  $ProviderElement<AcceptRideUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AcceptRideUseCase create(Ref ref) {
    return acceptRideUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceptRideUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceptRideUseCase>(value),
    );
  }
}

String _$acceptRideUseCaseHash() => r'93876245abb91a5c229a186de751bda8a0550241';

@ProviderFor(declineRideUseCase)
final declineRideUseCaseProvider = DeclineRideUseCaseProvider._();

final class DeclineRideUseCaseProvider
    extends
        $FunctionalProvider<
          DeclineRideUseCase,
          DeclineRideUseCase,
          DeclineRideUseCase
        >
    with $Provider<DeclineRideUseCase> {
  DeclineRideUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'declineRideUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$declineRideUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeclineRideUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeclineRideUseCase create(Ref ref) {
    return declineRideUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeclineRideUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeclineRideUseCase>(value),
    );
  }
}

String _$declineRideUseCaseHash() =>
    r'd320320a5c6eedd7592e874fb45bd54e970aaa0d';

@ProviderFor(cancelRideUseCase)
final cancelRideUseCaseProvider = CancelRideUseCaseProvider._();

final class CancelRideUseCaseProvider
    extends
        $FunctionalProvider<
          CancelRideUseCase,
          CancelRideUseCase,
          CancelRideUseCase
        >
    with $Provider<CancelRideUseCase> {
  CancelRideUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelRideUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelRideUseCaseHash();

  @$internal
  @override
  $ProviderElement<CancelRideUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CancelRideUseCase create(Ref ref) {
    return cancelRideUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CancelRideUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CancelRideUseCase>(value),
    );
  }
}

String _$cancelRideUseCaseHash() => r'7c1cd6a870eb7a4bb392867ef255837187329f0f';

@ProviderFor(RidesList)
final ridesListProvider = RidesListProvider._();

final class RidesListProvider
    extends $AsyncNotifierProvider<RidesList, List<Ride>> {
  RidesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ridesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ridesListHash();

  @$internal
  @override
  RidesList create() => RidesList();
}

String _$ridesListHash() => r'bc14b62b41e6db62e9c679b7cf4c023c111526be';

abstract class _$RidesList extends $AsyncNotifier<List<Ride>> {
  FutureOr<List<Ride>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Ride>>, List<Ride>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Ride>>, List<Ride>>,
              AsyncValue<List<Ride>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(RideActionsController)
final rideActionsControllerProvider = RideActionsControllerProvider._();

final class RideActionsControllerProvider
    extends $NotifierProvider<RideActionsController, Failure?> {
  RideActionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rideActionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rideActionsControllerHash();

  @$internal
  @override
  RideActionsController create() => RideActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Failure? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Failure?>(value),
    );
  }
}

String _$rideActionsControllerHash() =>
    r'b944d3fe75dfe619d25591d58949839c927c1c4f';

abstract class _$RideActionsController extends $Notifier<Failure?> {
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

@ProviderFor(RideFormController)
final rideFormControllerProvider = RideFormControllerProvider._();

final class RideFormControllerProvider
    extends $NotifierProvider<RideFormController, Failure?> {
  RideFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rideFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rideFormControllerHash();

  @$internal
  @override
  RideFormController create() => RideFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Failure? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Failure?>(value),
    );
  }
}

String _$rideFormControllerHash() =>
    r'b26d3f425eca817b881c2596af4fc74f85e9d2dc';

abstract class _$RideFormController extends $Notifier<Failure?> {
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
