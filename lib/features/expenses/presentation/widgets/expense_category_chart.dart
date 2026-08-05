import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/expense.dart';

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

const _categoryColors = {
  ExpenseCategory.fuel: Color(0xFF2563EB),
  ExpenseCategory.toll: Color(0xFF7C3AED),
  ExpenseCategory.wash: Color(0xFF0EA5E9),
  ExpenseCategory.insurance: Color(0xFFD97706),
  ExpenseCategory.ipva: Color(0xFFDC2626),
  ExpenseCategory.tires: Color(0xFF16A34A),
  ExpenseCategory.oilChange: Color(0xFFCA8A04),
  ExpenseCategory.maintenance: Color(0xFF64748B),
  ExpenseCategory.other: Color(0xFF9CA3AF),
};

class ExpenseCategoryChart extends StatelessWidget {
  const ExpenseCategoryChart({required this.expenses, super.key});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) return const SizedBox.shrink();

    final totalsByCategory = <ExpenseCategory, double>{};
    for (final expense in expenses) {
      totalsByCategory.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    final total = totalsByCategory.values.fold<double>(0, (a, b) => a + b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Despesas por categoria', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 32,
                  sections: totalsByCategory.entries.map((entry) {
                    final percentage = total == 0 ? 0 : (entry.value / total) * 100;
                    return PieChartSectionData(
                      value: entry.value,
                      color: _categoryColors[entry.key],
                      title: '${percentage.toStringAsFixed(0)}%',
                      radius: 48,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: totalsByCategory.entries.map((entry) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _categoryColors[entry.key],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(_categoryLabels[entry.key]!, style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
