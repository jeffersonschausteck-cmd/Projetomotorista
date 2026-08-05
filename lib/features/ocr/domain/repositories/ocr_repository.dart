import 'dart:typed_data';

import '../../../../core/error/result.dart';
import '../entities/ocr_extraction_result.dart';

abstract interface class OcrRepository {
  /// Envia os bytes da imagem (print da tela de oferta) pra Edge Function,
  /// que chama a IA de visão e devolve os campos extraídos já estruturados.
  /// A imagem nunca é persistida — só passa pela função e é descartada.
  Future<Result<OcrExtractionResult>> extractRideFromImage(Uint8List imageBytes);
}
