import 'dart:math';

import '../entities/route_point.dart';

/// Soma a distância entre pontos GPS consecutivos (fórmula de Haversine) —
/// como o rastreamento é em primeiro plano com pontos frequentes, a soma dos
/// segmentos é uma aproximação boa o suficiente da distância real percorrida.
class RouteDistanceCalculator {
  const RouteDistanceCalculator._();

  static const _earthRadiusKm = 6371.0;

  static double totalDistanceKm(List<RoutePoint> points) {
    if (points.length < 2) return 0;

    var total = 0.0;
    for (var i = 1; i < points.length; i++) {
      total += _haversineKm(points[i - 1], points[i]);
    }
    return total;
  }

  static double _haversineKm(RoutePoint a, RoutePoint b) {
    final dLat = _degToRad(b.lat - a.lat);
    final dLng = _degToRad(b.lng - a.lng);
    final lat1 = _degToRad(a.lat);
    final lat2 = _degToRad(b.lat);

    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(h), sqrt(1 - h));
    return _earthRadiusKm * c;
  }

  static double _degToRad(double deg) => deg * pi / 180;
}
