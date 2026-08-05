import '../../../../core/error/result.dart';
import '../entities/ride.dart';
import '../repositories/rides_repository.dart';

class CancelRideUseCase {
  const CancelRideUseCase(this._repository);

  final RidesRepository _repository;

  Future<Result<Ride>> call(String rideId) =>
      _repository.updateStatus(rideId, RideStatus.cancelled);
}
