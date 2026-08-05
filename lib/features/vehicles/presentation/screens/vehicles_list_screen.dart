import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../providers/vehicles_provider.dart';
import 'vehicle_detail_screen.dart';
import 'vehicle_form_screen.dart';

class VehiclesListScreen extends ConsumerWidget {
  const VehiclesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Veículos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const VehicleFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: vehiclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar veículos: $error')),
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return const EmptyState(
              icon: Icons.directions_car_outlined,
              message: 'Nenhum veículo cadastrado ainda.',
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(vehiclesListProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vehicles.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.directions_car_outlined),
                    title: Text(vehicle.nickname),
                    subtitle: vehicle.plate != null ? Text(vehicle.plate!) : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailScreen(vehicle: vehicle),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
