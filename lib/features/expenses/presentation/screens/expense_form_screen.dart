import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/expense.dart';
import '../providers/expenses_provider.dart';

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

class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen({super.key, this.expense});

  final Expense? expense;

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _amountController = TextEditingController(
    text: widget.expense?.amount.toStringAsFixed(2),
  );
  late final _notesController = TextEditingController(text: widget.expense?.notes);
  late ExpenseCategory _category = widget.expense?.category ?? ExpenseCategory.fuel;
  late DateTime _date = widget.expense?.expenseDate ?? DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _date = date);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final now = DateTime.now();
    final expense = Expense(
      id: widget.expense?.id ?? '',
      driverId: widget.expense?.driverId ?? '',
      category: _category,
      amount: double.parse(_amountController.text.replaceAll(',', '.')),
      expenseDate: _date,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: widget.expense?.createdAt ?? now,
      updatedAt: now,
    );

    final ok = await ref
        .read(expenseFormControllerProvider.notifier)
        .save(expense, existingId: widget.expense?.id);

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (ok) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final failure = ref.watch(expenseFormControllerProvider);
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar despesa' : 'Nova despesa')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<ExpenseCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: _categoryLabels.entries
                      .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Valor (R\$)', prefixText: 'R\$ '),
                  autofocus: !isEditing,
                  validator: (v) {
                    final parsed = double.tryParse((v ?? '').replaceAll(',', '.'));
                    return (parsed == null || parsed <= 0) ? 'Informe um valor válido' : null;
                  },
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text('${_date.day}/${_date.month}/${_date.year}'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Observações (opcional)'),
                  maxLines: 3,
                ),
                if (failure != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    failure.message,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
