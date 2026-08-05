import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/ride.dart';
import 'ride_status_badge.dart';

class RideCard extends StatelessWidget {
  const RideCard({
    required this.ride,
    this.onTap,
    this.onAccept,
    this.onDecline,
    this.onCancel,
    super.key,
  });

  final Ride ride;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onCancel;

  static final _dateFormat = DateFormat('dd/MM • HH:mm', 'pt_BR');
  static final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (ride.originAddress != null) ride.originAddress,
      if (ride.destinationAddress != null) '→ ${ride.destinationAddress}',
    ].whereType<String>().join(' ');

    final when = ride.scheduledAt ?? ride.completedAt ?? ride.createdAt;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_dateFormat.format(when)),
                  RideStatusBadge(status: ride.status),
                ],
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
              if (ride.grossAmount != null) ...[
                const SizedBox(height: 8),
                Text(
                  _currencyFormat.format(ride.grossAmount),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
              if (onAccept != null || onDecline != null || onCancel != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    if (onAccept != null)
                      FilledButton.tonal(onPressed: onAccept, child: const Text('Aceitar')),
                    if (onDecline != null)
                      OutlinedButton(onPressed: onDecline, child: const Text('Recusar')),
                    if (onCancel != null)
                      TextButton(onPressed: onCancel, child: const Text('Cancelar')),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
