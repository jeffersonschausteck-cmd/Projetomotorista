import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/maintenance_reminder.dart';
import '../providers/vehicles_provider.dart';

const _typeLabels = {
  MaintenanceType.oilChange: 'Troca de óleo',
  MaintenanceType.revision: 'Revisão',
  MaintenanceType.tires: 'Pneus',
  MaintenanceType.insurance: 'Seguro',
  MaintenanceType.ipva: 'IPVA',
  MaintenanceType.documentation: 'Documentação',
  MaintenanceType.other: 'Outro',
};

class MaintenanceReminderFormScreen extends ConsumerStatefulWidget {
  const MaintenanceReminderFormScreen({
    required this.vehicleId,
    super.key,
    this.reminder,
  });

  final String vehicleId;
  final MaintenanceReminder? reminder;

  @override
  ConsumerState<MaintenanceReminderFormScreen> createState() =>
      _MaintenanceReminderFormScreenState();
}

class _MaintenanceReminderFormScreenState
    extends ConsumerState<MaintenanceReminderFormScreen> {
  late MaintenanceType _type = widget.reminder?.type ?? MaintenanceType.oilChange;
  late final _dueKmController = TextEditingController(
    text: widget.reminder?.dueKm?.toStringAsFixed(0),
  );
  late DateTime? _dueDate = widget.reminder?.dueDate;
  late final _notesController = TextEditingController(text: widget.reminder?.notes);
  bool _isSubmitting = false;

  @override
  void dispose() {
    _dueKmController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    final now = DateTime.now();
    final reminder = MaintenanceReminder(
      id: widget.reminder?.id ?? '',
      driverId: widget.reminder?.driverId ?? '',
      vehicleId: widget.vehicleId,
      type: _type,
      dueKm: double.tryParse(_dueKmController.text.replaceAll(',', '.')),
      dueDate: _dueDate,
      isActive: true,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: widget.reminder?.createdAt ?? now,
      updatedAt: now,
    );

    final ok = await ref
        .read(reminderFormControllerProvider.notifier)
        .save(reminder, existingId: widget.reminder?.id);

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (ok) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final failure = ref.watch(reminderFormControllerProvider);
    final isEditing = widget.reminder != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar lembrete' : 'Novo lembrete')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<MaintenanceType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: _typeLabels.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (value) => setState(() => _type = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dueKmController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Vence no KM (opcional)',
                  helperText: 'Deixe em branco se for só por data',
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  _dueDate == null
                      ? 'Vence em (opcional)'
                      : 'Vence em ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                ),
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
    );
  }
}
