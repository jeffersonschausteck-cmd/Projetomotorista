import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/ocr_repository_impl.dart';
import '../../domain/entities/ocr_extraction_result.dart';
import '../../domain/repositories/ocr_repository.dart';

part 'ocr_provider.g.dart';

@Riverpod(keepAlive: true)
OcrRepository ocrRepository(Ref ref) => OcrRepositoryImpl(ref.watch(supabaseClientProvider));

@riverpod
class RideImportController extends _$RideImportController {
  @override
  Failure? build() => null;

  Future<OcrExtractionResult?> extract(Uint8List imageBytes) async {
    state = null;
    final result = await ref.read(ocrRepositoryProvider).extractRideFromImage(imageBytes);
    return result.when(
      success: (extraction) => extraction,
      failure: (f) {
        state = f;
        return null;
      },
    );
  }
}
