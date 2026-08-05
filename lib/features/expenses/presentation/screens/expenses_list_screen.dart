import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/expense.dart';
import '../providers/expenses_provider.dart';
import '../widgets/expense_category_chart.dart';
import 'expense_form_screen.dart';

const _categoryLabels = {
  ExpenseCategory.fuel: 'Combustível',
  ExpenseCategory.toll: 'Pedágio',
  ExpenseCategory.wash: 'Lavagem',
  ExpenseCategory.insurance: 'Seguro',
  ExpenseCategory.ipva: 'IPVA',
  ExpenseCategory.tires: 'Pneus',
  ExpenseCategory.oilChange: 'Troca de óleo',
  ExpenseCategory.maintenance: 'Revisão',
  ExpenseCategory.other: 'Outros',
};

class ExpensesListScreen extends ConsumerWidget {
  const ExpensesListScreen({super.key});

  static final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Financeiro')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ExpenseFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar despesas: $error')),
        data: (expenses) {
          if (expenses.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              message: 'Nenhuma despesa registrada este mês.',
            );
          }
          final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);

          return RefreshIndicator(
            onRefresh: () => ref.read(expensesListProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total do mês'),
                        Text(
                          _currencyFormat.format(total),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ExpenseCategoryChart(expenses: expenses),
                const SizedBox(height: 12),
                ...expenses.map((expense) {
                  return Card(
                    child: ListTile(
                      title: Text(_categoryLabels[expense.category]!),
                      subtitle: Text(
                        '${expense.expenseDate.day}/${expense.expenseDate.month}/${expense.expenseDate.year}'
                        '${expense.notes != null ? ' • ${expense.notes}' : ''}',
                      ),
                      trailing: Text(_currencyFormat.format(expense.amount)),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ExpenseFormScreen(expense: expense),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
