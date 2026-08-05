import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../clients/presentation/providers/clients_provider.dart';
import '../../../clients/presentation/screens/client_form_screen.dart';
import '../../domain/entities/ride.dart';
import '../providers/rides_provider.dart';

class RideFormScreen extends ConsumerStatefulWidget {
  const RideFormScreen({super.key, this.ride});

  final Ride? ride;

  @override
  ConsumerState<RideFormScreen> createState() => _RideFormScreenState();
}

class _RideFormScreenState extends ConsumerState<RideFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _originController = TextEditingController(text: widget.ride?.originAddress);
  late final _destinationController = TextEditingController(
    text: widget.ride?.destinationAddress,
  );
  late final _valueController = TextEditingController(
    text: widget.ride?.grossAmount?.toStringAsFixed(2),
  );
  late final _notesController = TextEditingController(text: widget.ride?.notes);

  String? _clientId;
  PaymentMethod? _paymentMethod;
  DateTime? _scheduledFor;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _clientId = widget.ride?.clientId;
    _paymentMethod = widget.ride?.paymentMethod;
    _scheduledFor = widget.ride?.scheduledAt;
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickSchedule() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledFor ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledFor ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      _scheduledFor = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _createClientInline() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const ClientFormScreen()),
    );
    final clients = await ref.read(clientsListProvider.future);
    if (clients.isNotEmpty && mounted) {
      setState(() => _clientId = clients.first.id);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final isScheduled = _scheduledFor != null && _scheduledFor!.isAfter(DateTime.now());
    final now = DateTime.now();

    final ride = Ride(
      id: widget.ride?.id ?? '',
      driverId: widget.ride?.driverId ?? '',
      clientId: _clientId,
      source: isScheduled ? RideSource.scheduled : RideSource.manual,
      platform: RidePlatform.particular,
      status: isScheduled ? RideStatus.pending : RideStatus.completed,
      originAddress: _originController.text.trim().isEmpty
          ? null
          : _originController.text.trim(),
      destinationAddress: _destinationController.text.trim().isEmpty
          ? null
          : _destinationController.text.trim(),
      scheduledAt: _scheduledFor,
      completedAt: isScheduled ? null : now,
      grossAmount: double.tryParse(_valueController.text.replaceAll(',', '.')),
      paymentMethod: _paymentMethod,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: widget.ride?.createdAt ?? now,
      updatedAt: now,
    );

    final ok = await ref
        .read(rideFormControllerProvider.notifier)
        .save(ride, existingId: widget.ride?.id);

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (ok) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final failure = ref.watch(rideFormControllerProvider);
    final clientsAsync = ref.watch(clientsListProvider);
    final isEditing = widget.ride != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar corrida' : 'Nova corrida')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                clientsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (clients) => Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          initialValue: _clientId,
                          decoration: const InputDecoration(labelText: 'Cliente (opcional)'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Sem cliente')),
                            ...clients.map(
                              (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                            ),
                          ],
                          onChanged: (value) => setState(() => _clientId = value),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_add_outlined),
                        tooltip: 'Novo cliente',
                        onPressed: _createClientInline,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _originController,
                  decoration: const InputDecoration(labelText: 'Origem'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(labelText: 'Destino'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valueController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Valor (R\$)', prefixText: 'R\$ '),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PaymentMethod?>(
                  initialValue: _paymentMethod,
                  decoration: const InputDecoration(labelText: 'Forma de pagamento'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Não informado')),
                    DropdownMenuItem(value: PaymentMethod.cash, child: Text('Dinheiro')),
                    DropdownMenuItem(value: PaymentMethod.pix, child: Text('PIX')),
                    DropdownMenuItem(value: PaymentMethod.card, child: Text('Cartão')),
                    DropdownMenuItem(value: PaymentMethod.app, child: Text('App')),
                  ],
                  onChanged: (value) => setState(() => _paymentMethod = value),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _pickSchedule,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(
                    _scheduledFor == null
                        ? 'Corrida já realizada (toque para agendar)'
                        : 'Agendada para ${_scheduledFor!.day}/${_scheduledFor!.month} às '
                              '${_scheduledFor!.hour}:${_scheduledFor!.minute.toString().padLeft(2, '0')}',
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
      ),
    );
  }
}
