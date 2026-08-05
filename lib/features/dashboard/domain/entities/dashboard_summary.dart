/// Resumo agregado exibido no Dashboard. Calculado no Postgres via RPC
/// (`get_dashboard_summary`, migration 0004) — evita puxar todas as corridas
/// do período só para somar no cliente.
class DashboardSummary {
  const DashboardSummary({
    required this.periodStart,
    required this.periodEnd,
    required this.totalRides,
    required this.grossAmount,
    required this.totalKm,
  });

  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalRides;
  final double grossAmount;
  final double totalKm;

  double get amountPerKm => totalKm == 0 ? 0 : grossAmount / totalKm;
}
