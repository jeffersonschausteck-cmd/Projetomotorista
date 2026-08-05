// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider = DashboardRepositoryProvider._();

final class DashboardRepositoryProvider
    extends
        $FunctionalProvider<
          DashboardRepository,
          DashboardRepository,
          DashboardRepository
        >
    with $Provider<DashboardRepository> {
  DashboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<DashboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DashboardRepository create(Ref ref) {
    return dashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardRepository>(value),
    );
  }
}

String _$dashboardRepositoryHash() =>
    r'10a0eec971ea7c21c25b6a5c4bc8bc6668dc75fb';

@ProviderFor(dashboardOverview)
final dashboardOverviewProvider = DashboardOverviewProvider._();

final class DashboardOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<DashboardOverview>,
          DashboardOverview,
          FutureOr<DashboardOverview>
        >
    with
        $FutureModifier<DashboardOverview>,
        $FutureProvider<DashboardOverview> {
  DashboardOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardOverviewHash();

  @$internal
  @override
  $FutureProviderElement<DashboardOverview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DashboardOverview> create(Ref ref) {
    return dashboardOverview(ref);
  }
}

String _$dashboardOverviewHash() => r'11012a9894653349b13889181cf89df1eca45642';
