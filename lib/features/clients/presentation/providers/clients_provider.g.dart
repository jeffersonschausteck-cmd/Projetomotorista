// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientsRepository)
final clientsRepositoryProvider = ClientsRepositoryProvider._();

final class ClientsRepositoryProvider
    extends
        $FunctionalProvider<
          ClientsRepository,
          ClientsRepository,
          ClientsRepository
        >
    with $Provider<ClientsRepository> {
  ClientsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClientsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClientsRepository create(Ref ref) {
    return clientsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientsRepository>(value),
    );
  }
}

String _$clientsRepositoryHash() => r'068c49cf9d3b4b48ea9685afa19b64d2343b1932';

@ProviderFor(ClientsList)
final clientsListProvider = ClientsListProvider._();

final class ClientsListProvider
    extends $AsyncNotifierProvider<ClientsList, List<Client>> {
  ClientsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientsListHash();

  @$internal
  @override
  ClientsList create() => ClientsList();
}

String _$clientsListHash() => r'9122f27cbd223c32c20da665d73475d7c26dd627';

abstract class _$ClientsList extends $AsyncNotifier<List<Client>> {
  FutureOr<List<Client>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Client>>, List<Client>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Client>>, List<Client>>,
              AsyncValue<List<Client>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ClientFormController)
final clientFormControllerProvider = ClientFormControllerProvider._();

final class ClientFormControllerProvider
    extends $NotifierProvider<ClientFormController, Failure?> {
  ClientFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientFormControllerHash();

  @$internal
  @override
  ClientFormController create() => ClientFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Failure? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Failure?>(value),
    );
  }
}

String _$clientFormControllerHash() =>
    r'844d1eed66b5b03fe29a0b570e78ff0ebd8fa809';

abstract class _$ClientFormController extends $Notifier<Failure?> {
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
