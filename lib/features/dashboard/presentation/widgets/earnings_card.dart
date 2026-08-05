import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/dashboard_summary.dart';

class EarningsCard extends StatelessWidget {
  const EarningsCard({required this.title, required this.summary, super.key});

  final String title;
  final DashboardSummary summary;

  static final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _currencyFormat.format(summary.grossAmount),
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'bruto',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            Text(
              '${_currencyFormat.format(summary.netAmount)} líquido',
              style: TextStyle(
                color: summary.netAmount >= 0 ? Colors.green : Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Stat(label: 'Corridas', value: '${summary.totalRides}'),
                const SizedBox(width: 24),
                _Stat(label: 'KM rodado', value: summary.totalKm.toStringAsFixed(1)),
                const SizedBox(width: 24),
                _Stat(
                  label: 'R\$/KM',
                  value: summary.amountPerKm.toStringAsFixed(2),
                ),
                const SizedBox(width: 24),
                _Stat(
                  label: 'Despesas',
                  value: _currencyFormat.format(summary.totalExpenses),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface)),
        Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
      ],
    );
  }
}
