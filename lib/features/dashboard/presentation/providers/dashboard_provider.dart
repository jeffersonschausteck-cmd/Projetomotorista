import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../data/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_provider.g.dart';

@Riverpod(keepAlive: true)
DashboardRepository dashboardRepository(Ref ref) =>
    DashboardRepositoryImpl(ref.watch(supabaseClientProvider));

typedef DashboardOverview = ({
  DashboardSummary day,
  DashboardSummary week,
  DashboardSummary month,
});

@riverpod
Future<DashboardOverview> dashboardOverview(Ref ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final startOfWeek = startOfDay.subtract(Duration(days: now.weekday - 1));
  final startOfMonth = DateTime(now.year, now.month);

  Future<DashboardSummary> fetch(DateTime from) async {
    final result = await repository.getSummary(from: from, to: now);
    return result.when(success: (s) => s, failure: (f) => throw f);
  }

  final results = await Future.wait([
    fetch(startOfDay),
    fetch(startOfWeek),
    fetch(startOfMonth),
  ]);

  return (day: results[0], week: results[1], month: results[2]);
}
