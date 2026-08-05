import '../../../../core/error/result.dart';
import '../entities/expense.dart';

abstract interface class ExpensesRepository {
  Future<Result<List<Expense>>> getExpenses({DateTime? from, DateTime? to});
  Future<Result<Expense>> createExpense(Expense expense);
  Future<Result<Expense>> updateExpense(Expense expense);
  Future<Result<void>> deleteExpense(String id);
}
