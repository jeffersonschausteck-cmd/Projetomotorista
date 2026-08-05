import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/earnings_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(dashboardOverviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar o painel: $error')),
        data: (overview) => RefreshIndicator(
          onRefresh: () => ref.refresh(dashboardOverviewProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              EarningsCard(title: 'Hoje', summary: overview.day),
              const SizedBox(height: 12),
              EarningsCard(title: 'Esta semana', summary: overview.week),
              const SizedBox(height: 12),
              EarningsCard(title: 'Este mês', summary: overview.month),
            ],
          ),
        ),
      ),
    );
  }
}
