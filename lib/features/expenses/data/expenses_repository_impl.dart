import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../domain/entities/expense.dart';
import '../domain/repositories/expenses_repository.dart';
import 'models/expense_model.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _table = 'expenses';

  @override
  Future<Result<List<Expense>>> getExpenses({DateTime? from, DateTime? to}) async {
    try {
      var query = _client.from(_table).select().isFilter('deleted_at', null);
      if (from != null) {
        query = query.gte('expense_date', from.toIso8601String().substring(0, 10));
      }
      if (to != null) {
        query = query.lte('expense_date', to.toIso8601String().substring(0, 10));
      }
      final rows = await query.order('expense_date', ascending: false);
      return Success(rows.map(expenseFromRow).toList());
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Expense>> createExpense(Expense expense) async {
    final driverId = _client.auth.currentUser?.id;
    if (driverId == null) return const Error(AuthFailure('Sessão expirada.'));

    try {
      final row = await _client
          .from(_table)
          .insert(expenseToRow(expense, driverId: driverId))
          .select()
          .single();
      return Success(expenseFromRow(row));
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Expense>> updateExpense(Expense expense) async {
    try {
      final payload = expenseToRow(expense, driverId: expense.driverId)
        ..remove('driver_id');
      final row = await _client
          .from(_table)
          .update(payload)
          .eq('id', expense.id)
          .select()
          .single();
      return Success(expenseFromRow(row));
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteExpense(String id) async {
    try {
      await _client
          .from(_table)
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', id);
      return const Success(null);
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
