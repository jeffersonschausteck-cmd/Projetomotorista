import 'package:flutter/material.dart';

/// Placeholder para telas cuja implementação está agendada para uma fase
/// futura do roadmap — mantém a navegação real e testável desde a Fase 0.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({required this.title, required this.phase, super.key});

  final String title;
  final String phase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title chega na $phase.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
