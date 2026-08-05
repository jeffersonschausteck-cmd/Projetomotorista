import '../../../../core/error/result.dart';
import '../entities/ride.dart';
import '../entities/route_point.dart';

abstract interface class RidesRepository {
  Future<Result<List<Ride>>> getRides({DateTime? from, DateTime? to});
  Future<Result<Ride>> getRideById(String id);
  Future<Result<Ride>> createRide(Ride ride);
  Future<Result<Ride>> updateRide(Ride ride);
  Future<Result<void>> deleteRide(String id);

  /// Transição de status com o timestamp correspondente (accepted_at,
  /// cancelled_at...) setado pelo banco — usado pelos usecases de aceite/
  /// recusa/cancelamento, que carregam a regra de negócio real.
  Future<Result<Ride>> updateStatus(String id, RideStatus status);

  /// Finaliza uma corrida rastreada (Fase 4): grava a distância calculada a
  /// partir do GPS e o breadcrumb de pontos, junto com completed_at.
  Future<Result<Ride>> completeRide(
    String id, {
    required double tripDistanceKm,
    required List<RoutePoint> routePoints,
  });
}
