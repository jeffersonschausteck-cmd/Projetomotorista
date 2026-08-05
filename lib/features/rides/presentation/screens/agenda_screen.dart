import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../ocr/presentation/screens/ride_import_screen.dart';
import '../../domain/entities/ride.dart';
import '../providers/rides_provider.dart';
import '../widgets/ride_card.dart';
import 'ride_form_screen.dart';

class AgendaScreen extends ConsumerStatefulWidget {
  const AgendaScreen({super.key});

  @override
  ConsumerState<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends ConsumerState<AgendaScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ridesAsync = ref.watch(ridesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Corridas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner_outlined),
            tooltip: 'Importar corrida (foto)',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RideImportScreen()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Agenda'), Tab(text: 'Histórico')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RideFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: ridesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar corridas: $error')),
        data: (rides) {
          final agenda = rides
              .where(
                (r) => r.status == RideStatus.pending || r.status == RideStatus.accepted,
              )
              .toList();
          final historico = rides
              .where(
                (r) =>
                    r.status == RideStatus.completed ||
                    r.status == RideStatus.cancelled ||
                    r.status == RideStatus.declined,
              )
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _RidesTab(rides: agenda, emptyMessage: 'Nenhuma corrida agendada.'),
              _RidesTab(rides: historico, emptyMessage: 'Nenhuma corrida no histórico ainda.'),
            ],
          );
        },
      ),
    );
  }
}

class _RidesTab extends ConsumerWidget {
  const _RidesTab({required this.rides, required this.emptyMessage});

  final List<Ride> rides;
  final String emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (rides.isEmpty) {
      return EmptyState(icon: Icons.calendar_today_outlined, message: emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(ridesListProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: rides.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final ride = rides[index];
          final actions = ref.read(rideActionsControllerProvider.notifier);

          return RideCard(
            ride: ride,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => RideFormScreen(ride: ride)),
            ),
            onAccept: ride.status == RideStatus.pending
                ? () => actions.accept(ride.id)
                : null,
            onDecline: ride.status == RideStatus.pending
                ? () => actions.decline(ride.id)
                : null,
            onCancel: ride.status == RideStatus.accepted
                ? () => actions.cancel(ride.id)
                : null,
          );
        },
      ),
    );
  }
}
