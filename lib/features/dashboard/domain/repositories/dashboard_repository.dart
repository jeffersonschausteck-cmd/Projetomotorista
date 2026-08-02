import '../../../../core/error/result.dart';
import '../entities/dashboard_summary.dart';

/// Contrato definido na Fase 0; implementação e UI chegam na Fase 1.
abstract interface class DashboardRepository {
  Future<Result<DashboardSummary>> getSummary({
    required DateTime from,
    required DateTime to,
  });
}
