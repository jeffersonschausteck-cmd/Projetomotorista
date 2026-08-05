import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/ride.dart';
import '../../domain/entities/route_point.dart';
import '../../domain/services/route_distance_calculator.dart';
import '../providers/rides_provider.dart';
import 'ride_form_screen.dart';

/// Rastreamento em primeiro plano (Fase 4): a tela precisa ficar aberta
/// enquanto a corrida está em andamento — sem location em segundo plano por
/// ora. Ao finalizar, a distância real vira `trip_distance_km` e os pontos
/// capturados viram o breadcrumb salvo em `rides.route_points`.
class RideTrackingScreen extends ConsumerStatefulWidget {
  const RideTrackingScreen({required this.ride, super.key});

  final Ride ride;

  @override
  ConsumerState<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

enum _TrackingState { starting, permissionDenied, serviceDisabled, tracking, finishing }

class _RideTrackingScreenState extends ConsumerState<RideTrackingScreen> {
  StreamSubscription<Position>? _positionSub;
  Timer? _clock;
  final List<RoutePoint> _points = [];
  DateTime? _trackingStartedAt;
  _TrackingState _state = _TrackingState.starting;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _clock?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    if (widget.ride.status != RideStatus.inProgress) {
      final ok = await ref
          .read(rideActionsControllerProvider.notifier)
          .start(widget.ride.id);
      if (!mounted) return;
      if (!ok) {
        final failure = ref.read(rideActionsControllerProvider);
        setState(() {
          _state = _TrackingState.permissionDenied;
          _errorMessage = failure?.message ?? 'Não deu pra iniciar a corrida.';
        });
        return;
      }
    }
    await _startLocationStream();
  }

  Future<void> _startLocationStream() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _state = _TrackingState.serviceDisabled);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (!mounted) return;
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _state = _TrackingState.permissionDenied);
      return;
    }

    _trackingStartedAt = DateTime.now();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      setState(() {
        _points.add(
          RoutePoint(lat: position.latitude, lng: position.longitude, recordedAt: DateTime.now()),
        );
      });
    });

    setState(() => _state = _TrackingState.tracking);
  }

  Future<void> _finish() async {
    setState(() => _state = _TrackingState.finishing);
    await _positionSub?.cancel();
    _clock?.cancel();

    final actions = ref.read(rideActionsControllerProvider.notifier);
    final ok = await actions.complete(widget.ride.id, _points);

    if (!mounted) return;
    if (!ok) {
      final failure = ref.read(rideActionsControllerProvider);
      setState(() {
        _state = _TrackingState.tracking;
        _errorMessage = failure?.message ?? 'Não deu pra finalizar a corrida.';
      });
      return;
    }

    final rides = await ref.read(ridesListProvider.future);
    var updated = widget.ride;
    for (final r in rides) {
      if (r.id == widget.ride.id) {
        updated = r;
        break;
      }
    }
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => RideFormScreen(ride: updated)));
  }

  Future<void> _cancelRide() async {
    await _positionSub?.cancel();
    _clock?.cancel();
    final ok = await ref
        .read(rideActionsControllerProvider.notifier)
        .cancel(widget.ride.id);
    if (!mounted) return;
    if (ok) Navigator.of(context).pop();
  }

  String _formatElapsed() {
    if (_trackingStartedAt == null) return '00:00';
    final elapsed = DateTime.now().difference(_trackingStartedAt!);
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final distanceKm = RouteDistanceCalculator.totalDistanceKm(_points);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Corrida em andamento'),
        actions: [
          if (_state == _TrackingState.tracking)
            TextButton(
              onPressed: _cancelRide,
              child: const Text('Cancelar corrida', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: SafeArea(child: _buildBody(context, distanceKm)),
    );
  }

  Widget _buildBody(BuildContext context, double distanceKm) {
    switch (_state) {
      case _TrackingState.starting:
        return const Center(child: CircularProgressIndicator());
      case _TrackingState.permissionDenied:
        return _ErrorState(
          message:
              _errorMessage ??
              'Permissão de localização negada. Ative nas configurações do app pra rastrear a corrida.',
          onRetry: _init,
        );
      case _TrackingState.serviceDisabled:
        return _ErrorState(
          message: 'O GPS do aparelho está desligado. Ative e tente de novo.',
          onRetry: _init,
        );
      case _TrackingState.tracking:
      case _TrackingState.finishing:
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gps_fixed, size: 64),
              const SizedBox(height: 24),
              Text(
                '${distanceKm.toStringAsFixed(2)} km',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(_formatElapsed(), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                '${_points.length} pontos capturados',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _state == _TrackingState.finishing ? null : _finish,
                icon: _state == _TrackingState.finishing
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.flag_outlined),
                label: const Text('Finalizar corrida'),
              ),
            ],
          ),
        );
    }
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off_outlined, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            OutlinedButton(onPressed: onRetry, child: const Text('Tentar de novo')),
          ],
        ),
      ),
    );
  }
}
