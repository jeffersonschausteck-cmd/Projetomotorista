import '../../domain/entities/ride.dart';

const _sourceValues = {
  RideSource.manual: 'manual',
  RideSource.scheduled: 'scheduled',
  RideSource.platformOcr: 'platform_ocr',
};

const _platformValues = {
  RidePlatform.particular: 'particular',
  RidePlatform.uber: 'uber',
  RidePlatform.p99: '99',
  RidePlatform.inDrive: 'indrive',
  RidePlatform.maxim: 'maxim',
  RidePlatform.other: 'other',
};

const _statusValues = {
  RideStatus.pending: 'pending',
  RideStatus.accepted: 'accepted',
  RideStatus.declined: 'declined',
  RideStatus.inProgress: 'in_progress',
  RideStatus.completed: 'completed',
  RideStatus.cancelled: 'cancelled',
};

const _paymentMethodValues = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.pix: 'pix',
  PaymentMethod.card: 'card',
  PaymentMethod.app: 'app',
  PaymentMethod.other: 'other',
};

T _enumFromDb<T>(Map<T, String> values, String? dbValue, T fallback) {
  if (dbValue == null) return fallback;
  for (final entry in values.entries) {
    if (entry.value == dbValue) return entry.key;
  }
  return fallback;
}

String? _enumToDb<T>(Map<T, String> values, T? value) =>
    value == null ? null : values[value];

DateTime? _parseDate(String? value) => value == null ? null : DateTime.parse(value);

double? _parseDouble(num? value) => value?.toDouble();

Ride rideFromRow(Map<String, dynamic> row) {
  return Ride(
    id: row['id'] as String,
    driverId: row['driver_id'] as String,
    clientId: row['client_id'] as String?,
    vehicleId: row['vehicle_id'] as String?,
    source: _enumFromDb(_sourceValues, row['source'] as String?, RideSource.manual),
    platform: _enumFromDb(
      _platformValues,
      row['platform'] as String?,
      RidePlatform.particular,
    ),
    status: _enumFromDb(_statusValues, row['status'] as String?, RideStatus.pending),
    originAddress: row['origin_address'] as String?,
    originLat: _parseDouble(row['origin_lat'] as num?),
    originLng: _parseDouble(row['origin_lng'] as num?),
    destinationAddress: row['destination_address'] as String?,
    destinationLat: _parseDouble(row['destination_lat'] as num?),
    destinationLng: _parseDouble(row['destination_lng'] as num?),
    scheduledAt: _parseDate(row['scheduled_at'] as String?),
    acceptedAt: _parseDate(row['accepted_at'] as String?),
    startedAt: _parseDate(row['started_at'] as String?),
    completedAt: _parseDate(row['completed_at'] as String?),
    cancelledAt: _parseDate(row['cancelled_at'] as String?),
    grossAmount: _parseDouble(row['gross_amount'] as num?),
    paymentMethod: row['payment_method'] == null
        ? null
        : _enumFromDb(_paymentMethodValues, row['payment_method'] as String?, PaymentMethod.other),
    distanceToPickupKm: _parseDouble(row['distance_to_pickup_km'] as num?),
    tripDistanceKm: _parseDouble(row['trip_distance_km'] as num?),
    estimatedDurationMin: row['estimated_duration_min'] as int?,
    notes: row['notes'] as String?,
    createdAt: DateTime.parse(row['created_at'] as String),
    updatedAt: DateTime.parse(row['updated_at'] as String),
  );
}

Map<String, dynamic> rideToInsertRow(Ride ride, {required String driverId}) {
  return {
    'driver_id': driverId,
    'client_id': ride.clientId,
    'vehicle_id': ride.vehicleId,
    'source': _enumToDb(_sourceValues, ride.source),
    'platform': _enumToDb(_platformValues, ride.platform),
    'status': _enumToDb(_statusValues, ride.status),
    'origin_address': ride.originAddress,
    'destination_address': ride.destinationAddress,
    'scheduled_at': ride.scheduledAt?.toIso8601String(),
    'gross_amount': ride.grossAmount,
    'payment_method': _enumToDb(_paymentMethodValues, ride.paymentMethod),
    'notes': ride.notes,
  };
}
