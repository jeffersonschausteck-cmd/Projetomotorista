/// Resumo agregado exibido no Dashboard. Calculado no Postgres via RPC
/// (`get_dashboard_summary`, migrations 0004 e 0006) — evita puxar todas as
/// corridas/despesas do período só para somar no cliente.
class DashboardSummary {
  const DashboardSummary({
    required this.periodStart,
    required this.periodEnd,
    required this.totalRides,
    required this.grossAmount,
    required this.totalKm,
    required this.totalExpenses,
    required this.netAmount,
  });

  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalRides;
  final double grossAmount;
  final double totalKm;
  final double totalExpenses;
  final double netAmount;

  double get amountPerKm => totalKm == 0 ? 0 : grossAmount / totalKm;
}
