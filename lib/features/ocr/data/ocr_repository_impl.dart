import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../../rides/domain/entities/ride.dart';
import '../domain/entities/ocr_extraction_result.dart';
import '../domain/repositories/ocr_repository.dart';

const _platformValues = {
  'particular': RidePlatform.particular,
  'uber': RidePlatform.uber,
  '99': RidePlatform.p99,
  'indrive': RidePlatform.inDrive,
  'maxim': RidePlatform.maxim,
  'other': RidePlatform.other,
};

const _paymentMethodValues = {
  'cash': PaymentMethod.cash,
  'pix': PaymentMethod.pix,
  'card': PaymentMethod.card,
  'app': PaymentMethod.app,
  'other': PaymentMethod.other,
};

class OcrRepositoryImpl implements OcrRepository {
  OcrRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _functionName = 'extract-ride-from-image';

  @override
  Future<Result<OcrExtractionResult>> extractRideFromImage(Uint8List imageBytes) async {
    try {
      final response = await _client.functions.invoke(
        _functionName,
        body: {'image_base64': base64Encode(imageBytes)},
      );

      final data = response.data as Map<String, dynamic>;
      return Success(
        OcrExtractionResult(
          platform: _platformValues[data['platform'] as String?],
          category: data['category'] as String?,
          originAddress: data['origin_address'] as String?,
          destinationAddress: data['destination_address'] as String?,
          grossAmount: (data['gross_amount'] as num?)?.toDouble(),
          distanceToPickupKm: (data['distance_to_pickup_km'] as num?)?.toDouble(),
          tripDistanceKm: (data['trip_distance_km'] as num?)?.toDouble(),
          estimatedDurationMin: data['estimated_duration_min'] as int?,
          paymentMethod: _paymentMethodValues[data['payment_method'] as String?],
        ),
      );
    } on FunctionException catch (e) {
      final details = e.details;
      final message = details is Map && details['error'] is String
          ? details['error'] as String
          : e.reasonPhrase ?? 'Falha ao extrair dados da imagem.';
      return Error(UnexpectedFailure('Não deu pra ler a imagem: $message'));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
