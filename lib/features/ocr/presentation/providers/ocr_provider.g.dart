// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ocrRepository)
final ocrRepositoryProvider = OcrRepositoryProvider._();

final class OcrRepositoryProvider
    extends $FunctionalProvider<OcrRepository, OcrRepository, OcrRepository>
    with $Provider<OcrRepository> {
  OcrRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ocrRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ocrRepositoryHash();

  @$internal
  @override
  $ProviderElement<OcrRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OcrRepository create(Ref ref) {
    return ocrRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OcrRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OcrRepository>(value),
    );
  }
}

String _$ocrRepositoryHash() => r'30c420c283834fb8dd2b15ab60d17ee375ed505c';

@ProviderFor(RideImportController)
final rideImportControllerProvider = RideImportControllerProvider._();

final class RideImportControllerProvider
    extends $NotifierProvider<RideImportController, Failure?> {
  RideImportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rideImportControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rideImportControllerHash();

  @$internal
  @override
  RideImportController create() => RideImportController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Failure? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Failure?>(value),
    );
  }
}

String _$rideImportControllerHash() =>
    r'452063be3c3cde239d1f2a0c97b1366687d5a465';

abstract class _$RideImportController extends $Notifier<Failure?> {
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
