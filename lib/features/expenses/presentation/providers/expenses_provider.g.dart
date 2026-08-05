// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expensesRepository)
final expensesRepositoryProvider = ExpensesRepositoryProvider._();

final class ExpensesRepositoryProvider
    extends
        $FunctionalProvider<
          ExpensesRepository,
          ExpensesRepository,
          ExpensesRepository
        >
    with $Provider<ExpensesRepository> {
  ExpensesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expensesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expensesRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpensesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpensesRepository create(Ref ref) {
    return expensesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpensesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpensesRepository>(value),
    );
  }
}

String _$expensesRepositoryHash() =>
    r'a8c75868a1b60df35a030fdde9626bc8eed3ffad';

@ProviderFor(ExpensesList)
final expensesListProvider = ExpensesListProvider._();

final class ExpensesListProvider
    extends $AsyncNotifierProvider<ExpensesList, List<Expense>> {
  ExpensesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expensesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expensesListHash();

  @$internal
  @override
  ExpensesList create() => ExpensesList();
}

String _$expensesListHash() => r'e226b6f0036085566924d04643f0b959cba9de65';

abstract class _$ExpensesList extends $AsyncNotifier<List<Expense>> {
  FutureOr<List<Expense>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Expense>>, List<Expense>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Expense>>, List<Expense>>,
              AsyncValue<List<Expense>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ExpenseFormController)
final expenseFormControllerProvider = ExpenseFormControllerProvider._();

final class ExpenseFormControllerProvider
    extends $NotifierProvider<ExpenseFormController, Failure?> {
  ExpenseFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseFormControllerHash();

  @$internal
  @override
  ExpenseFormController create() => ExpenseFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Failure? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Failure?>(value),
    );
  }
}

String _$expenseFormControllerHash() =>
    r'2e79a1a0594006e1da1a42315ef189c4efcf60ee';

abstract class _$ExpenseFormController extends $Notifier<Failure?> {
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
