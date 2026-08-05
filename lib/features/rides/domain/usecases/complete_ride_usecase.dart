import '../../../../core/error/result.dart';
import '../entities/ride.dart';
import '../entities/route_point.dart';
import '../repositories/rides_repository.dart';
import '../services/route_distance_calculator.dart';

class CompleteRideUseCase {
  const CompleteRideUseCase(this._repository);

  final RidesRepository _repository;

  Future<Result<Ride>> call(String rideId, List<RoutePoint> routePoints) {
    final tripDistanceKm = RouteDistanceCalculator.totalDistanceKm(routePoints);
    return _repository.completeRide(
      rideId,
      tripDistanceKm: tripDistanceKm,
      routePoints: routePoints,
    );
  }
}
