import 'route_point.dart';

/// Espelha `rides` (supabase/migrations/0001_init_core_schema.sql).
enum RideSource { manual, scheduled, platformOcr }

enum RidePlatform { particular, uber, p99, inDrive, maxim, other }

enum RideStatus { pending, accepted, declined, inProgress, completed, cancelled }

enum PaymentMethod { cash, pix, card, app, other }

class Ride {
  const Ride({
    required this.id,
    required this.driverId,
    required this.source,
    required this.platform,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.clientId,
    this.vehicleId,
    this.originAddress,
    this.originLat,
    this.originLng,
    this.destinationAddress,
    this.destinationLat,
    this.destinationLng,
    this.scheduledAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.grossAmount,
    this.paymentMethod,
    this.distanceToPickupKm,
    this.tripDistanceKm,
    this.estimatedDurationMin,
    this.category,
    this.notes,
    this.routePoints = const [],
  });

  final String id;
  final String driverId;
  final String? clientId;
  final String? vehicleId;

  final RideSource source;
  final RidePlatform platform;
  final RideStatus status;

  final String? originAddress;
  final double? originLat;
  final double? originLng;
  final String? destinationAddress;
  final double? destinationLat;
  final double? destinationLng;

  final DateTime? scheduledAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  final double? grossAmount;
  final PaymentMethod? paymentMethod;

  final double? distanceToPickupKm;
  final double? tripDistanceKm;
  final int? estimatedDurationMin;

  /// Categoria da oferta (ex: "UberX", "99 Comfort") — texto livre, varia
  /// demais entre plataformas para virar enum. Ver 0007_add_ride_category.sql.
  final String? category;

  final String? notes;

  /// Breadcrumb GPS capturado durante o rastreamento em primeiro plano
  /// (Fase 4). Ver 0008_add_ride_route_points.sql.
  final List<RoutePoint> routePoints;

  final DateTime createdAt;
  final DateTime updatedAt;
}
