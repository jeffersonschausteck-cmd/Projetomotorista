import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/maintenance_reminder.dart';
import '../../domain/entities/vehicle.dart';
import '../providers/vehicles_provider.dart';
import '../widgets/maintenance_alert_banner.dart';
import 'maintenance_reminder_form_screen.dart';
import 'vehicle_form_screen.dart';

const _typeLabels = {
  MaintenanceType.oilChange: 'Troca de óleo',
  MaintenanceType.revision: 'Revisão',
  MaintenanceType.tires: 'Pneus',
  MaintenanceType.insurance: 'Seguro',
  MaintenanceType.ipva: 'IPVA',
  MaintenanceType.documentation: 'Documentação',
  MaintenanceType.other: 'Outro',
};

class VehicleDetailScreen extends ConsumerWidget {
  const VehicleDetailScreen({required this.vehicle, super.key});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(remindersForVehicleProvider(vehicle.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.nickname),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar veículo',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => VehicleFormScreen(vehicle: vehicle)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MaintenanceReminderFormScreen(vehicleId: vehicle.id),
          ),
        ),
        child: const Icon(Icons.add_alert_outlined),
      ),
      body: remindersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar lembretes: $error')),
        data: (reminders) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(remindersForVehicleProvider(vehicle.id).notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (vehicle.plate != null || vehicle.currentKm != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (vehicle.plate != null) Text('Placa: ${vehicle.plate}'),
                          if (vehicle.currentKm != null)
                            Text('${vehicle.currentKm!.toStringAsFixed(0)} km'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                MaintenanceAlertBanner(reminders: reminders, currentKm: vehicle.currentKm),
                const SizedBox(height: 12),
                if (reminders.isEmpty)
                  const EmptyState(
                    icon: Icons.build_outlined,
                    message: 'Nenhum lembrete de manutenção cadastrado.',
                  )
                else
                  ...reminders.map((reminder) {
                    final status = reminder.statusFor(currentKm: vehicle.currentKm);
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          switch (status) {
                            ReminderStatus.overdue => Icons.error_outline,
                            ReminderStatus.upcoming => Icons.warning_amber_outlined,
                            ReminderStatus.ok => Icons.check_circle_outline,
                          },
                          color: switch (status) {
                            ReminderStatus.overdue => Theme.of(context).colorScheme.error,
                            ReminderStatus.upcoming => Colors.orange,
                            ReminderStatus.ok => Colors.green,
                          },
                        ),
                        title: Text(_typeLabels[reminder.type]!),
                        subtitle: Text([
                          if (reminder.dueKm != null) 'até ${reminder.dueKm!.toStringAsFixed(0)} km',
                          if (reminder.dueDate != null)
                            'até ${reminder.dueDate!.day}/${reminder.dueDate!.month}/${reminder.dueDate!.year}',
                        ].join(' • ')),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MaintenanceReminderFormScreen(
                              vehicleId: vehicle.id,
                              reminder: reminder,
                            ),
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
