import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/vehicle.dart';
import '../providers/vehicles_provider.dart';

class VehicleFormScreen extends ConsumerStatefulWidget {
  const VehicleFormScreen({super.key, this.vehicle});

  final Vehicle? vehicle;

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nicknameController = TextEditingController(text: widget.vehicle?.nickname);
  late final _plateController = TextEditingController(text: widget.vehicle?.plate);
  late final _kmController = TextEditingController(
    text: widget.vehicle?.currentKm?.toStringAsFixed(0),
  );
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _plateController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final ok = await ref
        .read(vehicleFormControllerProvider.notifier)
        .save(
          nickname: _nicknameController.text.trim(),
          plate: _plateController.text.trim().isEmpty ? null : _plateController.text.trim(),
          currentKm: double.tryParse(_kmController.text.replaceAll(',', '.')),
          existingId: widget.vehicle?.id,
        );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (ok) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final failure = ref.watch(vehicleFormControllerProvider);
    final isEditing = widget.vehicle != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar veículo' : 'Novo veículo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(labelText: 'Apelido (ex: Onix Prata)'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                  autofocus: !isEditing,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _plateController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Placa (opcional)'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _kmController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'KM atual'),
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
