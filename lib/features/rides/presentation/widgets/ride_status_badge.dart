import 'package:flutter/material.dart';

import '../../domain/entities/ride.dart';

class RideStatusBadge extends StatelessWidget {
  const RideStatusBadge({required this.status, super.key});

  final RideStatus status;

  (String, Color) _labelAndColor(ColorScheme scheme) => switch (status) {
    RideStatus.pending => ('Pendente', Colors.orange),
    RideStatus.accepted => ('Aceita', scheme.primary),
    RideStatus.declined => ('Recusada', scheme.error),
    RideStatus.inProgress => ('Em andamento', scheme.primary),
    RideStatus.completed => ('Concluída', Colors.green),
    RideStatus.cancelled => ('Cancelada', scheme.error),
  };

  @override
  Widget build(BuildContext context) {
    final (label, color) = _labelAndColor(Theme.of(context).colorScheme);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
