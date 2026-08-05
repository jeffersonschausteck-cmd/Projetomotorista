import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/rides_repository_impl.dart';
import '../../domain/entities/ride.dart';
import '../../domain/entities/route_point.dart';
import '../../domain/repositories/rides_repository.dart';
import '../../domain/usecases/accept_ride_usecase.dart';
import '../../domain/usecases/cancel_ride_usecase.dart';
import '../../domain/usecases/complete_ride_usecase.dart';
import '../../domain/usecases/decline_ride_usecase.dart';
import '../../domain/usecases/start_ride_usecase.dart';

part 'rides_provider.g.dart';

@Riverpod(keepAlive: true)
RidesRepository ridesRepository(Ref ref) =>
    RidesRepositoryImpl(ref.watch(supabaseClientProvider));

@riverpod
AcceptRideUseCase acceptRideUseCase(Ref ref) =>
    AcceptRideUseCase(ref.watch(ridesRepositoryProvider));

@riverpod
DeclineRideUseCase declineRideUseCase(Ref ref) =>
    DeclineRideUseCase(ref.watch(ridesRepositoryProvider));

@riverpod
CancelRideUseCase cancelRideUseCase(Ref ref) =>
    CancelRideUseCase(ref.watch(ridesRepositoryProvider));

@riverpod
StartRideUseCase startRideUseCase(Ref ref) =>
    StartRideUseCase(ref.watch(ridesRepositoryProvider));

@riverpod
CompleteRideUseCase completeRideUseCase(Ref ref) =>
    CompleteRideUseCase(ref.watch(ridesRepositoryProvider));

@riverpod
class RidesList extends _$RidesList {
  @override
  Future<List<Ride>> build() async {
    final result = await ref.watch(ridesRepositoryProvider).getRides();
    return result.when(success: (rides) => rides, failure: (f) => throw f);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class RideActionsController extends _$RideActionsController {
  @override
  Failure? build() => null;

  Future<bool> accept(String rideId) =>
      _run(() => ref.read(acceptRideUseCaseProvider).call(rideId));

  Future<bool> decline(String rideId) =>
      _run(() => ref.read(declineRideUseCaseProvider).call(rideId));

  Future<bool> cancel(String rideId) =>
      _run(() => ref.read(cancelRideUseCaseProvider).call(rideId));

  Future<bool> start(String rideId) =>
      _run(() => ref.read(startRideUseCaseProvider).call(rideId));

  Future<bool> complete(String rideId, List<RoutePoint> routePoints) => _run(
    () => ref.read(completeRideUseCaseProvider).call(rideId, routePoints),
  );

  Future<bool> _run(Future<dynamic> Function() action) async {
    state = null;
    final result = await action();
    return result.when(
      success: (_) {
        ref.invalidate(ridesListProvider);
        return true;
      },
      failure: (f) {
        state = f;
        return false;
      },
    );
  }
}

@riverpod
class RideFormController extends _$RideFormController {
  @override
  Failure? build() => null;

  Future<bool> save(Ride ride, {String? existingId}) async {
    state = null;
    final repository = ref.read(ridesRepositoryProvider);
    final result = existingId == null
        ? await repository.createRide(ride)
        : await repository.updateRide(ride);

    return result.when(
      success: (_) {
        ref.invalidate(ridesListProvider);
        return true;
      },
      failure: (f) {
        state = f;
        return false;
      },
    );
  }
}
