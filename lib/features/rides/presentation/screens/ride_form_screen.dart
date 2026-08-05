import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../clients/presentation/providers/clients_provider.dart';
import '../../../clients/presentation/screens/client_form_screen.dart';
import '../../domain/entities/ride.dart';
import '../providers/rides_provider.dart';

const _platformLabels = {
  RidePlatform.particular: 'Particular',
  RidePlatform.uber: 'Uber',
  RidePlatform.p99: '99',
  RidePlatform.inDrive: 'inDrive',
  RidePlatform.maxim: 'Maxim',
  RidePlatform.other: 'Outro',
};

class RideFormScreen extends ConsumerStatefulWidget {
  const RideFormScreen({super.key, this.ride, this.prefill});

  /// Corrida existente sendo editada.
  final Ride? ride;

  /// Rascunho vindo da extração por OCR (Fase 3) — pré-preenche o
  /// formulário de uma corrida NOVA (sem id), sempre pra revisão manual
  /// antes de salvar.
  final Ride? prefill;

  @override
  ConsumerState<RideFormScreen> createState() => _RideFormScreenState();
}

class _RideFormScreenState extends ConsumerState<RideFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final Ride? _source = widget.ride ?? widget.prefill;
  late final _originController = TextEditingController(text: _source?.originAddress);
  late final _destinationController = TextEditingController(text: _source?.destinationAddress);
  late final _valueController = TextEditingController(
    text: _source?.grossAmount?.toStringAsFixed(2),
  );
  late final _categoryController = TextEditingController(text: _source?.category);
  late final _distanceToPickupController = TextEditingController(
    text: _source?.distanceToPickupKm?.toStringAsFixed(1),
  );
  late final _tripDistanceController = TextEditingController(
    text: _source?.tripDistanceKm?.toStringAsFixed(1),
  );
  late final _durationController = TextEditingController(
    text: _source?.estimatedDurationMin?.toString(),
  );
  late final _notesController = TextEditingController(text: _source?.notes);

  String? _clientId;
  RidePlatform _platform = RidePlatform.particular;
  PaymentMethod? _paymentMethod;
  DateTime? _scheduledFor;
  bool _isSubmitting = false;

  bool get _isOcrImport => widget.prefill != null;

  @override
  void initState() {
    super.initState();
    _clientId = widget.ride?.clientId;
    _platform = _source?.platform ?? RidePlatform.particular;
    _paymentMethod = _source?.paymentMethod;
    _scheduledFor = widget.ride?.scheduledAt;
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _valueController.dispose();
    _categoryController.dispose();
    _distanceToPickupController.dispose();
    _tripDistanceController.dispose();
    _durationController.dispose();
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

  double? _parseDouble(String text) =>
      text.trim().isEmpty ? null : double.tryParse(text.trim().replaceAll(',', '.'));

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final isScheduled = _scheduledFor != null && _scheduledFor!.isAfter(DateTime.now());
    final now = DateTime.now();

    final ride = Ride(
      id: widget.ride?.id ?? '',
      driverId: widget.ride?.driverId ?? '',
      clientId: _clientId,
      source: _isOcrImport
          ? RideSource.platformOcr
          : (isScheduled ? RideSource.scheduled : RideSource.manual),
      platform: _platform,
      status: _isOcrImport
          ? RideStatus.pending
          : (isScheduled ? RideStatus.pending : RideStatus.completed),
      originAddress: _originController.text.trim().isEmpty
          ? null
          : _originController.text.trim(),
      destinationAddress: _destinationController.text.trim().isEmpty
          ? null
          : _destinationController.text.trim(),
      scheduledAt: _scheduledFor,
      completedAt: (_isOcrImport || isScheduled) ? null : now,
      grossAmount: _parseDouble(_valueController.text),
      paymentMethod: _paymentMethod,
      distanceToPickupKm: _parseDouble(_distanceToPickupController.text),
      tripDistanceKm: _parseDouble(_tripDistanceController.text),
      estimatedDurationMin: int.tryParse(_durationController.text.trim()),
      category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
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
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Editar corrida'
              : (_isOcrImport ? 'Confirmar corrida importada' : 'Nova corrida'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isOcrImport) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome_outlined, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Dados extraídos da imagem — confira antes de salvar.',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                DropdownButtonFormField<RidePlatform>(
                  initialValue: _platform,
                  decoration: const InputDecoration(labelText: 'Plataforma'),
                  items: _platformLabels.entries
                      .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                      .toList(),
                  onChanged: (value) => setState(() => _platform = value!),
                ),
                if (_platform != RidePlatform.particular) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Categoria (opcional)',
                      helperText: 'Ex: UberX, 99 Comfort',
                    ),
                  ),
                ],
                const SizedBox(height: 16),
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
                if (_isOcrImport) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _distanceToPickupController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Até embarque (km)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _tripDistanceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Corrida (km)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Duração estimada (min)'),
                  ),
                ],
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
