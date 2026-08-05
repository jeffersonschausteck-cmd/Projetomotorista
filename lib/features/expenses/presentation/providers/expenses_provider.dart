import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/expenses_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expenses_repository.dart';

part 'expenses_provider.g.dart';

@Riverpod(keepAlive: true)
ExpensesRepository expensesRepository(Ref ref) =>
    ExpensesRepositoryImpl(ref.watch(supabaseClientProvider));

@riverpod
class ExpensesList extends _$ExpensesList {
  @override
  Future<List<Expense>> build() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month);
    final result = await ref
        .watch(expensesRepositoryProvider)
        .getExpenses(from: startOfMonth, to: now);
    return result.when(success: (e) => e, failure: (f) => throw f);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class ExpenseFormController extends _$ExpenseFormController {
  @override
  Failure? build() => null;

  Future<bool> save(Expense expense, {String? existingId}) async {
    state = null;
    final repository = ref.read(expensesRepositoryProvider);
    final result = existingId == null
        ? await repository.createExpense(expense)
        : await repository.updateExpense(expense);

    return result.when(
      success: (_) {
        ref.invalidate(expensesListProvider);
        return true;
      },
      failure: (f) {
        state = f;
        return false;
      },
    );
  }

  Future<bool> delete(String id) async {
    final result = await ref.read(expensesRepositoryProvider).deleteExpense(id);
    return result.when(
      success: (_) {
        ref.invalidate(expensesListProvider);
        return true;
      },
      failure: (f) {
        state = f;
        return false;
      },
    );
  }
}
