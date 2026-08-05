/// Um ponto GPS capturado durante o rastreamento em primeiro plano de uma
/// corrida (entre "iniciar" e "finalizar"). Ver 0008_add_ride_route_points.sql.
class RoutePoint {
  const RoutePoint({required this.lat, required this.lng, required this.recordedAt});

  final double lat;
  final double lng;
  final DateTime recordedAt;
}
