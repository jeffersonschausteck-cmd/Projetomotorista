/// Resumo agregado exibido no Dashboard (Fase 1: calculado client-side a
/// partir de `RidesRepository`; Fase 5: passa a vir de views SQL agregadas).
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
