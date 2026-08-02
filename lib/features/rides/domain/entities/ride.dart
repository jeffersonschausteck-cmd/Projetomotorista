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
    this.notes,
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

  final String? notes;

  final DateTime createdAt;
  final DateTime updatedAt;
}
