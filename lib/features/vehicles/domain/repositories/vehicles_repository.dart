import '../../../../core/error/result.dart';
import '../entities/vehicle.dart';

/// Contrato definido na Fase 0; implementação e UI chegam na Fase 1/2.
abstract interface class VehiclesRepository {
  Future<Result<List<Vehicle>>> getVehicles();
  Future<Result<Vehicle>> createVehicle(Vehicle vehicle);
  Future<Result<Vehicle>> updateVehicle(Vehicle vehicle);
  Future<Result<void>> deleteVehicle(String id);
}
