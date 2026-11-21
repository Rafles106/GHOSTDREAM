import 'package:latlong2/latlong.dart';

class CampusSpot {
  final String id;
  final String name;
  final String category;
  final String description;
  final String distance;
  final double fare;
  final bool isPopular;
  final LatLng coordinate;

  const CampusSpot({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.distance = '300 m',
    this.fare = 5000.0,
    this.isPopular = false,
    required this.coordinate,
  });
}
