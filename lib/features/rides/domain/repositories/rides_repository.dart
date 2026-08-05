import '../../../../core/error/result.dart';
import '../entities/ride.dart';

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
}
