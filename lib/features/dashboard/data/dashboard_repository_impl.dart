import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../domain/entities/dashboard_summary.dart';
import '../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<DashboardSummary>> getSummary({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final rows = await _client.rpc(
        'get_dashboard_summary',
        params: {
          'period_from': from.toIso8601String(),
          'period_to': to.toIso8601String(),
        },
      );
      final row = (rows as List).single as Map<String, dynamic>;
      return Success(
        DashboardSummary(
          periodStart: from,
          periodEnd: to,
          totalRides: row['total_rides'] as int,
          grossAmount: (row['gross_amount'] as num).toDouble(),
          totalKm: (row['total_km'] as num).toDouble(),
        ),
      );
    } on PostgrestException catch (e) {
      return Error(UnexpectedFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
