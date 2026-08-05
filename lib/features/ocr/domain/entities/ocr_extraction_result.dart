import '../../../rides/domain/entities/ride.dart';

/// Resultado bruto da extração por IA de visão a partir de um print de
/// oferta de corrida. Nunca é salvo direto — vira um rascunho de [Ride]
/// que o motorista revisa e confirma na tela de corrida antes de gravar.
class OcrExtractionResult {
  const OcrExtractionResult({
    this.platform,
    this.category,
    this.originAddress,
    this.destinationAddress,
    this.grossAmount,
    this.distanceToPickupKm,
    this.tripDistanceKm,
    this.estimatedDurationMin,
    this.paymentMethod,
  });

  final RidePlatform? platform;
  final String? category;
  final String? originAddress;
  final String? destinationAddress;
  final double? grossAmount;
  final double? distanceToPickupKm;
  final double? tripDistanceKm;
  final int? estimatedDurationMin;
  final PaymentMethod? paymentMethod;

  /// Rascunho de corrida pronto pra pré-preencher o formulário de revisão.
  Ride toDraftRide() => Ride(
    id: '',
    driverId: '',
    source: RideSource.platformOcr,
    platform: platform ?? RidePlatform.other,
    status: RideStatus.pending,
    originAddress: originAddress,
    destinationAddress: destinationAddress,
    grossAmount: grossAmount,
    paymentMethod: paymentMethod,
    distanceToPickupKm: distanceToPickupKm,
    tripDistanceKm: tripDistanceKm,
    estimatedDurationMin: estimatedDurationMin,
    category: category,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
