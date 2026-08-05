import 'package:intl/intl.dart';

import '../entities/ride.dart';

/// Texto do recibo enviado por WhatsApp (Fase 4) — função pura, sem
/// dependência de UI ou de rede, pra facilitar teste unitário.
String buildRideReceiptMessage(Ride ride, {String? clientName}) {
  final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final dateFormat = DateFormat("dd/MM/yyyy 'às' HH:mm", 'pt_BR');
  final when = ride.completedAt ?? ride.scheduledAt ?? ride.createdAt;

  final lines = <String>[
    'Olá${clientName != null && clientName.isNotEmpty ? ', $clientName' : ''}! Segue o recibo da corrida:',
    '',
    'Data: ${dateFormat.format(when)}',
    if (ride.originAddress != null) 'De: ${ride.originAddress}',
    if (ride.destinationAddress != null) 'Para: ${ride.destinationAddress}',
    if (ride.grossAmount != null) 'Valor: ${currency.format(ride.grossAmount)}',
    '',
    'Obrigado pela preferência!',
  ];

  return lines.join('\n');
}
