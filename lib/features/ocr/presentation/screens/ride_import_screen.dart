import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../rides/presentation/screens/ride_form_screen.dart';
import '../providers/ocr_provider.dart';

/// Ponto de entrada da Fase 3: motorista tira/escolhe um print da oferta de
/// corrida, a IA de visão extrai os dados e abre o formulário de corrida já
/// pré-preenchido — mas SEMPRE pra revisão manual antes de salvar, nunca
/// grava direto.
class RideImportScreen extends ConsumerStatefulWidget {
  const RideImportScreen({super.key});

  @override
  ConsumerState<RideImportScreen> createState() => _RideImportScreenState();
}

class _RideImportScreenState extends ConsumerState<RideImportScreen> {
  bool _isProcessing = false;

  Future<void> _pickAndExtract(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _isProcessing = true);
    final bytes = await picked.readAsBytes();
    if (!mounted) return;

    final extraction = await ref.read(rideImportControllerProvider.notifier).extract(bytes);

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (extraction == null) return;

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RideFormScreen(prefill: extraction.toDraftRide())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final failure = ref.watch(rideImportControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Importar corrida (foto)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.document_scanner_outlined, size: 72),
              const SizedBox(height: 16),
              const Text(
                'Tire um print da oferta de corrida no app e a gente preenche os '
                'dados pra você conferir e salvar.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_isProcessing) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Lendo a imagem...'),
              ] else ...[
                FilledButton.icon(
                  onPressed: () => _pickAndExtract(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Tirar foto'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _pickAndExtract(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Escolher da galeria'),
                ),
              ],
              if (failure != null && !_isProcessing) ...[
                const SizedBox(height: 24),
                Text(
                  failure.message,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
