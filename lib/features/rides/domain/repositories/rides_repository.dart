import '../../../../core/error/result.dart';
import '../entities/ride.dart';

/// Contrato definido na Fase 0; implementação Supabase (`data/rides_repository_impl.dart`)
/// e UI chegam na Fase 1 junto com a tela de agenda/corridas.
abstract interface class RidesRepository {
  Future<Result<List<Ride>>> getRides({DateTime? from, DateTime? to});
  Future<Result<Ride>> getRideById(String id);
  Future<Result<Ride>> createRide(Ride ride);
  Future<Result<Ride>> updateRide(Ride ride);
  Future<Result<void>> deleteRide(String id);
}
